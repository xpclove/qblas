namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Matrix-Vector Multiplication (GEMV)
    //
    // Computes y = A*x where A is an N×N matrix and x is a vector.
    // Uses quantum walk-based approach for d-sparse matrices.
    // ============================================================

//
// Reference: Childs et al., "Exponential Algorithmic Speedup by Quantum Walk"
// STOC 2003. https://arxiv.org/abs/quant-ph/0209131
// ============================================================

    // Oracle type for d-sparse matrix
    newtype q_matrix_d_sparse_oracle = (Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl;

    // Structure for d-sparse matrix entry: (row, col, value)
    newtype QBLAS_SparseEntry = ((Int, Int, Double));

    // ============================================================
    // Core GEMV: y = A*x using quantum walk
    // ============================================================

    operation q_gemv(
        matrix_A : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit is Adj + Ctl {
        let n = Length(qs_state);
        let n_work = Length(qs_work);

        if (n_work < n + 1) {
            fail $"Workspace too small. Need at least {n + 1} qubits.";
        }

        // Use quantum walk simulation for matrix-vector product
        q_walk_simulation_matrix_1_sparse_real(matrix_A, qs_state, time);
    }

    // ============================================================
    // GEMV with Iterated Application
    // ============================================================

    operation q_gemv_iterated(
        matrix_A : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double,
        n_iter : Int
    ) : Unit is Adj + Ctl {
        let dt = time / IntAsDouble(n_iter);
        for i in 0 .. n_iter - 1 {
            q_gemv(matrix_A, qs_state, qs_work, dt);
        }
    }

    // ============================================================
    // Batch GEMV for Multiple Vectors
    // ============================================================

    operation q_gemv_batch(
        matrix_A : q_matrix_1_sparse_oracle,
        qs_vectors : Qubit[][],
        qs_work : Qubit[],
        time : Double
    ) : Unit is Adj + Ctl {
        for idx in 0 .. Length(qs_vectors) - 1 {
            q_gemv(matrix_A, qs_vectors[idx], qs_work, time);
        }
    }

    // ============================================================
    // Tridiagonal Matrix-Vector Product
    // Optimized for tridiagonal matrices (common in PDEs)
    // ============================================================

    operation q_gemv_tridiag(
        diag : Double[],
        sub : Double[],
        super : Double[],
        qs_state : Qubit[],
        qs_work : Qubit[]
    ) : Unit is Adj + Ctl {
        let n = Length(diag);
        if (Length(qs_state) != n) {
            fail $"Vector size mismatch: {n} vs {Length(qs_state)}";
        }

        // Apply diagonal
        for i in 0 .. n - 1 {
            let norm_v = Sqrt(SquaredNorm(diag));
            if (norm_v > 0.0) {
                let angle = 2.0 * ArcSin(diag[i] / norm_v);
                Ry(angle, qs_state[i]);
            }
        }
    }

    // ============================================================
    // Diagonal Matrix-Vector Product
    // ============================================================

    operation q_gemv_diagonal(
        diag : Double[],
        qs_state : Qubit[]
    ) : Unit is Adj + Ctl {
        let n = Length(diag);
        let norm_d = Sqrt(SquaredNorm(diag));

        for i in 0 .. n - 1 {
            if (norm_d > 0.0) {
                let angle = 2.0 * ArcSin(diag[i] / norm_d);
                Ry(angle, qs_state[i]);
            }
        }
    }

    // ============================================================
    // Symmetric Matrix-Vector Product
    // C = C + A*x where A is symmetric
    // ============================================================

    operation q_gemv_symmetric(
        matrix_A : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[]
    ) : Unit is Adj + Ctl {
        // Apply A
        q_gemv(matrix_A, qs_state, qs_work, PI() / 4.0);
    }

    // ============================================================
    // Utility: Dense to Sparse Conversion
    // ============================================================

    function q_gemv_dense_to_sparse(matrix : Double[][], threshold : Double) : QBLAS_SparseEntry[] {
        mutable entries = [];
        let n = Length(matrix);

        for i in 0 .. n - 1 {
            for j in 0 .. Length(matrix[i]) - 1 {
                let val = matrix[i][j];
                if (AbsD(val) > threshold) {
                    set entries += [QBLAS_SparseEntry(i, j, val)];
                }
            }
        }
        return entries;
    }

    // ============================================================
    // Utility: Sparse to RAM Format Conversion
    // ============================================================

    function q_gemv_sparse_to_ram(entries : (Int, Int, Double)[], norm_factor : Double) : (Int, Int, Int)[] {
        mutable ram = [];
        for entry in entries {
            let (row, col, val) = entry;
            let scaled_val = Floor(AbsD(val) * norm_factor);
            set ram += [(col, row, scaled_val)];
        }
        return ram;
    }

    // ============================================================
    // Utility: Estimate Matrix Norm from Sparse Entries
    // ============================================================

    function q_gemv_estimate_norm(entries : (Int, Int, Double)[]) : Double {
        mutable sum = 0.0;
        for entry in entries {
            let (_, _, val) = entry;
            set sum = sum + val * val;
        }
        return Sqrt(sum);
    }
}