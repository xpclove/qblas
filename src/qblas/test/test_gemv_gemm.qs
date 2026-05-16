namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    open qblas;

    operation test_gemv_diagonal(p : Int) : Double {
        mutable res = 0.0;
        use qs = Qubit[4];
        let diag = [1.0, 0.5, 0.25, 0.125];
        q_gemv_diagonal(diag, qs);
        ResetAll(qs);
        return res;
    }

    operation test_gemv_iterated(p : Int) : Double {
        use qs = Qubit[3];
        use qs_work = Qubit[4];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemv_iterated(ora, qs, qs_work, PI() / 4.0, 2);
        ResetAll(qs);
        ResetAll(qs_work);
        return 1.0;
    }

    operation test_gemv_batch(p : Int) : Int {
        use qs1 = Qubit[3];
        use qs2 = Qubit[3];
        use qs_work = Qubit[4];
        let vectors = [qs1, qs2];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemv_batch(ora, vectors, qs_work, PI() / 4.0);
        ResetAll(qs1);
        ResetAll(qs2);
        ResetAll(qs_work);
        return 1;
    }

    operation test_gemm_iterated(p : Int) : Double {
        use qs_a = Qubit[3];
        use qs_b = Qubit[3];
        use qs_c = Qubit[3];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemm_iterated(ora, ora, qs_a, qs_b, qs_c, PI() / 4.0, 2);
        ResetAll(qs_a);
        ResetAll(qs_b);
        ResetAll(qs_c);
        return 1.0;
    }

    operation test_gemm_block(p : Int) : Double {
        use qs_a = Qubit[4];
        use qs_b = Qubit[4];
        use qs_c = Qubit[4];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemm_block(ora, ora, 2, qs_a, qs_b, qs_c);
        ResetAll(qs_a);
        ResetAll(qs_b);
        ResetAll(qs_c);
        return 1.0;
    }

    operation test_gemm_diag_general(p : Int) : Double {
        use qs_diag = Qubit[4];
        use qs_b = Qubit[4];
        use qs_c = Qubit[4];
        let diag = [1.0, 0.5, 0.25, 0.125];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemm_diag_general(diag, ora, qs_diag, qs_b, qs_c);
        ResetAll(qs_diag);
        ResetAll(qs_b);
        ResetAll(qs_c);
        return 1.0;
    }

    operation test_gemm_transpose_a(p : Int) : Double {
        use qs_a = Qubit[3];
        use qs_b = Qubit[3];
        use qs_c = Qubit[3];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemm_transpose_a(ora, ora, qs_a, qs_b, qs_c);
        ResetAll(qs_a);
        ResetAll(qs_b);
        ResetAll(qs_c);
        return 1.0;
    }

    operation test_gemm_transpose_b(p : Int) : Double {
        use qs_a = Qubit[3];
        use qs_b = Qubit[3];
        use qs_c = Qubit[3];
        let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
        q_gemm_transpose_b(ora, ora, qs_a, qs_b, qs_c);
        ResetAll(qs_a);
        ResetAll(qs_b);
        ResetAll(qs_c);
        return 1.0;
    }

    operation test_gemm_batch(p : Int) : Int {
        mutable count = 0;
        for iter in 0 .. 2 {
            use qs_a = Qubit[3];
            use qs_b = Qubit[3];
            use qs_c = Qubit[3];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            let pairs = [(qs_a, qs_b, qs_c)];
            q_gemm_batch(ora, ora, pairs, PI() / 4.0);
            set count = count + 1;
            ResetAll(qs_a);
            ResetAll(qs_b);
            ResetAll(qs_c);
        }
        return count;
    }

    operation test_gemm_check_dims(p : Int) : Int {
        let (m, n, k) = q_gemm_check_dims(4, 4, 4, 4);
        return m;
    }

    operation test_svd_estimate_condition(p : Int) : Double {
        let singular_values = [1.0, 0.5, 0.25, 0.125];
        let cond = q_svd_estimate_condition(singular_values);
        return cond;
    }

    operation test_svd_sort_descending(p : Int) : Int {
        let values = [0.25, 1.0, 0.5, 0.125];
        let sorted = q_svd_sort_descending(values);
        return 1;
    }

    operation test_svd_filter(p : Int) : Int {
        let values = [1.0, 0.5, 0.25, 0.125];
        let filtered = q_svd_filter(values, 0.3);
        return Length(filtered);
    }

    operation test_svd_normalize(p : Int) : Int {
        let values = [1.0, 0.5, 0.25, 0.125];
        let normalized = q_svd_normalize(values);
        return Length(normalized);
    }

    operation test_hhl_enhanced_rotation(p : Int) : Double {
        mutable res = 0.0;
        use qs_phase = Qubit[4];
        use qs_r = Qubit[1];
        q_hhl_enhanced_rotation(qs_phase, qs_r[0], 10.0, 4);
        ResetAll(qs_phase);
        ResetAll(qs_r);
        return res;
    }

    operation test_hhl_filtered(p : Int) : Int {
        mutable success = 0;
        use qs_u = Qubit[1];
        use qs_phase = Qubit[4];
        use qs_r = Qubit[1];
        X(qs_u[0]);
        let result = q_hhl_filtered(U_hhl, qs_u, qs_phase, qs_r[0], 4, 0.1, 0.9);
        if (result == One) {
            set success = 1;
        }
        ResetAll(qs_u);
        ResetAll(qs_phase);
        ResetAll(qs_r);
        return success;
    }

    operation test_hhl_multiprecision(p : Int) : Double {
        mutable res = 0.0;
        use qs_u = Qubit[1];
        use qs_phase = Qubit[4];
        use qs_r = Qubit[1];
        X(qs_u[0]);
        q_hhl_multiprecision(U_hhl, qs_u, qs_phase, qs_r[0], 4, 8, 0.5);
        ResetAll(qs_u);
        ResetAll(qs_phase);
        ResetAll(qs_r);
        return 1.0;
    }

    operation test_hhl_check_solution(p : Int) : Int {
        return 0;
    }

    // ============================================================
    // QSVT Tests
    // ============================================================

    operation test_qsvt_apply_diagonal(p : Int) : Double {
        use qs = Qubit[4];
        let diag = [1.0, 0.5, 0.25, 0.125];
        q_qsvt_apply_diagonal(diag, qs);
        ResetAll(qs);
        return 1.0;
    }

    operation test_qsvt_amplitude_encode(p : Int) : Double {
        use qs = Qubit[4];
        let data = [1.0, 0.5, 0.25, 0.125];
        q_qsvt_amplitude_encode(data, qs);
        ResetAll(qs);
        return 1.0;
    }

    operation test_qsvt_normalize_vector(p : Int) : Int {
        let v = [1.0, 2.0, 2.0, 1.0];
        let norm_v = q_qsvt_normalize_vector(v);
        return Length(norm_v);
    }

    operation test_qsvt_check_dims(p : Int) : Int {
        let check1 = q_qsvt_check_dims(8, 4);
        let check2 = q_qsvt_check_dims(16, 5);
        return check1 and check2 ? 1 | 0;
    }

    // ============================================================
    // QRLS Tests (function tests only, no oracle needed)
    // ============================================================

    operation test_q_rls_lambda_cv(p : Int) : Double {
        let lambda = q_rls_lambda_cv(100, 50.0, 0.001);
        return lambda;
    }

    operation test_q_rls_check_lambda(p : Int) : Int {
        let check = q_rls_check_lambda(0.1, 0.001);
        return check ? 1 | 0;
    }

    operation test_q_rls_effective_condition(p : Int) : Double {
        let cond = q_rls_effective_condition(50.0, 0.1);
        return cond;
    }

    // ============================================================
    // Block Encoding Tests
    // ============================================================

    operation test_q_be_diagonal(p : Int) : Int {
        use qs_data = Qubit[4];
        use qs_ancilla = Qubit[1];
        let diag = [1.0, 0.5, 0.25, 0.125];
        q_be_diagonal(diag, qs_data, qs_ancilla[0]);
        ResetAll(qs_data);
        ResetAll(qs_ancilla);
        return 1;
    }

    operation test_q_be_householder(p : Int) : Int {
        use qs_data = Qubit[3];
        let vector = [1.0, 0.5, 0.25];
        q_be_householder(vector, qs_data);
        ResetAll(qs_data);
        return 1;
    }

    operation test_q_be_tridiagonal(p : Int) : Int {
        use qs_data = Qubit[3];
        let diag = [1.0, 0.5, 0.25];
        let sub = [0.1, 0.05];
        let super = [0.2, 0.1];
        q_be_tridiagonal(diag, sub, super, qs_data);
        ResetAll(qs_data);
        return 1;
    }

    operation test_q_be_compute_scaling(p : Int) : Double {
        let matrix = [[1.0, 0.5], [0.5, 0.25]];
        let scaling = q_be_compute_scaling(matrix);
        return scaling;
    }

    operation test_q_be_check_sparsity(p : Int) : Int {
        let entries = [(0, 0, 1.0), (0, 1, 0.5), (1, 0, 0.5), (1, 1, 0.25)];
        let check = q_be_check_sparsity(entries, 2);
        return check ? 1 | 0;
    }

    operation test_pseudoinverse_coeffs(p : Int) : Double {
        let kappa = 10.0;
        let precision = 1e-3;
        let coeffs = q_pseudoinverse_coeffs(kappa, precision);
        return IntAsDouble(Length(coeffs));
    }

    operation test_pseudoinverse_check(p : Int) : Int {
        let kappa = 10.0;
        let precision = 1e-3;
        let applicable = q_pseudoinverse_check_applicable(kappa, precision);
        return applicable ? 1 | 0;
    }

    operation test_pseudoinverse_effective_condition(p : Int) : Double {
        let kappa = 10.0;
        let rank_def = 0.1;
        let eff_kappa = q_pseudoinverse_effective_condition(kappa, rank_def);
        return eff_kappa;
    }

    operation test_chebyshev_polynomials(p : Int) : Double {
        let x = 0.5;
        let degree = 3;
        let polys = q_chebyshev_polynomials(x, degree);
        return IntAsDouble(Length(polys));
    }

    operation test_chebyshev_coefficients(p : Int) : Double {
        let coeffs = q_chebyshev_coefficients_for_sigmoid(-1.0, 1.0, 4);
        return IntAsDouble(Length(coeffs));
    }

    operation test_chebyshev_map(p : Int) : Double {
        let x = 0.5;
        let mapped = q_chebyshev_map_to_interval(x, -1.0, 1.0);
        return mapped;
    }

    operation test_chebyshev_error_bound(p : Int) : Double {
        let coeffs = [1.0, 0.5, 0.25, 0.125, 0.0625];
        let error = q_chebyshev_error_bound(coeffs, 2);
        return error;
    }

    operation test_chebyshev_select_degree(p : Int) : Int {
        let spectral_radius = 2.0;
        let precision = 1e-3;
        let degree = q_chebyshev_select_degree(spectral_radius, precision);
        return degree;
    }

    operation test_matrix_trace_power(p : Int) : Int {
        return 1;
    }

    operation test_eigenvalue_filter_lowpass(p : Int) : Int {
        let coeffs = q_eigenvalue_filter_lowpass(0.1, 1.0, 1e-3);
        return IntAsDouble(Length(coeffs)) > 0.0 ? 1 | 0;
    }

    operation test_eigenvalue_filter_highpass(p : Int) : Int {
        let coeffs = q_eigenvalue_filter_highpass(0.5, 1.0, 1e-3);
        return IntAsDouble(Length(coeffs)) > 0.0 ? 1 | 0;
    }

    operation test_eigenvalue_filter_bandpass(p : Int) : Int {
        let coeffs = q_eigenvalue_filter_bandpass(0.3, 0.7, 1.0, 1e-3);
        return IntAsDouble(Length(coeffs)) > 0.0 ? 1 | 0;
    }

    operation test_eigenvalue_filter_verify(p : Int) : Int {
        let filter_coeffs = [1.0, -0.5, 0.25];
        let valid = q_eigenvalue_filter_verify(filter_coeffs, 0.9, 0.1, 0.1);
        return valid ? 1 | 0;
    }
}