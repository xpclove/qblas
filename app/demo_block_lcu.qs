// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Block Encoding + Linear Combination of Unitaries
//
// What it does:
//   Demonstrates block encoding of sparse matrices and LCU
//   (Linear Combination of Unitaries) for quantum linear
//   algebra. Block encoding encodes a matrix A into a
//   unitary U such that U|0⟩|ψ⟩ = |0⟩A|ψ⟩ + |1⟩...
//   LCU combines multiple unitaries into a single operation.
//
// Architecture:
//   - Qubits: n_sys + n_anc + n_lcu
//   - Demo config:  10 qubits (4 sys + 4 anc + 2 lcu)
//   - Test config:  10 qubits (4 sys + 4 anc + 2 lcu)
//   - Matrix: 2×2 or 4×4 diagonal matrix
//   - Technique: Block encoding via q_be_diagonal +
//                LCU via q_lcu_optimized
//
// Input:
//   matrix: square matrix (Double[][]) to block-encode
//   coeffs: LCU coefficients (Double[])
//
// Output:
//   Encoded result (Int):
//     bit 3:    diagonal encoding executed
//     bit 4:    compute_scaling verified
//     bit 5:    coefficient norm verified
//     bit 6:    success probability verified
//     bit 7:    coefficient validity verified
//     bit 8:    amplitude computation verified
//
// Pipeline steps and module mapping:
//   Step 1:  q_block_encoding → q_be_compute_scaling   — Scaling factor
//   Step 2:  q_lcu_optimized → q_lcu_coefficient_norm   — Norm check
//   Step 3:  q_lcu_optimized → q_lcu_success_probability — Prob check
//   Step 4:  q_lcu_optimized → q_lcu_check_coefficients  — Validity check
//   Step 5:  q_lcu_optimized → q_lcu_compute_amplitudes — Amplitude calc
//   Step 6:  q_block_encoding → q_be_diagonal           — Block encode diag.
//   Step 7:  q_block_encoding → q_be_householder        — Householder reflection
//   Step 8:  q_block_encoding → q_be_prepare_superposition — Superposition
//   Step 9:  q_lcu_optimized → q_lcu_optimized_prepare   — LCU prepare
//   Step 10: q_block_encoding_v2 → q_lcu_block_encode    — Block encoding via LCU
//
// Verification:
//   - compute_scaling([[1,0],[0,1]]) = 1.0 (Fact)
//   - coefficient_norm([0.5,0.5]) = 1.0 (Fact)
//   - check_coefficients([0.5,0.5]) = true (Fact)
//   - success_probability([0.5,0.5]) = 0.25 (Fact)
//   - Diagonal block encoding runs without error (quantum)
//   - LCU prepare runs without error (quantum)
//
// Reference:
//   [1] Low & Chuang, "Hamiltonian Simulation by Qubitization"
//       Quantum 3, 163 (2019). arXiv:1610.06546
//   [2] Childs et al., "A Linear Combination of Unitaries"
//       Quantum 5, 574 (2021). arXiv:1711.05380
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
    // Main Block Encoding + LCU Entry Point
    // ============================================================

    operation DemoBlockLcu(
        matrix : Double[][],
        coeffs : Double[]
    ) : Int {
        mutable result = 0;

        // ============================================================
        // Classical Verification
        // ============================================================

        // Step 1: Scaling factor for 2×2 identity matrix
        let scaling = q_be_compute_scaling([[1.0, 0.0], [0.0, 1.0]]);
        Fact(AbsD(scaling - 1.0) < 1e-10, "blcu: scaling = 1.0");
        set result += 16;

        // Step 2: Coefficient norm (sum of |c_i| = 1.0 for [0.5, 0.5])
        let norm = q_lcu_coefficient_norm([0.5, 0.5]);
        Fact(AbsD(norm - 1.0) < 1e-10, "blcu: coeff_norm = 1.0");
        set result += 32;

        // Step 3: Success probability = (norm)² / (2 × sum(c_i²)) = 1/4
        let prob = q_lcu_success_probability([0.5, 0.5]);
        Fact(AbsD(prob - 0.25) < 1e-10, "blcu: success_prob = 0.25");
        set result += 64;

        // Step 4: Coefficient validity
        let valid = q_lcu_check_coefficients([0.5, 0.5]) ? 1 | 0;
        Fact(valid == 1, "blcu: coeffs valid = true");
        set result += 128;

        // Step 5: Compute amplitudes
        let (amps, alpha) = q_lcu_compute_amplitudes(coeffs);
        Fact(Length(amps) == Length(coeffs),
             "blcu: amplitudes length matches coeffs");
        set result += 256;

        // ============================================================
        // Quantum Execution
        // ============================================================

        // Determine qubit counts from matrix size.
        // Householder requires Length(vector) == n_sys.
        let n_sys = MaxI(2, Length(matrix));
        let n_anc = n_sys;
        let n_lcu = 2;

        use qs_sys = Qubit[n_sys];
        use qs_anc = Qubit[n_anc];
        use qs_lcu = Qubit[n_lcu];

        // Step 6: Diagonal block encoding
        // Extract diagonal from matrix (length = 2^n_sys)
        let diag_size = 1 <<< n_sys;
        mutable diag = [1.0, size = diag_size];
        for i in 0 .. diag_size - 1 {
            if (i < Length(matrix) and i < Length(matrix[0])) {
                set diag w/= i <- matrix[i][i];
            }
        }
        q_be_diagonal(diag, qs_sys, qs_anc[0]);
        set result += 4;

        // Step 7: Householder reflection on system
        mutable h_vec = [0.0, size = n_sys];
        set h_vec w/= 0 <- 1.0;
        q_be_householder(h_vec, qs_sys);
        set result += 8;

        // Step 8: Prepare superposition state (use qs_sys for data)
        let n_lcu_bits = 1 <<< n_lcu;
        mutable sup_coeffs = [0.0, size = n_lcu_bits];
        set sup_coeffs w/= 0 <- 1.0;
        q_be_prepare_superposition(sup_coeffs, qs_lcu[0..n_lcu-1], qs_sys[0]);
        set result += 2;

        // Step 9: LCU optimized prepare
        q_lcu_optimized_prepare(amps, qs_lcu, alpha);
        set result += 1;

        // Step 10: Block encoding via LCU (q_block_encoding_v2)
        q_lcu_block_encode(coeffs, alpha, qs_sys, qs_anc[0]);
        set result += 2;

        // Measure system qubits
        for i in 0 .. n_sys - 1 {
            let _ = M(qs_sys[i]);
        }

        ResetAll(qs_sys);
        ResetAll(qs_anc);
        ResetAll(qs_lcu);

        return result;
    }
}
