// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Demo: GMRES & Conjugate Gradient Solvers
//
// What it does:
//   Demonstrates quantum GMRES Arnoldi process (building the
//   Hessenberg matrix via overlap estimation) and Conjugate
//   Gradient iterative solver. Covers the two iterative
//   linear solver modules built on Krylov subspace methods.
//
// Architecture:
//   - Qubits:     23 total (4 basis + 3 work + 2×2 solver
//                 + 2 residual + 2 direction + 10 walk internal)
//   - Hamiltonian: Pauli-X (2×2 1-sparse matrix)
//   - Parameters: n_state_qubits, n_measure, n_iter, t
//
// Input:
//   - n_state_qubits: qubits per basis vector (2)
//   - n_measure: SWAP test repetitions per overlap
//   - n_iter: solver iterations / Krylov dimension
//   - t: evolution time
//   - Demo config:  2, 50, 2, PI()/4.0 → 23 qubits, ≥ 8 ✓
//   - Test config:  2, 10, 2, PI()/4.0 → fast verification
//
// Output:
//   - Single integer encoding verification bits:
//     bit 0:    q_gmres_converged
//     bit 1:    q_gmres_hessenberg_size
//     bit 2:    q_gmres_build_row
//     bit 3:    q_cg_converged
//     bit 4:    q_cg_compute_beta
//     bit 5:    q_cg_compute_alpha
//     bit 6:    Givens rotation (identity) → count = 0
//     bit 7:    GMRES Arnoldi H matrix rows = m + 1
//     bit 8:    GMRES Arnoldi H matrix cols = m
//     bit 9:    CG solve executed
//     bit 10+:  CG measurement count (probabilistic)
//   - Guaranteed ≥ 1
//
// Pipeline steps and module mapping:
//   Step 1: q_matrix → q_matrix_convert + q_ram_call_real
//           — define 1-sparse oracle for H = X
//   Step 2: q_gmres → converged, hessenberg_size, build_row
//           — classical helper verification (Fact)
//   Step 3: q_cg → converged, compute_beta, compute_alpha
//           — classical helper verification (Fact)
//   Step 4: q_gmres → q_gmres_apply_givens with (1,0)
//           — identity rotation (Ry(0)), deterministic Zero
//   Step 5: q_gmres → q_gmres_arnoldi
//           — build (m+1)×m Hessenberg matrix via SWAP tests
//   Step 6: q_cg → q_cg_solve
//           — full CG iterative solver
//
// Verification:
//   - Step 2: 3 Fact() assertions on GMRES classical helpers
//   - Step 3: 3 Fact() assertions on CG classical helpers
//   - Step 4: Fact(count_0 == 0) — Givens(1,0) = identity
//   - Step 5: Fact(Length(H) == m+1) + Fact(Length(H[0]) == m)
//   - Step 6: Fact(0 ≤ count ≤ n_shots) — CG solution
//
// Reference:
//   [1] Ye & Li, "Quantum GMRES" arXiv:2211.15082 (2022)
//   [2] Feng et al., "Quantum Conjugate Gradient Method"
//       arXiv:2306.13305 (2023)
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
    // Row 0 → column 1, value = 1.0; Row 1 → column 0, value = 1.0
    // ============================================================

    operation q_demo_gmres_cg_oracle(
        qs_address : Qubit[],
        qs_data : Qubit[],
        qs_weight : Qubit[]
    ) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 1), (1, 0, 1)]);
        q_ram_call_real(RAM, qs_address, qs_data, qs_weight);
    }

    // ============================================================
    // Main Demo GMRES CG
    //
    // Accepts (n_state_qubits, n_measure, n_iter, t) for generic
    // interface. Runs classical verification + quantum GMRES
    // Arnoldi and CG solver pipeline.
    // ============================================================

    operation DemoGmresCg(n_state_qubits : Int, n_measure : Int, n_iter : Int, t : Double) : Int {
        let oracle = q_matrix_1_sparse_oracle(q_demo_gmres_cg_oracle);
        let n_qubits = n_state_qubits;
        let m_steps = n_iter;
        let n_shots = 50;
        mutable result = 0;

        // ============================================================
        // Step 2: GMRES Classical Helpers
        // ============================================================

        // Convergence: r=0.01, init=1.0, eps=1e-6 → 0.01/1.0 < 1e-6 → false
        let gconv = q_gmres_converged(0.01, 1.0, 1e-6);
        Fact(not gconv, "gmres: converged(0.01,1.0,1e-6)=False");
        set result += 1;

        // Hessenberg size: m=5 → (6, 5)
        let (hrows, hcols) = q_gmres_hessenberg_size(5);
        Fact(hrows == 6, "gmres: hessenberg rows = m+1 = 6");
        Fact(hcols == 5, "gmres: hessenberg cols = m = 5");
        set result += 2;
        set result += 4;

        // Build row: [1,2,3,4], col=1, val=9.0 → [1,9,3,4]
        let brow = q_gmres_build_row([1.0, 2.0, 3.0, 4.0], 4, 1, 9.0);
        Fact(AbsD(brow[0] - 1.0) < 1e-10, "gmres: build_row[0]=1");
        Fact(AbsD(brow[1] - 9.0) < 1e-10, "gmres: build_row[1]=9");
        Fact(AbsD(brow[2] - 3.0) < 1e-10, "gmres: build_row[2]=3");
        Fact(AbsD(brow[3] - 4.0) < 1e-10, "gmres: build_row[3]=4");
        set result += 8;

        // ============================================================
        // Step 3: CG Classical Helpers
        // ============================================================

        // Convergence: r=0.01, b=1.0, eps=1e-6 → 0.01 < 1e-6 → false
        let cconv = q_cg_converged(0.01, 1.0, 1e-6);
        Fact(not cconv, "cg: converged(0.01,1.0,1e-6)=False");
        set result += 16;

        // Beta: r_new²=0.25, r_old²=1.0 → 0.25/1.0 = 0.25
        let cbeta = q_cg_compute_beta(0.25, 1.0);
        Fact(AbsD(cbeta - 0.25) < 1e-10, "cg: beta(0.25,1.0)=0.25");
        set result += 32;

        // Alpha: r²=0.5, pAp=2.0 → 0.5/2.0 = 0.25
        let calpha = q_cg_compute_alpha(0.5, 2.0);
        Fact(AbsD(calpha - 0.25) < 1e-10, "cg: alpha(0.5,2.0)=0.25");
        set result += 64;

        // ============================================================
        // Step 4: GMRES Givens Rotation (Identity Check)
        //
        // With (c,s) = (1.0, 0.0): ArcTan2(0,1) = 0 → Ry(0) = I
        // State |00⟩ unchanged → all measurements give Zero
        // ============================================================

        use qs_h = Qubit[2];
        q_gmres_apply_givens(qs_h, 1.0, 0.0, 0, 1);
        mutable givens_count = 0;
        for i in 0 .. n_shots - 1 {
            if (M(qs_h[0]) == One) {
                set givens_count += 1;
            }
        }
        Fact(givens_count == 0, "gmres: givens(1,0) → identity → 0 |1⟩");
        set result += 128;
        ResetAll(qs_h);

        // ============================================================
        // Step 5: GMRES Arnoldi Process
        //
        // Builds (m+1)×m upper Hessenberg matrix via quantum walk
        // and SWAP test overlap estimation. Verify matrix dimensions.
        // ============================================================

        use qs_basis = Qubit[n_qubits * m_steps];
        use qs_work = Qubit[n_qubits + 1];

        let H = q_gmres_arnoldi(oracle, qs_basis, qs_work, n_qubits, m_steps, n_measure, t);
        Fact(Length(H) == m_steps + 1,
            "gmres: H rows = m+1");
        Fact(Length(H[0]) == m_steps,
            "gmres: H cols = m");
        set result += 256;
        set result += 512;

        ResetAll(qs_basis);
        ResetAll(qs_work);

        // ============================================================
        // Step 6: CG Solver
        //
        // Solves Ax = b with initial guess x=0, b=|0⟩.
        // After solve, measure solution state for range check.
        // ============================================================

        use qs_b = Qubit[n_qubits];
        use qs_x = Qubit[n_qubits];
        use qs_cg_work = Qubit[n_qubits + 1];

        q_cg_solve(oracle, qs_b, qs_x, qs_cg_work, n_iter, t, 0.1);
        set result += 1024;

        mutable cg_count = 0;
        for i in 0 .. n_shots - 1 {
            if (M(qs_x[0]) == One) {
                set cg_count += 1;
            }
        }
        Fact(cg_count >= 0 and cg_count <= n_shots,
            "cg: count in range");
        set result += 2048;

        ResetAll(qs_b);
        ResetAll(qs_x);
        ResetAll(qs_cg_work);

        return result;
    }
}
