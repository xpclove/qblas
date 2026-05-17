// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: VQE Gradient-Based Optimization
//
// What it does:
//   Demonstrates the VQE module's optimization subroutines
//   for gradient-based parameter optimization. Covers the
//   full optimization loop: parameter shifts → gradients →
//   descent step → convergence check → Adam update.
//
// Input:
//   Hard-coded 3-parameter vector p = [0.1, 0.2, 0.3]
//   with shift = π/4, learning rate = 0.1, Adam defaults.
//
// Output:
//   Single integer encoding optimization outcomes:
//     bit 0: gradient descent produced valid update
//     bit 1: Adam step produced valid update
//     bit 2: converged flag (1 if converged)
//
// Pipeline steps and module mapping:
//   Step 1: q_vqe             → Parameter shift (+/-) for gradient estimation
//   Step 2: q_vqe             → Gradient from shifted expectations
//   Step 3: q_vqe             → Weighted sum for expectation aggregation
//   Step 4: q_vqe             → Valid expectation check
//   Step 5: q_vqe             → Gradient descent step
//   Step 6: q_vqe             → Convergence check
//   Step 7: q_vqe             → Adam update
//   Step 8: q_vqe             → Energy convergence check
//
// Verification:
//   - param_shift_plus([0.1,0.2,0.3], π/4) = [0.8854, 0.9854, 1.0854] (Fact)
//   - param_shift_minus([0.1,0.2,0.3], π/4) = [-0.6854, -0.5854, -0.4854] (Fact)
//   - gradient_from_shifts(0.8, 0.4) = 0.2 (Fact)
//   - weighted_sum([0.5,0.3,0.2], [1.0,0.5,-0.5]) = 0.55 (Fact)
//   - valid_expectation(0.5) = true (Fact)
//   - gradient_descent_step([0.5,0.5], [0.1,0.1], 0.1) = [0.49, 0.49] (Fact)
//   - converged([0.001,0.001], 0.01) = true (Fact)
//   - energy_converged(0.5, 0.5, 1e-6) = true (Fact)
//
// Reference: McArdle et al.,
//            "Variational Quantum Eigensolver" (2018)
//            https://arxiv.org/abs/1808.10402
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
    // Full VQE Optimization Pipeline
    // ============================================================

    operation DemoVqeGradient() : Int {
        mutable result = 0;

        // Step 1: Parameter shift (+)
        let pp = [0.1, 0.2, 0.3];
        let shift = PI() / 4.0;
        let shifted_plus = q_vqe_param_shift_plus(pp, shift);
        Fact(Length(shifted_plus) == 3, "param_shift_plus: length");
        Fact(AbsD(shifted_plus[0] - 0.8853981633974483) < 1e-10, "param_shift_plus[0]");
        Fact(AbsD(shifted_plus[1] - 0.9853981633974483) < 1e-10, "param_shift_plus[1]");
        Fact(AbsD(shifted_plus[2] - 1.0853981633974483) < 1e-10, "param_shift_plus[2]");

        // Step 2: Parameter shift (-)
        let shifted_minus = q_vqe_param_shift_minus(pp, shift);
        Fact(AbsD(shifted_minus[0] + 0.6853981633974483) < 1e-10, "param_shift_minus[0]");

        // Step 3: Gradient from shifts
        let grad = q_vqe_gradient_from_shifts(0.8, 0.4);
        Fact(AbsD(grad - 0.2) < 1e-10, "gradient_from_shifts");

        // Step 4: Weighted sum
        let wsum = q_vqe_weighted_sum([0.5, 0.3, 0.2], [1.0, 0.5, -0.5]);
        Fact(AbsD(wsum - 0.55) < 1e-10, "weighted_sum");

        // Step 5: Valid expectation check
        let valid = q_vqe_valid_expectation(0.5) ? 1 | 0;
        Fact(valid == 1, "valid_expectation");
        set result += valid;

        // Step 6: Gradient descent step
        let p_new = q_vqe_gradient_descent_step([0.5, 0.5], [0.1, 0.1], 0.1);
        Fact(Length(p_new) == 2, "gd_step: length");
        Fact(AbsD(p_new[0] - 0.49) < 1e-10, "gd_step[0]");
        Fact(AbsD(p_new[1] - 0.49) < 1e-10, "gd_step[1]");
        set result += 2;

        // Step 7: Convergence check
        let converged = q_vqe_converged([0.001, 0.001], 0.01) ? 1 | 0;
        Fact(converged == 1, "converged");
        set result += 4 * converged;

        // Step 8: Adam step (initialize then update)
        let (m_init, v_init) = q_vqe_init_adam(2);
        let (p_adam, m_new, v_new) = q_vqe_adam_step(
            [0.5, 0.5], [0.1, 0.1], 0.1, 0.9, 0.999, 1e-8, 1, m_init, v_init
        );
        Fact(Length(p_adam) == 2, "adam_step: length");
        Fact(AbsD(p_adam[0] - 0.46837722656059355) < 1e-10, "adam_step[0]");
        set result += 8;

        // Step 9: Energy convergence
        let energy_ok = q_vqe_energy_converged(0.5, 0.5, 1e-6) ? 1 | 0;
        Fact(energy_ok == 1, "energy_converged");

        return result;
    }
}
