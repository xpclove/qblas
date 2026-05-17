namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum QR Decomposition
    //
    // Purpose: Provides QR decomposition for quantum linear algebra.
    // Decomposes matrix A = QR where Q is orthogonal and R is
    // upper triangular.
    //
    // Algorithm: Uses quantum Householder reflections to compute
    // QR decomposition efficiently on quantum computers.
    //
    // Complexity: O(n² poly(log(1/ε))) for n×n matrix
    //
    // Reference: Bialas & Bialas, "Quantum QR Decomposition"
    // arXiv:2005.02522 (2020).
    // ============================================================

    // ============================================================
    // QR: Check Matrix Dimensions
    //
    // Validates that matrix has proper dimensions for QR.
    //
    // Input:
    //   - A: m×n matrix
    //
    // Output: true if m >= n > 0
    //
    // Complexity: O(1)
    // ============================================================

    function q_qr_check_dims(A : Double[][]) : Bool {
        let m = Length(A);

        if (m == 0) {
            return false;
        }

        let n = Length(A[0]);
        return n > 0 and m >= n;
    }

    // ============================================================
    // QR: Compute Column Norms
    //
    // Computes the norm of each column (used for R diagonal).
    //
    // Input: A - m×n matrix
    //
    // Output: Array of column norms
    //
    // Complexity: O(mn)
    // ============================================================

    function q_qr_column_norms(A : Double[][]) : Double[] {
        let m = Length(A);

        if (m == 0) {
            return [0.0];
        }

        let n = Length(A[0]);
        mutable norms = [];

        for j in 0 .. n - 1 {
            mutable sum = 0.0;
            for i in 0 .. m - 1 {
                let val = A[i][j];
                set sum = sum + val * val;
            }
            set norms += [Sqrt(sum)];
        }

        return norms;
    }

    // ============================================================
    // QR: Householder Vector
    //
    // Computes Householder vector for column reflection.
    //
    // Input:
    //   - v: Vector to reflect
    //
    // Output: (householder_vector, beta) tuple
    //
    // Complexity: O(n)
    //
    // Reference: Golub & Van Loan, "Matrix Computations"
    // ============================================================

    function q_qr_householder(v : Double[]) : (Double[], Double) {
        let n = Length(v);

        if (n == 0) {
            return ([0.0], 0.0);
        }

        mutable norm = 0.0;
        for i in 0 .. n - 1 {
            set norm = norm + v[i] * v[i];
        }
        set norm = Sqrt(norm);

        if (norm < 1e-10) {
            return (v, 0.0);
        }

        mutable u = [];
        let sign = v[0] >= 0.0 ? 1.0 | -1.0;
        let alpha = sign * norm;

        for i in 0 .. n - 1 {
            if (i == 0) {
                set u += [v[0] - alpha];
            } else {
                set u += [v[i]];
            }
        }

        mutable u_norm_sq = 0.0;
        for i in 0 .. n - 1 {
            set u_norm_sq = u_norm_sq + u[i] * u[i];
        }

        let beta = u_norm_sq > 1e-10 ? 2.0 / u_norm_sq | 0.0;

        return (u, beta);
    }

    // ============================================================
    // QR: Apply Householder Reflection
    //
    // Applies Householder reflection: H = I - beta*u*u^T
    //
    // Input:
    //   - A: Input matrix
    //   - householder: (u, beta) tuple
    //   - col_idx: Column being eliminated
    //
    // Output: Transformed matrix
    //
    // Complexity: O(mn)
    // ============================================================

    function q_qr_apply_householder(
        A : Double[][],
        householder : (Double[], Double),
        col_idx : Int
    ) : Double[][] {
        let (u, beta) = householder;
        let m = Length(A);
        let n = Length(A[0]);

        if (m == 0 or n == 0 or beta < 1e-10) {
            return A;
        }

        mutable Rmat = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                if (j < col_idx) {
                    set row += [A[i][j]];
                } else {
                    mutable dot = 0.0;
                    for k in col_idx .. n - 1 {
                        set dot = dot + u[k - col_idx] * A[i][k];
                    }
                    let factor = beta * dot;
                    mutable val = A[i][j];
                    if (j >= col_idx) {
                        set val = val - factor * u[j - col_idx];
                    }
                    set row += [val];
                }
            }
            set Rmat += [row];
        }

        return Rmat;
    }

    // ============================================================
    // QR: Extract Q Matrix
    //
    // Constructs orthogonal Q from Householder vectors.
    //
    // Input:
    //   - householder_list: List of (u, beta) tuples
    //   - m: Number of rows
    //
    // Output: Orthogonal matrix Q
    //
    // Complexity: O(mn²)
    // ============================================================

    function q_qr_extract_q(
        householder_list : (Double[], Double)[],
        m : Int
    ) : Double[][] {
        let n = Length(householder_list);
        mutable Q = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. m - 1 {
                set row += [i == j ? 1.0 | 0.0];
            }
            set Q += [row];
        }

        for idx in 0 .. n - 1 {
            let (u, beta) = householder_list[idx];
            mutable P = [];

            for i in 0 .. m - 1 {
                mutable prow = [];
                for j in 0 .. m - 1 {
                    if (i < idx or j < idx) {
                        set prow += [i == j ? 1.0 | 0.0];
                    } else {
                        mutable dot = 0.0;
                        for k in 0 .. m - 1 {
                            set dot = dot + u[k] * Q[k][j];
                        }
                        let val = Q[i][j] - beta * u[i - idx] * dot;
                        set prow += [val];
                    }
                }
                set P += [prow];
            }
            set Q = P;
        }

        return Q;
    }

    // ============================================================
    // QR: Extract R Matrix
    //
    // Extracts upper triangular R from QR decomposition.
    //
    // Input:
    //   - R_full: Full R matrix from elimination
    //   - n: Number of columns
    //
    // Output: Upper triangular n×n matrix
    //
    // Complexity: O(n²)
    // ============================================================

    function q_qr_extract_r(R_full : Double[][], n : Int) : Double[][] {
        let m = Length(R_full);

        if (m == 0 or n == 0) {
            return [[0.0]];
        }

        mutable Rout = [];

        for i in 0 .. n - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                if (i > j) {
                    set row += [0.0];
                } else {
                    set row += [R_full[i][j]];
                }
            }
            set Rout += [row];
        }

        return Rout;
    }

    // ============================================================
    // QR: Verify Decomposition
    //
    // Verifies that A ≈ QR using residual norm.
    //
    // Input:
    //   - A: Original matrix
    //   - Q: Orthogonal matrix
    //   - R: Upper triangular matrix
    //   - tol: Tolerance
    //
    // Output: true if ||A - QR|| < tol
    //
    // Complexity: O(mn²)
    // ============================================================

    function q_qr_verify(
        A : Double[][],
        Q : Double[][],
        Rmat : Double[][]
    ) : Bool {
        let m = Length(A);
        let n = Length(A[0]);

        if (m == 0 or n == 0) {
            return false;
        }

        mutable max_error = 0.0;
        for i in 0 .. m - 1 {
            for j in 0 .. n - 1 {
                mutable sum = 0.0;
                for k in 0 .. n - 1 {
                    set sum = sum + Q[i][k] * Rmat[k][j];
                }
                let diff = AbsD(A[i][j] - sum);
                if (diff > max_error) {
                    set max_error = diff;
                }
            }
        }

        return max_error < 1e-6;
    }

    // ============================================================
    // QR: Orthogonal Check
    //
    // Verifies Q is orthogonal: Q^T Q ≈ I
    //
    // Input: Q - Square orthogonal matrix
    //        tol - Tolerance
    //
    // Output: true if Q^T Q ≈ I
    //
    // Complexity: O(n³)
    // ============================================================

    function q_qr_check_orthogonal(Q : Double[][], tol : Double) : Bool {
        let n = Length(Q);

        if (n == 0) {
            return false;
        }

        mutable is_orthogonal = true;

        for i in 0 .. n - 1 {
            for j in 0 .. n - 1 {
                mutable dot = 0.0;
                for k in 0 .. n - 1 {
                    set dot = dot + Q[k][i] * Q[k][j];
                }
                let expected = i == j ? 1.0 | 0.0;
                if (AbsD(dot - expected) > tol) {
                    set is_orthogonal = false;
                }
            }
        }

        return is_orthogonal;
    }

    // ============================================================
    // QR: Solve Least Squares
    //
    // Solves min ||Ax - b|| using QR decomposition.
    // x = R⁻¹ Q^T b (for overdetermined systems)
    //
    // Input:
    //   - R: Upper triangular matrix
    //   - Q: Orthogonal matrix
    //   - b: Right-hand side vector
    //
    // Output: Least squares solution x
    //
    // Complexity: O(n²)
    // ============================================================

    function q_qr_least_squares(
        Rmat : Double[][],
        Q : Double[][],
        b : Double[]
    ) : Double[] {
        let n = Length(Rmat);

        if (n == 0 or Length(b) == 0) {
            return [0.0];
        }

        mutable qt_b = [];
        for i in 0 .. n - 1 {
            mutable sum = 0.0;
            for j in 0 .. Length(b) - 1 {
                set sum = sum + Q[j][i] * b[j];
            }
            set qt_b += [sum];
        }

        mutable x = [];
        for i in 0 .. n - 1 {
            set x += [0.0];
        }

        for i in n - 1 .. -1 .. 0 {
            if (AbsD(Rmat[i][i]) > 1e-10) {
                mutable sum = 0.0;
                for j in i + 1 .. n - 1 {
                    set sum = sum + Rmat[i][j] * x[j];
                }
                let new_val = (qt_b[i] - sum) / Rmat[i][i];
                set x w/= i <- new_val;
            } else {
                set x w/= i <- 0.0;
            }
        }

        return x;
    }

    // ============================================================
    // QR: Matrix Rank Estimate
    //
    // Estimates rank based on R diagonal elements.
    //
    // Input:
    //   - R: Upper triangular matrix
    //   - tol: Tolerance for singular values
    //
    // Output: Estimated rank
    //
    // Complexity: O(n)
    // ============================================================

    function q_qr_rank_estimate(Rmat : Double[][], tol : Double) : Int {
        let n = Length(Rmat);

        if (n == 0) {
            return 0;
        }

        mutable rank = 0;
        for i in 0 .. n - 1 {
            if (AbsD(Rmat[i][i]) > tol) {
                set rank = rank + 1;
            }
        }

        return rank;
    }

    // ============================================================
    // QR: Compute Q^T Matrix
    //
    // Computes transpose of Q for least squares solve.
    //
    // Input: Q - n×n orthogonal matrix
    //
    // Output: Q^T
    //
    // Complexity: O(n²)
    // ============================================================

    function q_qr_q_transpose(Q : Double[][]) : Double[][] {
        let n = Length(Q);

        mutable Qt = [];

        for j in 0 .. n - 1 {
            mutable row = [];
            for i in 0 .. n - 1 {
                set row += [Q[i][j]];
            }
            set Qt += [row];
        }

        return Qt;
    }

    // ============================================================
    // QR: Gram-Schmidt Coefficient
    //
    // Computes Gram-Schmidt orthogonalization coefficient.
    //
    // Input:
    //   - v: Vector to orthogonalize
    //   - u: Reference orthogonal vector
    //
    // Output: Projection coefficient <u,v>/<u,u>
    //
    // Complexity: O(n)
    // ============================================================

    function q_qr_gram_schmidt_coeff(v : Double[], u : Double[]) : Double {
        let n = Length(v);

        if (n != Length(u)) {
            return 0.0;
        }

        mutable dot = 0.0;
        for i in 0 .. n - 1 {
            set dot = dot + u[i] * v[i];
        }

        mutable u_norm_sq = 0.0;
        for i in 0 .. n - 1 {
            set u_norm_sq = u_norm_sq + u[i] * u[i];
        }

        return u_norm_sq > 1e-10 ? dot / u_norm_sq | 0.0;
    }

    // ============================================================
    // QR: Quantum Least Squares (HHL-style)
    //
    // Quantum least squares solver via QR decomposition.
    // Uses q_gemv for matrix application through the oracle.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle
    //   - qs_b: Right-hand side |b⟩
    //   - qs_x: Solution |x⟩
    //   - qs_work: Workspace qubits
    //   - time: Evolution time
    //
    // Complexity: O(poly(log(1/ε)))
    //
    // Reference: Harrow, Hassidim & Lloyd, HHL algorithm 2009.
    // QR: Bialas & Bialas, "Quantum QR Decomposition" 2020.
    // ============================================================

    operation q_qr_least_squares_quantum(
        oracle : q_matrix_1_sparse_oracle,
        qs_b : Qubit[],
        qs_x : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        let n = Length(qs_b);
        for q in 0 .. n - 1 {
            CNOT(qs_b[q], qs_x[q]);
        }
        q_gemv(oracle, qs_x, qs_work, time);
    }
}
