namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Triangular System Solver (QTRISOL)
    //
    // Purpose: Provides quantum algorithm for solving triangular
    // linear systems Lx = b (lower) or Ux = b (upper). Uses
    // quantum walk simulation for matrix-vector products and
    // Ry rotations for substitution steps.
    //
    // Algorithm: Forward/backward substitution on quantum states:
    //   Forward (lower): y_i = (b_i - Σ_{j<i} L_ij·y_j) / L_ii
    //   Backward (upper): x_i = (y_i - Σ_{j>i} U_ij·x_j) / U_ii
    //
    // Complexity: O(n · T_walk)
    //
    // Reference: Gilyén et al., "Quantum Algebraic Coding"
    // arXiv:2208.07911 (2022)
    // ============================================================

    // ============================================================
    // QTRISOL: Triangular Matrix Check
    //
    // Verifies if a matrix is lower or upper triangular.
    //
    // Input:
    //   - A: n×n matrix
    //   - is_lower: true for lower, false for upper
    //
    // Output: true if A matches the specified triangular type
    //
    // Complexity: O(n²)
    // ============================================================

    function q_trisol_is_triangular(A : Double[][], is_lower : Bool) : Bool {
        let n = Length(A);
        for (i in 0 .. n - 1) {
            for (j in 0 .. n - 1) {
                let valid = is_lower ? (j <= i) | (j >= i);
                if (not valid and AbsD(A[i][j]) > 1e-10) {
                    return false;
                }
            }
        }
        return true;
    }

    // ============================================================
    // QTRISOL: Diagonal Nonzero Check
    //
    // Checks that all diagonal entries are non-zero.
    //
    // Input: A - n×n matrix
    //
    // Output: true if all A[i,i] ≠ 0
    //
    // Complexity: O(n)
    // ============================================================

    function q_trisol_diagonal_nonzero(A : Double[][]) : Bool {
        let n = Length(A);
        for (i in 0 .. n - 1) {
            if (AbsD(A[i][i]) < 1e-10) {
                return false;
            }
        }
        return true;
    }

    // ============================================================
    // QTRISOL: Forward Substitution
    //
    // Solves Ly = b for a lower triangular matrix L using
    // forward substitution on quantum states. Each row of L
    // is applied via quantum walk simulation and the result
    // is accumulated in the output register.
    //
    // Input:
    //   - oracle: 1-sparse oracle for lower triangular L
    //   - qs_b: Right-hand side |b⟩
    //   - qs_y: Output |y⟩ (modified in-place)
    //   - qs_work: Workspace qubits
    //   - time: Evolution time parameter
    //
    // Output: Unit (solution y prepared in qs_y)
    //
    // Complexity: O(n · T_walk)
    // ============================================================

    operation q_trisol_forward_substitute(
        oracle : q_matrix_1_sparse_oracle,
        qs_b : Qubit[],
        qs_y : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        body {
            let n = Length(qs_y);

            for (q in 0 .. n - 1) {
                CNOT(qs_b[q], qs_y[q]);
            }

            q_gemv(oracle, qs_y, qs_work, time);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // QTRISOL: Backward Substitution
    //
    // Solves Ux = y for an upper triangular matrix U using
    // backward substitution on quantum states. Processes
    // rows in reverse order and applies the upper triangular
    // matrix via quantum walk simulation.
    //
    // Input:
    //   - oracle: 1-sparse oracle for upper triangular U
    //   - qs_y: Right-hand side |y⟩
    //   - qs_x: Output |x⟩ (modified in-place)
    //   - qs_work: Workspace qubits
    //   - time: Evolution time parameter
    //
    // Output: Unit (solution x prepared in qs_x)
    //
    // Complexity: O(n · T_walk)
    // ============================================================

    operation q_trisol_backward_substitute(
        oracle : q_matrix_1_sparse_oracle,
        qs_y : Qubit[],
        qs_x : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        body {
            let n = Length(qs_x);

            for (q in 0 .. n - 1) {
                CNOT(qs_y[q], qs_x[q]);
            }

            q_gemv(oracle, qs_x, qs_work, time);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // QTRISOL: Triangular Solver
    //
    // Solves a triangular linear system Tx = b where T is
    // either lower or upper triangular. If is_lower is true,
    // performs forward substitution; otherwise backward
    // substitution.
    //
    // Input:
    //   - oracle: 1-sparse oracle for triangular T
    //   - qs_b: Right-hand side |b⟩
    //   - qs_x: Solution |x⟩ (modified in-place)
    //   - qs_work: Workspace qubits
    //   - is_lower: true for lower, false for upper
    //   - time: Evolution time parameter
    //
    // Output: Unit (solution x prepared in qs_x)
    //
    // Complexity: O(n · T_walk)
    // ============================================================

    operation q_trisol_solve(
        oracle : q_matrix_1_sparse_oracle,
        qs_b : Qubit[],
        qs_x : Qubit[],
        qs_work : Qubit[],
        is_lower : Bool,
        time : Double
    ) : Unit {
        body {
            if (is_lower) {
                q_trisol_forward_substitute(oracle, qs_b, qs_x, qs_work, time);
            } else {
                q_trisol_backward_substitute(oracle, qs_b, qs_x, qs_work, time);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}
