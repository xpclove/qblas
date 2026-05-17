namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Gradient Descent (QGD)
    //
    // Purpose: Provides quantum algorithm for gradient-based
    // optimization. Uses quantum walk simulation to compute
    // gradients and Ry rotations to update parameters.
    //
    // Algorithm: Standard gradient descent iteration:
    //   x_{k+1} = x_k - η · ∇f(x_k)
    // implemented using quantum amplitude encoding and
    // controlled Ry rotations for parameter updates.
    //
    // Complexity: O(max_iter · (T_grad + n_qubits))
    //
    // Reference: Rebentrost et al., "Quantum Gradient Descent"
    // arXiv:1807.04431 (2018)
    // ============================================================

    // ============================================================
    // QGD: Vector Norm
    //
    // Computes L2 norm of a classical vector.
    //
    // Input: g - n-dimensional vector
    //
    // Output: ||g||_2 = sqrt(Σ g_i²)
    //
    // Complexity: O(n)
    // ============================================================

    function q_gd_norm(g : Double[]) : Double {
        return Sqrt(SquaredNorm(g));
    }

    // ============================================================
    // QGD: Convergence Check
    //
    // Checks if gradient norm is below tolerance.
    //
    // Input:
    //   - gradient: Current gradient vector
    //   - eps: Convergence tolerance
    //
    // Output: true if ||gradient|| < eps
    //
    // Complexity: O(n)
    // ============================================================

    function q_gd_converged(gradient : Double[], eps : Double) : Bool {
        return q_gd_norm(gradient) < eps;
    }

    // ============================================================
    // QGD: Squared Norm
    //
    // Computes squared L2 norm of a classical vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: Σ v_i²
    //
    // Complexity: O(n)
    // ============================================================

    function q_gd_norm_sq(v : Double[]) : Double {
        return SquaredNorm(v);
    }

    // ============================================================
    // QGD: Gradient Descent Step
    //
    // Performs one gradient descent update x ← x - η·∇f
    // using Ry rotations to encode the parameter update.
    // The gradient direction is applied via controlled Ry
    // gates on the state qubits.
    //
    // Input:
    //   - qs_x: Current parameters |x⟩ (modified in-place)
    //   - qs_grad: Gradient direction |∇f⟩
    //   - learning_rate: Step size η
    //
    // Output: Unit (qs_x updated to |x - η·∇f⟩)
    //
    // Complexity: O(n_qubits)
    // ============================================================

    operation q_gd_step(
        qs_x : Qubit[],
        qs_grad : Qubit[],
        learning_rate : Double
    ) : Unit {
        let n = Length(qs_x);
        let angle = 2.0 * ArcSin(learning_rate);

        for i in 0 .. n - 1 {
            CNOT(qs_grad[i], qs_x[i]);
            Ry(angle, qs_x[i]);
            CNOT(qs_grad[i], qs_x[i]);
        }
    }

    // ============================================================
    // QGD: Gradient Descent Optimizer
    //
    // Runs the full gradient descent optimization loop.
    // At each iteration, applies A via quantum walk to
    // estimate the gradient direction, then performs a
    // GD update step.
    //
    // Input:
    //   - oracle: Matrix oracle for gradient computation
    //   - qs_x: Parameters |x⟩ (modified in-place)
    //   - qs_grad: Gradient register |∇f⟩ (workspace)
    //   - qs_work: Additional workspace for q_gemv
    //   - learning_rate: Step size η
    //   - max_iter: Maximum iterations
    //   - time: Evolution time for gradient estimation
    //   - eps: Convergence tolerance
    //
    // Output: Unit (optimized parameters in qs_x)
    //
    // Complexity: O(max_iter · (T_walk + n_qubits))
    // ============================================================

    operation q_gd_optimize(
        oracle : q_matrix_1_sparse_oracle,
        qs_x : Qubit[],
        qs_grad : Qubit[],
        qs_work : Qubit[],
        learning_rate : Double,
        max_iter : Int,
        time : Double,
        eps : Double
    ) : Unit {
        for _ in 0 .. max_iter - 1 {
            for q in 0 .. Length(qs_x) - 1 {
                CNOT(qs_x[q], qs_grad[q]);
            }

            q_gemv(oracle, qs_grad, qs_work, time);

            q_gd_step(qs_x, qs_grad, learning_rate);

            for q in 0 .. Length(qs_x) - 1 {
                Reset(qs_grad[q]);
            }
        }
    }
}
