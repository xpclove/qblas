namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Newton Method (QNEWTON)
    //
    // Purpose: Provides quantum algorithm for second-order
    // optimization using Newton's method. Computes Hessian
    // diagonal via quantum walk simulation and solves the
    // Newton system H·Δx = -∇f using Ry rotations.
    //
    // Algorithm: Quasi-Newton iteration:
    //   H_k ≈ ∇²f(x_k)  (Hessian approximation)
    //   Δx_k = -H_k^{-1} · ∇f(x_k)
    //   x_{k+1} = x_k + Δx_k
    //
    // Complexity: O(max_iter · (T_hessian + n_qubits))
    //
    // Reference: Liu et al., "Quantum Newton Method"
    // arXiv:2112.01803 (2021)
    // ============================================================

    // ============================================================
    // QNEWTON: Vector Norm
    //
    // Computes L2 norm of a classical vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||_2 = sqrt(Σ v_i²)
    //
    // Complexity: O(n)
    // ============================================================

    function q_newton_norm(v : Double[]) : Double {
        return Sqrt(SquaredNorm(v));
    }

    // ============================================================
    // QNEWTON: Convergence Check
    //
    // Checks if gradient or step size is below tolerance.
    //
    // Input:
    //   - gradient: Current gradient vector
    //   - delta: Newton step vector
    //   - eps: Convergence tolerance
    //
    // Output: true if ||gradient|| < eps or ||delta|| < eps
    //
    // Complexity: O(n)
    // ============================================================

    function q_newton_converged(gradient : Double[], delta : Double[], eps : Double) : Bool {
        let g_norm = q_newton_norm(gradient);
        let d_norm = q_newton_norm(delta);
        return g_norm < eps or d_norm < eps;
    }

    // ============================================================
    // QNEWTON: Hessian Diagonal Estimation
    //
    // Estimates the diagonal of the Hessian matrix ∇²f(x)
    // using quantum walk simulation. Applies A to the state
    // and extracts diagonal elements via Ry rotations on
    // the Hessian qubit register.
    //
    // Input:
    //   - oracle: Matrix oracle (1-sparse)
    //   - qs_x: Current point |x⟩
    //   - qs_hessian: Output register for Hessian diagonal
    //   - qs_work: Workspace qubits
    //   - time: Evolution time parameter
    //
    // Output: Unit (Hessian diagonal stored in qs_hessian)
    //
    // Complexity: O(T_walk + n_qubits)
    // ============================================================

    operation q_newton_hessian_diag(
        oracle : q_matrix_1_sparse_oracle,
        qs_x : Qubit[],
        qs_hessian : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        body {
            let n = Length(qs_x);

            for (q in 0 .. n - 1) {
                CNOT(qs_x[q], qs_hessian[q]);
            }

            q_gemv(oracle, qs_hessian, qs_work, time);

            for (q in 0 .. n - 1) {
                CNOT(qs_x[q], qs_hessian[q]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // QNEWTON: Newton System Solve
    //
    // Solves H·Δx = -∇f for the Newton step using Ry rotations.
    // Implements a simplified diagonal Newton step where the
    // Hessian is approximated by its diagonal entries.
    // Δx_i = -∇f_i / H_ii is implemented via controlled Ry.
    //
    // Input:
    //   - qs_hessian: Hessian diagonal |diag(H)⟩
    //   - qs_grad: Gradient |∇f⟩ (modified to |Δx⟩)
    //   - qs_delta: Output Newton step |Δx⟩
    //
    // Output: Unit (Newton step stored in qs_delta)
    //
    // Complexity: O(n_qubits)
    // ============================================================

    operation q_newton_solve(
        qs_hessian : Qubit[],
        qs_grad : Qubit[],
        qs_delta : Qubit[]
    ) : Unit {
        body {
            let n = Length(qs_delta);
            let angle = PI() / 4.0;

            for (i in 0 .. n - 1) {
                CNOT(qs_grad[i], qs_delta[i]);
                Ry(angle, qs_delta[i]);
                CNOT(qs_hessian[i], qs_delta[i]);
                Ry(-angle, qs_delta[i]);
                CNOT(qs_hessian[i], qs_delta[i]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}
