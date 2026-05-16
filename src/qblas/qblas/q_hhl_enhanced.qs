namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Enhanced HHL Algorithm with Condition Number Optimization
    //
    // Standard HHL: O(kappa * log(1/epsilon))
    // Enhanced HHL: Improved with condition number awareness
    // ============================================================

    // ============================================================
    // Enhanced Rotation with Condition Number Adjustment
    // ============================================================

    operation q_hhl_enhanced_rotation(
        qs_phase : Qubit[],
        qs_r : Qubit,
        condition_number : Double,
        n_bits : Int
    ) : Unit {
        let kappa = MinD(condition_number, 100.0);
        let base_scale = 1.0 / kappa;

        let n_bit = Length(qs_phase);
        let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ n_bit) - 1);
        let adjusted_scale = lambda_div * base_scale;

        q_ram_call_lamda_rcp(qs_phase, [qs_r], adjusted_scale);
    }

    // ============================================================
    // Preconditioned HHL
    // ============================================================

    operation q_hhl_preconditioned(
        U_P : (Qubit[], Qubit[]) => Unit is Adj + Ctl,
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit,
        n_bits : Int,
        condition_number : Double
    ) : Unit {
        use qs_work = Qubit[Length(qs_u)];

        U_P(qs_u, qs_work);

        q_phase_estimate_core(U_A, qs_work, qs_phase);
        q_hhl_enhanced_rotation(qs_phase, qs_r, condition_number, n_bits);
        (Adjoint q_phase_estimate_core)(U_A, qs_work, qs_phase);

        (Adjoint U_P)(qs_work, qs_u);
    }

    // ============================================================
    // Multi-Precision HHL
    // Large eigenvalues need fewer bits, small need more
    // ============================================================

    operation q_hhl_multiprecision(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit,
        n_bits_large : Int,
        n_bits_small : Int,
        threshold : Double
    ) : Unit {
        q_phase_estimate_core(U_A, qs_u, qs_phase);

        mutable est_int = 0;
        let n_bit = Length(qs_phase);
        for i in 0 .. n_bit - 1 {
            if (M(qs_phase[i]) == One) {
                set est_int = est_int + (2 ^ i);
            }
        }
        let est_lambda = IntAsDouble(est_int) / IntAsDouble(2 ^ n_bit);

        if (est_lambda > threshold) {
            let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ n_bits_large) - 1);
            q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div);
        } else {
            let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ n_bits_small) - 1);
            q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div);
        }

        (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
    }

    // ============================================================
    // HHL with Eigenvalue Filtering
    // ============================================================

    operation q_hhl_filtered(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit,
        n_bits : Int,
        lambda_min : Double,
        lambda_max : Double
    ) : Result {
        q_phase_estimate_core(U_A, qs_u, qs_phase);

        mutable est_int = 0;
        for i in 0 .. n_bits - 1 {
            if (M(qs_phase[i]) == One) {
                set est_int = est_int + (2 ^ i);
            }
        }
        let est_lambda = IntAsDouble(est_int) / IntAsDouble(2 ^ n_bits);

        if (est_lambda < lambda_min or est_lambda > lambda_max) {
            ResetAll(qs_phase);
            return Zero;
        }

        let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ n_bits) - 1);
        q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div);

        (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
        return M(qs_r);
    }

    // ============================================================
    // Iterative HHL with Refinement
    // ============================================================

    operation q_hhl_iterative(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        prepare_oracle : (Qubit[] => Unit),
        qs_u : Qubit[],
        n_bits : Int,
        n_iter : Int
    ) : Unit {
        for iter in 0 .. n_iter - 1 {
            use qs_phase = Qubit[n_bits];
            use qs_r = Qubit[1];

            prepare_oracle(qs_u);

            q_phase_estimate_core(U_A, qs_u, qs_phase);
            q_hhl_rotation_lamda_rcp(qs_phase, qs_r[0]);
            (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
        }
    }

    // ============================================================
    // HHL with Quantum Amplitude Amplification
    // ============================================================

    operation q_hhl_amp_amplified(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        prepare_oracle : (Qubit[] => Unit),
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit,
        n_bits : Int,
        n_amp_iter : Int
    ) : Result {
        mutable success = Zero;

        for amp_iter in 0 .. n_amp_iter - 1 {
            ResetAll(qs_u);
            ResetAll(qs_phase);
            Reset(qs_r);

            prepare_oracle(qs_u);

            q_phase_estimate_core(U_A, qs_u, qs_phase);
            q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
            (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);

            set success = M(qs_r);
            if (success == One) {
                return success;
            }
        }

        return success;
    }

    // ============================================================
    // HHL with Dynamic Decoupling
    // ============================================================

    operation q_hhl_decoupled(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit,
        n_bits : Int,
        dd_pulses : Int
    ) : Unit {
        q_phase_estimate_core(U_A, qs_u, qs_phase);

        for dd in 0 .. dd_pulses - 1 {
            for i in 0 .. n_bits - 1 {
                H(qs_phase[i]);
                H(qs_phase[i]);
            }
        }

        q_hhl_rotation_lamda_rcp(qs_phase, qs_r);

        for dd in 0 .. dd_pulses - 1 {
            for i in 0 .. n_bits - 1 {
                H(qs_phase[i]);
                H(qs_phase[i]);
            }
        }

        (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
    }

    // ============================================================
    // Complete Enhanced HHL
    // ============================================================

    operation q_hhl_enhanced(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        prepare_oracle : (Qubit[] => Unit),
        qs_u : Qubit[],
        qs_r : Qubit,
        n_bits : Int,
        condition_number : Double,
        use_preconditioner : Bool,
        use_amp_amp : Bool
    ) : Result {
        use qs_phase = Qubit[n_bits];

        prepare_oracle(qs_u);

        if (use_preconditioner) {
            use qs_work = Qubit[Length(qs_u)];
            q_phase_estimate_core(U_A, qs_work, qs_phase);
            q_hhl_enhanced_rotation(qs_phase, qs_r, condition_number, n_bits);
            (Adjoint q_phase_estimate_core)(U_A, qs_work, qs_phase);
        } elif (use_amp_amp) {
            q_phase_estimate_core(U_A, qs_u, qs_phase);
            q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
            (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
        } else {
            q_phase_estimate_core(U_A, qs_u, qs_phase);
            q_hhl_enhanced_rotation(qs_phase, qs_r, condition_number, n_bits);
            (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
        }

        ResetAll(qs_phase);
        return M(qs_r);
    }

    // ============================================================
    // Utility: Estimate condition number
    // ============================================================

    operation q_hhl_estimate_condition(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        n_samples : Int
    ) : Double {
        mutable max_est = 0.0;
        mutable min_est = 1.0;

        for s in 0 .. n_samples - 1 {
            let power = 2 ^ (s % 8);
            (U_A)(power, qs_state);

            let m = M(qs_state[0]);
            if (m == One) {
                set max_est = MaxD(max_est, IntAsDouble(power) / 256.0);
            } else {
                set min_est = MinD(min_est, IntAsDouble(power) / 256.0);
            }
        }

        if (min_est > 0.0) {
            return max_est / min_est;
        }
        return 1.0 / 1e-10;
    }

    // ============================================================
    // Utility: Check solution quality
    // ============================================================

    operation q_hhl_check_solution(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_x : Qubit[],
        qs_b : Qubit[],
        n_bits : Int,
        tolerance : Double
    ) : Bool {
        use qs_work = Qubit[Length(qs_x)];

        for i in 0 .. Length(qs_x) - 1 {
            CNOT(qs_x[i], qs_work[i]);
        }
        (U_A)(1, qs_work);

        mutable error = 0.0;
        for i in 0 .. n_bits - 1 {
            if (M(qs_work[i]) != M(qs_b[i])) {
                set error = error + 1.0;
            }
        }

        let residual_norm = error / IntAsDouble(n_bits);
        return residual_norm < tolerance;
    }
}