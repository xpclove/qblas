namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Gradient Estimation (QGE)
    //
    // Purpose: Provides quantum algorithms for estimating gradients
    // of functions, essential for quantum optimization and VQE.
    //
    // Algorithm: Implements parameter shift rule, quantum
    // natural gradient, and other gradient estimation techniques.
    //
    // Complexity: O(1) per parameter for parameter shift
    //
    // Reference: Gilyén et al., "Quantum Gradient Estimation"
    // arXiv:1704.09283; Crooks, "Parameter Shift Rule" 2018
    // ============================================================

    // ============================================================
    // QGE: Compute parameter shift gradient
    //
    // Parameter shift rule for gradient of expectation values:
    // ∂⟨O⟩/∂θ = (⟨O(θ+π/2)⟩ - ⟨O(θ-π/2)⟩) / 2
    //
    // Input:
    //   - f_plus: Expectation at θ + π/2
    //   - f_minus: Expectation at θ - π/2
    //
    // Output: Gradient estimate
    //
    // Complexity: O(1)
    //
    // Reference: Crooks, "Parameter Shift Rule" 2018
    // ============================================================

    function q_qge_parameter_shift(f_plus : Double, f_minus : Double) : Double {
        return (f_plus - f_minus) / 2.0;
    }

    // ============================================================
    // QGE: Compute shift angle
    //
    // For parameter shift rule, shift angle is π/2.
    //
    // Input: None
    // Output: Shift angle π/2
    //
    // Complexity: O(1)
    //
    // Reference: Standard parameter shift
    // ============================================================

    function q_qge_shift_angle() : Double {
        return PI() / 2.0;
    }

    // ============================================================
    // QGE: Estimate gradient magnitude
    //
    // Computes ||∇f|| = sqrt(Σ (∂f/∂x_i)²)
    //
    // Input: gradients - array of partial derivatives
    // Output: Gradient magnitude
    //
    // Complexity: O(n)
    //
    // Reference: Vector norm properties
    // ============================================================

    function q_qge_gradient_magnitude(gradients : Double[]) : Double {
        mutable sum_sq = 0.0;
        for g in gradients {
            set sum_sq = sum_sq + g * g;
        }
        return Sqrt(sum_sq);
    }

    // ============================================================
    // QGE: Compute quantum natural gradient
    //
    // Quantum natural gradient uses the Fubini-Study metric
    // to rescale gradients appropriately.
    //
    // Input:
    //   - gradients: Standard gradients
    //   - fisher_info: Diagonal of Fisher information matrix
    //
    // Output: Normalized quantum gradient
    //
    // Complexity: O(n)
    //
    // Reference: Stokes et al., "Quantum Natural Gradient" 2019
    // ============================================================

    function q_qge_quantum_natural_gradient(gradients : Double[], fisher_info : Double[]) : Double[] {
        let n = Length(gradients);
        mutable qng = [];
        for i in 0 .. n - 1 {
            let fi = fisher_info[i];
            if (AbsD(fi) > 1e-10) {
                set qng += [gradients[i] / fi];
            } else {
                set qng += [gradients[i]];
            }
        }
        return qng;
    }

    // ============================================================
    // QGE: Check gradient convergence
    //
    // Checks if gradient magnitude is below threshold.
    //
    // Input:
    //   - gradients: Array of partial derivatives
    //   - threshold: Convergence threshold
    //
    // Output: Bool - true if converged
    //
    // Complexity: O(n)
    //
    // Reference: Standard optimization criteria
    // ============================================================

    function q_qge_converged(gradients : Double[], threshold : Double) : Bool {
        let mag = q_qge_gradient_magnitude(gradients);
        return mag < threshold;
    }

    // ============================================================
    // QGE: Compute optimal learning rate
    //
    // Computes optimal learning rate based on gradient
    // and Fisher information.
    //
    // Input:
    //   - gradient: Current gradient value
    //   - fisher_info: Fisher information for parameter
    //
    // Output: Optimal learning rate
    //
    // Complexity: O(1)
    //
    // Reference: Quantum natural gradient descent
    // ============================================================

    function q_qge_optimal_learning_rate(gradient : Double, fisher_info : Double) : Double {
        if (AbsD(fisher_info) < 1e-10) {
            return 1.0;
        }
        let lr = gradient / fisher_info;
        return lr;
    }

    // ============================================================
    // QGE: Gradient descent step
    //
    // Performs one gradient descent step:
    // θ_new = θ_old - η * ∇f(θ_old)
    //
    // Input:
    //   - params: Current parameters
    //   - gradients: Computed gradients
    //   - learning_rate: Step size η
    //
    // Output: Updated parameters
    //
    // Complexity: O(n)
    //
    // Reference: Standard gradient descent
    // ============================================================

    function q_qge_gradient_descent_step(p : Double[], grads : Double[], lr : Double) : Double[] {
        let n = Length(p);
        mutable new_params = [];
        for i in 0 .. n - 1 {
            let upd = p[i] - lr * grads[i];
            set new_params += [upd];
        }
        return new_params;
    }

    // ============================================================
    // QGE: Compute Hessian-vector product estimate
    //
    // Estimates second-order information for improved
    // gradient estimation.
    //
    // Input:
    //   - f_plus_plus: f(θ + π/2 + π/2)
    //   - f_plus_minus: f(θ + π/2 - π/2)
    //   - f_minus_plus: f(θ - π/2 + π/2)
    //   - f_minus_minus: f(θ - π/2 - π/2)
    //
    // Output: Hessian diagonal estimate
    //
    // Complexity: O(1)
    //
    // Reference: Second-order parameter shift
    // ============================================================

    function q_qge_hessian_estimate(
        f_pp : Double,
        f_pm : Double,
        f_mp : Double,
        f_mm : Double
    ) : Double {
        return (f_pp - f_pm - f_mp + f_mm) / 4.0;
    }

    // ============================================================
    // QGE: Check if parameter shift is valid
    //
    // Parameter shift requires the shift angle to be
    // in (0, π).
    //
    // Input: shift_angle - shift parameter
    // Output: Bool - true if valid
    //
    // Complexity: O(1)
    //
    // Reference: Parameter shift requirements
    // ============================================================

    function q_qge_valid_shift(shift_angle : Double) : Bool {
        return shift_angle > 0.0 and shift_angle < PI();
    }

    // ============================================================
    // QGE: Estimate gradient variance
    //
    // Estimates variance of gradient estimate from
    // measurement statistics.
    //
    // Input:
    //   - samples: Array of measurement samples
    //   - n_samples: Number of samples taken
    //
    // Output: Variance of gradient estimate
    //
    // Complexity: O(n_samples)
    //
    // Reference: Statistical analysis of gradient estimation
    // ============================================================

    function q_qge_gradient_variance(samples : Double[], n_samples : Int) : Double {
        if (Length(samples) == 0 or n_samples == 0) {
            return 0.0;
        }
        mutable mean = 0.0;
        for s in samples {
            set mean = mean + s;
        }
        set mean = mean / IntAsDouble(Length(samples));
        mutable var_sum = 0.0;
        for s in samples {
            let diff = s - mean;
            set var_sum = var_sum + diff * diff;
        }
        return var_sum / IntAsDouble(n_samples);
    }

    // ============================================================
    // QGE: Compute Adam optimizer step
    //
    // Adaptive moment estimation for gradient descent.
    //
    // Input:
    //   - gradient: Current gradient
    //   - m: First moment estimate
    //   - v: Second moment estimate
    //   - beta1: First moment decay
    //   - beta2: Second moment decay
    //   - t: Time step
    //
    // Output: (m, v, update) tuple
    //
    // Complexity: O(1)
    //
    // Reference: Adam optimizer (Kingma & Ba, 2014)
    // ============================================================

    function q_qge_adam_step(
        gradient : Double,
        m : Double,
        v : Double,
        beta1 : Double,
        beta2 : Double,
        t : Int
    ) : (Double, Double, Double) {
        let m_new = beta1 * m + (1.0 - beta1) * gradient;
        let v_new = beta2 * v + (1.0 - beta2) * gradient * gradient;
        let m_hat = m_new / (1.0 - beta1 ^ IntAsDouble(t));
        let v_hat = v_new / (1.0 - beta2 ^ IntAsDouble(t));
        let update = m_hat / (Sqrt(v_hat) + 1e-8);
        return (m_new, v_new, update);
    }

    // ============================================================
    // QGE: Parameter Shift Operation
    //
    // Applies parameter shift: rotates specific parameter qubit
    // by shift_angle, controlled on qs_shift.
    // Implements the parameter shift rule for gradient estimation.
    //
    // Input:
    //   - qs_params: Parameter qubit register
    //   - qs_shift: Control qubits for shift direction
    //   - shift_angle: Rotation angle for shift
    //   - idx: Index of parameter qubit to shift
    //
    // Complexity: O(1)
    // ============================================================

    operation q_ge_parameter_shift(
        qs_params : Qubit[],
        qs_shift : Qubit[],
        shift_angle : Double,
        idx : Int
    ) : Unit {
        if (idx >= 0 and idx < Length(qs_params)) {
            (Controlled Ry)(qs_shift, (shift_angle, qs_params[idx]));
        }
    }
}