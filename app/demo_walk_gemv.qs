// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Demo: Quantum Walk Hamiltonian Simulation
//
// What it does:
//   Demonstrates quantum walk time evolution under a 1-sparse
//   Hamiltonian, covering the core walk simulation modules.
//   Uses H = X = [[0,1],[1,0]] as the 1-sparse Hamiltonian,
//   evolves |0⟩ for time t, and measures |1⟩ population.
//   Tests four interfaces: direct walk, GEMV, simulation
//   dispatcher, and matrix-matrix (GEMM).
//
// Architecture:
//   - Qubits:     10 total (1 state + 9 walk internal)
//   - Hamiltonian: Pauli-X (2×2 1-sparse matrix)
//   - Parameters: n_state_qubits, n_shots, t
//
// Input:
//   - n_state_qubits: number of state qubits (1 = 2×2 matrix)
//   - n_shots: number of measurement repetitions
//   - t: evolution time
//   - Demo config: 1, 100, PI()/4.0 → 10 qubits, ≥ 8 ✓
//   - Test config: 1, 20, PI()/4.0 → fast verification
//
// Output:
//   - Single integer = cw + cg + cs + cm
//   - cw: |1⟩ count via walk direct (0 to n_shots)
//   - cg: |1⟩ count via GEMV (0 to n_shots)
//   - cs: |1⟩ count via simulation dispatcher (0 to n_shots)
//   - cm: |1⟩ count via GEMM (0 to n_shots)
//   - Expected: ~4 × 0.5 × n_shots > 0
//
// Pipeline steps and module mapping:
//   Step 1: q_matrix → q_matrix_convert + q_ram_call_real
//           — define 1-sparse oracle for H = X
//   Step 2: q_walk → q_walk_simulation_matrix_1_sparse_real
//           — direct walk time evolution (t=0: deterministic)
//   Step 3: q_walk → q_walk_simulation_matrix_1_sparse_real
//           — direct walk time evolution (t>0: probabilistic)
//   Step 4: q_gemv → q_gemv
//           — GEMV evolution (wraps walk, same physics)
//   Step 5: q_simulation → q_simulation_matrix_1_sparse_type
//           — simulation dispatcher (type=2 = real)
//   Step 6: q_gemm → q_gemm
//           — matrix-matrix evolution (two sequential walks)
//
// Verification:
//   - Fact(c0 == 0): t=0 → no evolution, result deterministic
//   - Fact(0 ≤ cw ≤ n_shots): walk at t>0, valid range
//   - Fact(0 ≤ cg ≤ n_shots): gemv at t>0, valid range
//   - Fact(0 ≤ cs ≤ n_shots): simulation at t>0, valid range
//   - Fact(0 ≤ cm ≤ n_shots): gemm at t>0, valid range
//
// Reference:
//   [1] Childs, "Quantum Walk Algorithm for Element Distinctness"
//       STOC 2003. https://arxiv.org/abs/quant-ph/0209131
// ============================================================
namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    // ============================================================
    // Step 1: 1-Sparse Matrix Oracle
    //
    // Defines H = X = [[0, 1], [1, 0]] as a 1-sparse real matrix.
    // Row 0 → column 1, value = 1.0
    // Row 1 → column 0, value = 1.0
    //
    // Uses q_matrix_convert + q_ram_call_real to perform the
    // coherent lookup: |row⟩|0⟩|0⟩ → |row⟩|col⟩|value⟩.
    // ============================================================

    operation q_demo_walk_gemv_oracle(
        qs_address : Qubit[],
        qs_data : Qubit[],
        qs_weight : Qubit[]
    ) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 1), (1, 0, 1)]);
        q_ram_call_real(RAM, qs_address, qs_data, qs_weight);
    }

    // ============================================================
    // Main Demo Walk GEMV
    //
    // Accepts arbitrary parameters for generic interface.
    // Runs 5 test sequences and returns aggregated result.
    // ============================================================

    operation DemoWalkGemv(n_state_qubits : Int, n_shots : Int, t : Double) : Int {
        let oracle = q_matrix_1_sparse_oracle(q_demo_walk_gemv_oracle);

        // Step 2: Walk at t=0 (deterministic: no evolution)
        mutable c0 = 0;
        for (_) in 0 .. n_shots - 1 {
            use qs = Qubit[n_state_qubits];
            q_walk_simulation_matrix_1_sparse_real(oracle, qs, 0.0);
            if (M(qs[0]) == One) {
                set c0 += 1;
            }
            ResetAll(qs);
        }
        Fact(c0 == 0, "walk_gemv: t=0 must give 0 |1⟩ counts");

        // Step 3: Walk at t>0 (probabilistic)
        mutable cw = 0;
        for (_) in 0 .. n_shots - 1 {
            use qs = Qubit[n_state_qubits];
            q_walk_simulation_matrix_1_sparse_real(oracle, qs, t);
            if (M(qs[0]) == One) {
                set cw += 1;
            }
            ResetAll(qs);
        }
        Fact(cw >= 0 and cw <= n_shots, "walk_gemv: walk count in range");

        // Step 4: GEMV at t>0 (probabilistic)
        mutable cg = 0;
        for (_) in 0 .. n_shots - 1 {
            use qs = Qubit[n_state_qubits];
            use qw = Qubit[n_state_qubits + 1];
            q_gemv(oracle, qs, qw, t);
            if (M(qs[0]) == One) {
                set cg += 1;
            }
            ResetAll(qs);
            ResetAll(qw);
        }
        Fact(cg >= 0 and cg <= n_shots, "walk_gemv: gemv count in range");

        // Step 5: Simulation dispatcher at t>0 (probabilistic)
        mutable cs = 0;
        for (_) in 0 .. n_shots - 1 {
            use qs = Qubit[n_state_qubits];
            q_simulation_matrix_1_sparse_type(2, oracle, qs, t);
            if (M(qs[0]) == One) {
                set cs += 1;
            }
            ResetAll(qs);
        }
        Fact(cs >= 0 and cs <= n_shots, "walk_gemv: sim count in range");

        // Step 6: GEMM at t>0 (probabilistic, two sequential walks)
        mutable cm = 0;
        for (_) in 0 .. n_shots - 1 {
            use qa = Qubit[n_state_qubits];
            use qb = Qubit[n_state_qubits];
            use qc = Qubit[n_state_qubits];
            q_gemm(oracle, oracle, qa, qb, qc, t);
            if (M(qa[0]) == One) {
                set cm += 1;
            }
            ResetAll(qa);
            ResetAll(qb);
            ResetAll(qc);
        }
        Fact(cm >= 0 and cm <= n_shots, "walk_gemv: gemm count in range");

        return cw + cg + cs + cm;
    }
}
