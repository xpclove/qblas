namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Matrix Addition and Subtraction
    //
    // Purpose: Provides matrix addition and subtraction operations
    // for quantum linear algebra. Enables A + B and A - B operations.
    //
    // Algorithm: Classical helper functions for matrix arithmetic.
    // Quantum implementation uses superposition and interference.
    //
    // Complexity: O(mn) for m×n matrices
    //
    // Reference: Golub & Van Loan, "Matrix Computations"
    // ============================================================

    // ============================================================
    // ADD: Check Dimensions Match
    //
    // Checks if two matrices have matching dimensions.
    //
    // Input:
    //   - A: m×n matrix
    //   - B: p×q matrix
    //
    // Output: true if m=p and n=q
    //
    // Complexity: O(1)
    // ============================================================

    function q_add_check_dims(A : Double[][], B : Double[][]) : Bool {
        let m = Length(A);

        if (m == 0 or Length(B) == 0) {
            return false;
        }

        return Length(A[0]) == Length(B[0]) and m == Length(B);
    }

    // ============================================================
    // ADD: Matrix Addition
    //
    // Computes C = A + B element-wise.
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: m×n matrix C = A + B
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_matrix_add(A : Double[][], B : Double[][]) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable C = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [A[i][j] + B[i][j]];
            }
            set C += [row];
        }

        return C;
    }

    // ============================================================
    // ADD: Matrix Subtraction
    //
    // Computes C = A - B element-wise.
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: m×n matrix C = A - B
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_matrix_subtract(A : Double[][], B : Double[][]) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable C = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [A[i][j] - B[i][j]];
            }
            set C += [row];
        }

        return C;
    }

    // ============================================================
    // ADD: Scalar Multiplication
    //
    // Computes B = αA (each element multiplied by scalar).
    //
    // Input:
    //   - A: m×n matrix
    //   - alpha: Scalar multiplier
    //
    // Output: m×n matrix B = αA
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_scalar_mult(A : Double[][], alpha : Double) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable B = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [alpha * A[i][j]];
            }
            set B += [row];
        }

        return B;
    }

    // ============================================================
    // ADD: Accumulated Addition
    //
    // Computes A = A + B in-place (creates new matrix).
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: Updated matrix A
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_accumulate(A : Double[][], B : Double[][]) : Double[][] {
        return q_add_matrix_add(A, B);
    }

    // ============================================================
    // ADD: Negative Matrix
    //
    // Computes B = -A (negate all elements).
    //
    // Input: A - m×n matrix
    //
    // Output: m×n matrix B = -A
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_negate(A : Double[][]) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable B = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [-A[i][j]];
            }
            set B += [row];
        }

        return B;
    }

    // ============================================================
    // ADD: Linear Combination
    //
    // Computes C = αA + βB element-wise.
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //   - alpha: Scalar for A
    //   - beta: Scalar for B
    //
    // Output: m×n matrix C = αA + βB
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_linear_combo(
        A : Double[][],
        B : Double[][],
        alpha : Double,
        beta : Double
    ) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable C = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [alpha * A[i][j] + beta * B[i][j]];
            }
            set C += [row];
        }

        return C;
    }

    // ============================================================
    // ADD: Matrix Sum (所有元素求和)
    //
    // Computes sum of all elements in matrix.
    //
    // Input: A - m×n matrix
    //
    // Output: Σᵢⱼ A[i,j]
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_matrix_sum(A : Double[][]) : Double {
        let m = Length(A);

        if (m == 0) {
            return 0.0;
        }

        mutable total = 0.0;
        for i in 0 .. m - 1 {
            for j in 0 .. Length(A[0]) - 1 {
                set total = total + A[i][j];
            }
        }

        return total;
    }

    // ============================================================
    // ADD: Row Sum
    //
    // Computes sum of each row.
    //
    // Input: A - m×n matrix
    //
    // Output: Array of row sums [Σⱼ A[0,j], Σⱼ A[1,j], ...]
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_row_sums(A : Double[][]) : Double[] {
        let m = Length(A);

        if (m == 0) {
            return [0.0];
        }

        mutable sums = [];
        for i in 0 .. m - 1 {
            mutable row_sum = 0.0;
            for j in 0 .. Length(A[0]) - 1 {
                set row_sum = row_sum + A[i][j];
            }
            set sums += [row_sum];
        }

        return sums;
    }

    // ============================================================
    // ADD: Column Sum
    //
    // Computes sum of each column.
    //
    // Input: A - m×n matrix
    //
    // Output: Array of column sums [Σᵢ A[i,0], Σᵢ A[i,1], ...]
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_col_sums(A : Double[][]) : Double[] {
        let m = Length(A);

        if (m == 0) {
            return [0.0];
        }

        let n = Length(A[0]);
        mutable sums = [];

        for j in 0 .. n - 1 {
            mutable col_sum = 0.0;
            for i in 0 .. m - 1 {
                set col_sum = col_sum + A[i][j];
            }
            set sums += [col_sum];
        }

        return sums;
    }

    // ============================================================
    // ADD: Trace of Sum
    //
    // Computes trace of A + B (if square).
    //
    // Input:
    //   - A: n×n matrix
    //   - B: n×n matrix
    //
    // Output: trace(A + B)
    //
    // Complexity: O(n)
    // ============================================================

    function q_add_trace_sum(A : Double[][], B : Double[][]) : Double {
        let n = Length(A);

        if (n == 0) {
            return 0.0;
        }

        mutable tr = 0.0;
        for i in 0 .. n - 1 {
            set tr = tr + A[i][i] + B[i][i];
        }

        return tr;
    }

    // ============================================================
    // ADD: Frobenius Norm of Sum
    //
    // Computes ||A + B||_F
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: Frobenius norm
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_norm_sum(A : Double[][], B : Double[][]) : Double {
        let m = Length(A);

        if (m == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for i in 0 .. m - 1 {
            for j in 0 .. Length(A[0]) - 1 {
                let val = A[i][j] + B[i][j];
                set sum = sum + val * val;
            }
        }

        return Sqrt(sum);
    }

    // ============================================================
    // ADD: Matrix Max Norm
    //
    // Computes max absolute element norm: ||A||_max = max|aᵢⱼ|
    //
    // Input: A - m×n matrix
    //
    // Output: Maximum absolute value
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_max_norm(A : Double[][]) : Double {
        let m = Length(A);

        if (m == 0) {
            return 0.0;
        }

        mutable max_val = 0.0;
        for i in 0 .. m - 1 {
            for j in 0 .. Length(A[0]) - 1 {
                let abs_val = AbsD(A[i][j]);
                if (abs_val > max_val) {
                    set max_val = abs_val;
                }
            }
        }

        return max_val;
    }

    // ============================================================
    // ADD: Element-wise Product
    //
    // Computes C[i,j] = A[i,j] * B[i,j] (Hadamard product).
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: m×n matrix C = A ∘ B
    //
    // Complexity: O(mn)
    // ============================================================

    function q_add_hadamard(A : Double[][], B : Double[][]) : Double[][] {
        let m = Length(A);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable C = [];

        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                set row += [A[i][j] * B[i][j]];
            }
            set C += [row];
        }

        return C;
    }

    // ============================================================
    // ADD: Validate Square Matrices
    //
    // Checks if both matrices are square.
    //
    // Input:
    //   - A: n×n matrix
    //   - B: m×m matrix
    //
    // Output: true if both are square and same size
    //
    // Complexity: O(1)
    // ============================================================

    function q_add_validate_square(A : Double[][], B : Double[][]) : Bool {
        let n = Length(A);

        if (n == 0 or n != Length(A[0])) {
            return false;
        }

        let m = Length(B);
        if (m != Length(B[0])) {
            return false;
        }

        return n == m;
    }

    // ============================================================
    // ADD: Block Encoding for Matrix Addition
    //
    // Block encoding for matrix addition A + B.
    // Applies both oracles sequentially with equal time.
    //
    // Input:
    //   - oracle_A: 1-sparse oracle for A
    //   - oracle_B: 1-sparse oracle for B
    //   - qs_state: State qubits
    //   - qs_work: Workspace qubits
    //   - time: Evolution time
    //
    // Complexity: O(poly(log(1/ε)))
    //
    // Reference: Low & Chuang, "Hamiltonian Simulation by Qubitization"
    // Quantum 3, 163 (2019).
    // ============================================================

    operation q_matrix_add_block_encode(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        let half_time = time / 2.0;
        q_gemv(oracle_A, qs_state, qs_work, half_time);
        q_gemv(oracle_B, qs_state, qs_work, half_time);
    }
}
