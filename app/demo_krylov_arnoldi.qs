// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Demo: Krylov Subspace & Lanczos Tridiagonalization
//
// What it does:
//   Demonstrates quantum Krylov subspace generation and Lanczos
//   tridiagonalization using quantum walk for matrix-vector
//   products and SWAP tests for overlap estimation. Covers the
//   Krylov and Lanczos modules that form the foundation for
//   iterative quantum linear solvers.
//
// Architecture:
//   - Qubits:     21 total (4 basis + 3 work + 2 temp + 2 copy
//                 + 10 walk internal)
//   - Hamiltonian: Pauli-X (2×2 1-sparse matrix)
//   - Parameters: n_state_qubits, n_measure, t
//
// Input:
//   - n_state_qubits: number of qubits per basis vector (2)
//   - n_measure: SWAP test repetitions per overlap
//   - t: evolution time
//   - Demo config:  2, 50, PI()/4.0 → 21 qubits, ≥ 8 ✓
//   - Test config:  2, 10, PI()/4.0 → fast verification
//
// Output:
//   - Single integer encoding verification bits:
//     bit 0:    q_krylov_converged
//     bit 1:    q_krylov_norm_sq
//     bit 2:    q_krylov_inner_product
//     bit 3:    q_lanczos_norm
//     bit 4-5:  q_lanczos_normalize
//     bit 6:    q_lanczos_alpha_compute
//     bit 7:    q_lanczos_beta_compute
//     bit 8:    q_lanczos_tridiag
//     bit 9:    q_lanczos_eigenvalue_sum
//     bit 10:   Krylov subspace generated
//     bit 11:   Lanczos apply matrix
//     bit 12:   Lanczos estimate alpha
//     bit 13:   Overlap self-test
//   - Expected: ≥ 1 (some bits may vary)
//
// Pipeline steps and module mapping:
//   Step 1: q_matrix → q_matrix_convert + q_ram_call_real
//           — define 1-sparse oracle for H = X
//   Step 2: q_krylov → converged, norm_sq, inner_product
//           — classical helper verification (Fact)
//   Step 3: q_lanczos → norm, normalize, alpha_compute,
//           beta_compute, tridiag, eigenvalue_sum
//           — classical helper verification (Fact)
//   Step 4: q_krylov → q_krylov_generate_subspace
//           — build Krylov basis {|v₀⟩, A|v₀⟩}
//   Step 5: q_lanczos → q_lanczos_apply_matrix
//           — apply A to basis vector (via q_gemv)
//   Step 6: q_lanczos → q_lanczos_estimate_alpha
//           — estimate αⱼ = ⟨vⱼ|A|vⱼ⟩ via SWAP test
//   Step 7: q_krylov → q_krylov_estimate_overlap
//           — test self-overlap |⟨v₀|v₀⟩|
//   Step 8: q_krylov → q_krylov_swap_test_one_shot
//           — single SWAP test on identical zero states
//
// Verification:
//   - Steps 2-3: 9 Fact() assertions on classical functions
//   - Step 6: Fact(AbsD(alpha - 1.0) < 0.1) — alpha near 1
//   - Step 7: Fact(AbsD(overlap - 1.0) < 0.1) — self-overlap
//   - Step 8: Fact(r == Zero) — identical zero states
//
// Reference:
//   [1] Castellano et al., "Quantum Krylov Subspace Methods
//       for Ground State Energy Estimation"
//       arXiv:2210.07913 (2022)
//   [2] Liu et al., "Quantum Eigenvalue Processing"
//       arXiv:2112.00778 (2021)
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
    // ============================================================

    operation q_demo_krylov_oracle(
        qs_address : Qubit[],
        qs_data : Qubit[],
        qs_weight : Qubit[]
    ) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 1), (1, 0, 1)]);
        q_ram_call_real(RAM, qs_address, qs_data, qs_weight);
    }

    // ============================================================
    // Main Demo Krylov Arnoldi
    //
    // Accepts (n_state_qubits, n_measure, t) for generic interface.
    // Runs classical verification + quantum Krylov pipeline.
    // ============================================================

    operation DemoKrylovArnoldi(n_state_qubits : Int, n_measure : Int, t : Double) : Int {
        let oracle = q_matrix_1_sparse_oracle(q_demo_krylov_oracle);
        let n_qubits = n_state_qubits;
        mutable result = 0;

        // ============================================================
        // Step 2: Krylov Classical Helpers
        // ============================================================

        // Convergence: r_norm=0.01, init_norm=1.0, eps=0.1 → 0.01/1.0 < 0.1 → true
        let conv = q_krylov_converged(0.01, 1.0, 0.1);
        Fact(conv, "krylov: converged(0.01,1.0,0.1)=True");
        set result += 1;

        // Squared norm: ||[3,4]||² = 9 + 16 = 25
        let nsq = q_krylov_norm_sq([3.0, 4.0]);
        Fact(AbsD(nsq - 25.0) < 1e-10, "krylov: norm_sq([3,4])=25");
        set result += 2;

        // Inner product: ⟨[1,0],[0,1]⟩ = 0
        let ip = q_krylov_inner_product([1.0, 0.0], [0.0, 1.0]);
        Fact(AbsD(ip - 0.0) < 1e-10, "krylov: inner_product=0");
        set result += 4;

        // ============================================================
        // Step 3: Lanczos Classical Helpers
        // ============================================================

        // Norm: ||[1,2,3]|| = sqrt(14) ≈ 3.74165738677
        let ln = q_lanczos_norm([1.0, 2.0, 3.0]);
        Fact(AbsD(ln - 3.7416573867739413) < 1e-10,
            "lanczos: norm([1,2,3])=3.742");
        set result += 8;

        // Normalize: [3,4] / 5 = [0.6, 0.8]
        let lnorm = q_lanczos_normalize([3.0, 4.0]);
        Fact(AbsD(lnorm[0] - 0.6) < 1e-10,
            "lanczos: normalize([3,4])[0]=0.6");
        Fact(AbsD(lnorm[1] - 0.8) < 1e-10,
            "lanczos: normalize([3,4])[1]=0.8");
        set result += 16;
        set result += 32;

        // Alpha compute: (1²+1²+1²)/3 = 1.0
        let lac = q_lanczos_alpha_compute([1.0, 1.0, 1.0]);
        Fact(AbsD(lac - 1.0) < 1e-10,
            "lanczos: alpha_compute([1,1,1])=1");
        set result += 64;

        // Beta compute: ||[3,4]|| = 5.0
        let lbc = q_lanczos_beta_compute([3.0, 4.0]);
        Fact(AbsD(lbc - 5.0) < 1e-10,
            "lanczos: beta_compute([3,4])=5");
        set result += 128;

        // Tridiag: alphas=[1,2], betas=[0.5,0.3]
        // T[0][0]=1, T[0][1]=0.5, T[1][0]=0.5, T[1][1]=2
        let tri = q_lanczos_tridiag([1.0, 2.0], [0.5, 0.3]);
        Fact(AbsD(tri[0][0] - 1.0) < 1e-10,
            "lanczos: tridiag[0][0]=1");
        Fact(AbsD(tri[0][1] - 0.5) < 1e-10,
            "lanczos: tridiag[0][1]=0.5");
        Fact(AbsD(tri[1][0] - 0.5) < 1e-10,
            "lanczos: tridiag[1][0]=0.5");
        Fact(AbsD(tri[1][1] - 2.0) < 1e-10,
            "lanczos: tridiag[1][1]=2");
        set result += 256;

        // Eigenvalue sum: 1+2+3 = 6
        let es = q_lanczos_eigenvalue_sum([1.0, 2.0, 3.0]);
        Fact(AbsD(es - 6.0) < 1e-10,
            "lanczos: eigenvalue_sum([1,2,3])=6");
        set result += 512;

        // ============================================================
        // Quantum Pipeline
        // ============================================================

        // Allocate basis (m_steps=2, n_qubits per vector)
        // |v₀⟩ starts as |0...0⟩ (default from use)
        use qs_basis = Qubit[n_qubits * 2];
        use qs_work = Qubit[n_qubits + 1];

        // Step 4: Generate Krylov subspace {|v₀⟩, A|v₀⟩}
        q_krylov_generate_subspace(oracle, qs_basis, qs_work, n_qubits, 2, t);
        set result += 1024;

        // Step 5: Apply Lanczos matrix on |v₀⟩
        use qs_temp = Qubit[n_qubits];
        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[q], qs_temp[q]);
        }
        q_lanczos_apply_matrix(oracle, qs_temp, qs_work, t);
        set result += 2048;
        ResetAll(qs_temp);

        // Step 6: Lanczos estimate alpha₀ = ⟨v₀|A|v₀⟩
        let alpha = q_lanczos_estimate_alpha(
            oracle, qs_basis, qs_work, n_qubits, 0, n_measure, t
        );
        Fact(AbsD(alpha - 1.0) < 0.1,
            "krylov: alpha within 0.1 of 1.0");
        set result += 4096;

        // Step 7: Self-overlap |⟨v₀|v₀⟩| via SWAP test
        use qs_copy = Qubit[n_qubits];
        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[q], qs_copy[q]);
        }
        let overlap = q_krylov_estimate_overlap(
            qs_basis[0 .. n_qubits - 1],
            qs_copy[0 .. n_qubits - 1],
            n_measure
        );
        Fact(AbsD(overlap - 1.0) < 0.1,
            "krylov: self-overlap ≈ 1.0");
        set result += 8192;
        ResetAll(qs_copy);

        // Step 8: Single-shot SWAP test on identical zero states
        use qs_ctrl = Qubit[1];
        use qs_a = Qubit[n_qubits];
        use qs_b = Qubit[n_qubits];
        let swap_r = q_krylov_swap_test_one_shot(qs_ctrl[0], qs_a, qs_b);
        Fact(swap_r == Zero,
            "krylov: swap_test on identical zero = Zero");
        set result += 16384;
        ResetAll(qs_a);
        ResetAll(qs_b);
        Reset(qs_ctrl[0]);

        ResetAll(qs_basis);
        ResetAll(qs_work);

        return result;
    }
}
