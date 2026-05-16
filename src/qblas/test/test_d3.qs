namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    // ============================================================
    // D3: Tests for previously untested modules
    // ============================================================

    // --- error_mitigation (ZNE) ---
    operation test_d3_zne_linear(p : Int) : Double {
        let _r = q_zne_linear([1.0, 0.8]);
        Fact(AbsD(_r - 1.2) < 1e-10, "test_d3_zne_linear");
        return _r;
    }

    operation test_d3_zne_noise_factors(p : Int) : Int {
        let _r = Length(q_zne_noise_factors(0.1, [1, 2, 3]));
        Fact(_r == 3, "test_d3_zne_noise_factors");
        return _r;
    }

    // --- error_mitigation (PEC) ---
    operation test_d3_pec_validate_valid(p : Int) : Int {
        let _r = q_pec_validate([0.5, 0.3, 0.2]) ? 1 | 0;
        Fact(_r == 1, "test_d3_pec_validate_valid");
        return _r;
    }

    operation test_d3_pec_validate_empty(p : Int) : Int {
        let _r = q_pec_validate([]) ? 1 | 0;
        Fact(_r == 0, "test_d3_pec_validate_empty");
        return _r;
    }

    operation test_d3_pec_sampling_prob(p : Int) : Double {
        let _r = q_pec_sampling_prob([0.5, -0.3, 0.2]);
        Fact(AbsD(_r - 1.0) < 1e-10, "test_d3_pec_sampling_prob");
        return _r;
    }

    // --- error_mitigation (DD) ---
    operation test_d3_dd_xy_length(p : Int) : Int {
        let _r = Length(q_dd_xy_sequence(4, 0.5));
        Fact(_r == 4, "test_d3_dd_xy_length");
        return _r;
    }

    operation test_d3_dd_validate_basic(p : Int) : Int {
        let _r = q_dd_validate_sequence(["X", "Y", "X"]) ? 1 | 0;
        // XY sequence requires n ≥ 2, each pair must be different
        Fact(_r == 0, "test_d3_dd_validate_basic");
        return _r;
    }

    operation test_d3_dd_validate_bad(p : Int) : Int {
        let _r = q_dd_validate_sequence(["Z"]) ? 1 | 0;
        Fact(_r == 0, "test_d3_dd_validate_bad");
        return _r;
    }

    operation test_d3_dd_padding(p : Int) : Double {
        let _r = q_dd_padding_interval(1.0, 4);
        Fact(AbsD(_r - 0.2) < 1e-10, "test_d3_dd_padding");
        return _r;
    }

    // --- gradient_estimation ---
    operation test_d3_ge_shift_angle(p : Int) : Double {
        let _r = q_qge_shift_angle();
        Fact(AbsD(_r - 1.5707963267948966) < 1e-10, "test_d3_ge_shift_angle");
        return _r;
    }

    operation test_d3_ge_gradient_magnitude(p : Int) : Double {
        let _r = q_qge_gradient_magnitude([1.0, 2.0, 3.0]);
        Fact(AbsD(_r - 3.7416573867739413) < 1e-10, "test_d3_ge_gradient_magnitude");
        return _r;
    }

    operation test_d3_ge_converged(p : Int) : Int {
        let _r = q_qge_converged([0.1, 0.2], 0.5) ? 1 | 0;
        Fact(_r == 1, "test_d3_ge_converged");
        return _r;
    }

    operation test_d3_ge_optimal_lr(p : Int) : Double {
        let _r = q_qge_optimal_learning_rate(0.5, 2.0);
        Fact(AbsD(_r - 0.25) < 1e-10, "test_d3_ge_optimal_lr");
        return _r;
    }

    operation test_d3_ge_valid_shift(p : Int) : Int {
        let _r = q_qge_valid_shift(PI() / 4.0) ? 1 | 0;
        Fact(_r == 1, "test_d3_ge_valid_shift");
        return _r;
    }

    operation test_d3_ge_gradient_variance(p : Int) : Double {
        let _r = q_qge_gradient_variance([1.0, 2.0, 3.0], 3);
        Fact(AbsD(_r - 0.6666666666666666) < 1e-10, "test_d3_ge_gradient_variance");
        return _r;
    }

    // --- regularized_ls ---
    operation test_d3_rls_check_lambda_ok(p : Int) : Int {
        let _r = q_rls_check_lambda(0.1, 1e-6) ? 1 | 0;
        Fact(_r == 1, "test_d3_rls_check_lambda_ok");
        return _r;
    }

    operation test_d3_rls_check_lambda_bad(p : Int) : Int {
        let _r = q_rls_check_lambda(-0.1, 1e-6) ? 1 | 0;
        Fact(_r == 0, "test_d3_rls_check_lambda_bad");
        return _r;
    }

    // --- conjugate_gradient ---
    operation test_d3_cg_converged(p : Int) : Int {
        let _r = q_cg_converged(0.01, 1.0, 1e-6) ? 1 | 0;
        Fact(_r == 0, "test_d3_cg_converged");
        return _r;
    }

    // --- math ---
    operation test_d3_math_nbit_float(p : Int) : Int {
        let _r = q_com_real_nbit_float();
        Fact(_r == 2, "test_d3_math_nbit_float");
        return _r;
    }

    // --- amplitude_amplification ---
    operation test_d3_qaa_optimal_iters(p : Int) : Int {
        let _r = q_qaa_optimal_iterations(0.5, 10);
        Fact(_r == 0, "test_d3_qaa_optimal_iters");
        return _r;
    }

    operation test_d3_qaa_valid_iters(p : Int) : Int {
        let _r = q_qaa_valid_iterations(3, 0.5) ? 1 | 0;
        Fact(_r == 0, "test_d3_qaa_valid_iters");
        return _r;
    }

    operation test_d3_qaa_schedule_len(p : Int) : Int {
        let _r = Length(q_qaa_schedule(0.5, 0.1));
        Fact(_r >= 1, "test_d3_qaa_schedule_len");
        return _r;
    }

    // --- block_encoding_v2 ---
    operation test_d3_qrom_compute_addr(p : Int) : Int {
        let _r = qrom_compute_addr_bits(8);
        Fact(_r >= 1, "test_d3_qrom_compute_addr");
        return _r;
    }

    // --- readout correction ---
    operation test_d3_readout_calib_len(p : Int) : Int {
        let _r = Length(q_readout_calibration([[0.9, 0.1], [0.1, 0.9]]));
        Fact(_r == 2, "test_d3_readout_calib_len");
        return _r;
    }
}
