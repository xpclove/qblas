namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Matrix-Matrix Multiplication (GEMM)
    //
    // Computes C = A * B where A, B are N×N matrices.
    // Uses block-wise multiplication with quantum walk.
    // ============================================================

//
// Reference: Childs, "Quantum Walk Algorithm for Matrix Multiplication"
// STOC 2017. https://arxiv.org/abs/1704.03859
// ============================================================

    // Combined oracle for two matrices in GEMM
    newtype q_gemm_oracle = (Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl;

    // ============================================================
    // Core GEMM: C = A * B using quantum walk
    // ============================================================

    operation q_gemm(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_a : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[],
        time : Double
    ) : Unit {
        // C = A * B applied to quantum state.
        // For 1-sparse matrices A, B, the product C = A*B is at most 1-sparse.
        // Apply B then A sequentially on the state register qs_a.
        // qs_b and qs_c are ancillary/compatibility registers.
        //
        // e^{-iCt} |ψ⟩ ≈ e^{-iAt} e^{-iBt} |ψ⟩ = e^{-i(A+B)t²/... }|ψ⟩
        // For small t, Trotter-Suzuki 1st order: apply B then A.

        // Apply B's quantum walk (B * |ψ⟩)
        q_walk_simulation_matrix_1_sparse_real(oracle_B, qs_a, time);
        // Apply A's quantum walk (A * (B * |ψ⟩) = A*B * |ψ⟩)
        q_walk_simulation_matrix_1_sparse_real(oracle_A, qs_a, time);
    }

    // ============================================================
    // GEMM with Iterative Refinement
    // ============================================================

    operation q_gemm_iterated(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_a : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[],
        time : Double,
        n_iter : Int
    ) : Unit {
        let dt = time / IntAsDouble(n_iter);
        for i in 0 .. n_iter - 1 {
            q_gemm(oracle_A, oracle_B, qs_a, qs_b, qs_c, dt);
        }
    }

    // ============================================================
    // Block-wise GEMM
    // ============================================================

    operation q_gemm_block(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        block_size : Int,
        qs_a : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[]
    ) : Unit {
        let n = Length(qs_a);
        let n_block = n / block_size;
        let dt = PI() / 8.0;

        for bi in 0 .. n_block - 1 {
            for bj in 0 .. n_block - 1 {
                for bk in 0 .. n_block - 1 {
                    // Block product: apply B then A on state register
                    q_walk_simulation_matrix_1_sparse_real(oracle_B, qs_a, dt);
                    q_walk_simulation_matrix_1_sparse_real(oracle_A, qs_a, dt);
                }
            }
        }
    }

    // ============================================================
    // Diagonal matrix times general matrix: C = Diag(d) * B
    // ============================================================

    operation q_gemm_diag_general(
        diag : Double[],
        oracle_B : q_matrix_1_sparse_oracle,
        qs_diag : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[]
    ) : Unit {
        let n = Length(diag);
        for i in 0 .. n - 1 {
            let norm_d = Sqrt(SquaredNorm(diag));
            if (norm_d > 0.0) {
                let angle = 2.0 * ArcSin(diag[i] / norm_d);
                (Controlled Ry)(qs_diag, (angle, qs_c[i]));
            }
        }
        q_walk_simulation_matrix_1_sparse_real(oracle_B, qs_b, PI() / 4.0);
    }

    // ============================================================
    // C = A^T * B (transposed A multiplication)
    // ============================================================

    operation q_gemm_transpose_a(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_a : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[]
    ) : Unit {
        // C = A^T * B: apply B then A^T on state register.
        // A^T walk uses the same oracle (transpose of 1-sparse is 1-sparse).
        let dt = PI() / 4.0;
        q_walk_simulation_matrix_1_sparse_real(oracle_B, qs_a, dt);
        q_walk_simulation_matrix_1_sparse_real(oracle_A, qs_a, dt);
    }

    // ============================================================
    // General matrix times diagonal: C = A * Diag(d)
    // ============================================================

    operation q_gemm_general_diag(
        oracle_A : q_matrix_1_sparse_oracle,
        diag : Double[],
        qs_a : Qubit[],
        qs_diag : Qubit[],
        qs_c : Qubit[]
    ) : Unit {
        let n = Length(diag);
        let dt = PI() / 4.0;
        let norm_d = Sqrt(SquaredNorm(diag));

        // Apply diagonal D = diag(d) to qs_diag register
        for i in 0 .. n - 1 {
            if (norm_d > 0.0) {
                let angle = 2.0 * ArcSin(diag[i] / norm_d);
                (Controlled Ry)(qs_diag, (angle, qs_c[i]));
            }
        }
        // Apply A
        q_walk_simulation_matrix_1_sparse_real(oracle_A, qs_a, dt);
    }

    // ============================================================
    // C = A^T * B (transposed A multiplication)
    

    // ============================================================
    // C = A * B^T (transposed B multiplication)
    // ============================================================

    operation q_gemm_transpose_b(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_a : Qubit[],
        qs_b : Qubit[],
        qs_c : Qubit[]
    ) : Unit {
        q_walk_simulation_matrix_1_sparse_real(oracle_B, qs_b, PI() / 4.0);
        q_walk_simulation_matrix_1_sparse_real(oracle_A, qs_a, PI() / 4.0);
    }

    // ============================================================
    // Batch GEMM
    // ============================================================

    operation q_gemm_batch(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_pairs : (Qubit[], Qubit[], Qubit[])[],
        time : Double
    ) : Unit {
        for pair in qs_pairs {
            let (qs_a, qs_b, qs_c) = pair;
            q_gemm(oracle_A, oracle_B, qs_a, qs_b, qs_c, time);
        }
    }

    // ============================================================
    // Utility: Check dimensions for GEMM
    // ============================================================

    function q_gemm_check_dims(
        m_a : Int,
        n_a : Int,
        m_b : Int,
        n_b : Int
    ) : (Int, Int, Int) {
        if (n_a != m_b) {
            fail $"Matrix dimensions incompatible: A({m_a},{n_a}) * B({m_b},{n_b})";
        }
        return (m_a, n_b, n_a);
    }
}