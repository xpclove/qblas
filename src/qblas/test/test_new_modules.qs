namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open qblas;

    operation test_cg_residual_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_cg_residual_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_cg_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let b_norm = 1.0;
            let eps = 1e-6;
            return q_cg_converged(r_norm, b_norm, eps) ? 1 | 0;
        }
    }

    operation test_cg_compute_beta(p : Int) : Double {
        body {
            let beta = q_cg_compute_beta(0.25, 1.0);
            return beta;
        }
    }

    operation test_cg_compute_alpha(p : Int) : Double {
        body {
            let alpha = q_cg_compute_alpha(0.5, 2.0);
            return alpha;
        }
    }

    operation test_lanczos_norm(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_lanczos_norm(v);
        }
    }

    operation test_lanczos_normalize(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 2.0];
            let n = q_lanczos_normalize(v);
            return IntAsDouble(Length(n));
        }
    }

    operation test_lanczos_alpha_compute(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_lanczos_alpha_compute(v);
        }
    }

    operation test_lanczos_beta_compute(p : Int) : Double {
        body {
            let v = [3.0, 4.0];
            return q_lanczos_beta_compute(v);
        }
    }

    operation test_lanczos_tridiag(p : Int) : Int {
        body {
            let alphas = [1.0, 2.0, 3.0];
            let betas = [0.5, 0.5];
            let mat = q_lanczos_tridiag(alphas, betas);
            return Length(mat);
        }
    }

    operation test_lanczos_eigenvalue_sum(p : Int) : Double {
        body {
            let eigenvalues = [1.0, 2.0, 3.0];
            return q_lanczos_eigenvalue_sum(eigenvalues);
        }
    }

    operation test_krylov_residual_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_krylov_residual_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_krylov_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let init_norm = 1.0;
            let eps = 1e-6;
            return q_krylov_converged(r_norm, init_norm, eps) ? 1 | 0;
        }
    }

    operation test_krylov_norm_sq(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_krylov_norm_sq(v);
        }
    }

    operation test_krylov_inner_product(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            let w = [0.5, 1.0, 1.5];
            return q_krylov_inner_product(v, w);
        }
    }

    operation test_gmres_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_gmres_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_gmres_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let init_norm = 1.0;
            let eps = 1e-6;
            return q_gmres_converged(r_norm, init_norm, eps) ? 1 | 0;
        }
    }

    operation test_gmres_hessenberg_size(p : Int) : Int {
        body {
            let (m, n) = q_gmres_hessenberg_size(5);
            return m;
        }
    }

    operation test_gd_norm(p : Int) : Double {
        body {
            let g = [1.0, 2.0, 3.0];
            return q_gd_norm(g);
        }
    }

    operation test_gd_converged(p : Int) : Int {
        body {
            let gradient = [0.001, 0.001, 0.001];
            let eps = 0.01;
            return q_gd_converged(gradient, eps) ? 1 | 0;
        }
    }

    operation test_gd_norm_sq(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_gd_norm_sq(v);
        }
    }

    operation test_newton_norm(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_newton_norm(v);
        }
    }

    operation test_newton_converged(p : Int) : Int {
        body {
            let gradient = [0.001, 0.001, 0.001];
            let delta = [0.0001, 0.0001, 0.0001];
            let eps = 0.01;
            return q_newton_converged(gradient, delta, eps) ? 1 | 0;
        }
    }

    operation test_pca_eigenvalue_norm(p : Int) : Double {
        body {
            let eigenvalues = [1.0, -2.0, 3.0];
            return q_pca_eigenvalue_norm(eigenvalues);
        }
    }

    operation test_pca_explained_var(p : Int) : Int {
        body {
            let eigenvalues = [4.0, 2.0, 2.0];
            let ratios = q_pca_explained_var(eigenvalues);
            return Length(ratios);
        }
    }

    operation test_pca_projection_matrix(p : Int) : Int {
        body {
            let eigenvalues = [4.0, 2.0, 2.0];
            let P = q_pca_projection_matrix(2, eigenvalues, 1.0);
            return Length(P);
        }
    }

    operation test_ridge_effective_cond(p : Int) : Double {
        body {
            let kappa = 10.0;
            let lambda = 0.1;
            return q_ridge_effective_cond(kappa, lambda);
        }
    }

    operation test_ridge_lambda_opt(p : Int) : Double {
        body {
            let kappa = 10.0;
            let n = 100;
            let d = 10;
            return q_ridge_lambda_opt(kappa, n, d);
        }
    }

    operation test_ridge_matrix_dim(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]];
            let (m, n) = q_ridge_matrix_dim(A);
            return m;
        }
    }

    operation test_trisol_is_triangular(p : Int) : Int {
        body {
            let A_lower = [[1.0, 0.0], [0.5, 1.0]];
            let is_lower = true;
            return q_trisol_is_triangular(A_lower, is_lower) ? 1 | 0;
        }
    }

    operation test_trisol_diagonal_nonzero(p : Int) : Int {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            return q_trisol_diagonal_nonzero(A) ? 1 | 0;
        }
    }

    operation test_trisol_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_trisol_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_qsp_is_valid_phase(p : Int) : Int {
        body {
            let phases = [0.1, 0.2, 0.3, -0.3, -0.2, -0.1];
            return q_qsp_is_valid_phase(phases) ? 1 | 0;
        }
    }

    operation test_qsp_poly_eval(p : Int) : Double {
        body {
            let coeffs = [1.0, 2.0, 1.0];
            let result = q_qsp_poly_eval(coeffs, 0.5);
            return result;
        }
    }

    operation test_qsp_phase_from_degree(p : Int) : Double {
        body {
            let phi = q_qsp_phase_from_degree(5);
            return phi;
        }
    }

    operation test_qsp_symmetric_phase_seq(p : Int) : Int {
        body {
            let seq = q_qsp_symmetric_phase_seq(3);
            return Length(seq);
        }
    }

    operation test_qsp_apply_rotation(p : Int) : Double {
        body {
            use qs_target = Qubit[1];
            use qs_ancilla = Qubit[2];
            let phases = [0.1, 0.2, 0.3];
            q_qsp_apply_rotation(qs_target[0], qs_ancilla, phases, PI() / 4.0);
            ResetAll(qs_target);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_qsp_polynomial_unitary(p : Int) : Double {
        body {
            use qs_data = Qubit[2];
            use qs_ancilla = Qubit[2];
            let phases = [0.1, 0.2, 0.3, -0.3, -0.2, -0.1];
            let coeffs = [1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125];
            q_qsp_kernel(qs_data, qs_ancilla, phases, coeffs);
            ResetAll(qs_data);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_qsp_eigenvalue_transform(p : Int) : Double {
        body {
            use qs_phase = Qubit[2];
            use qs_target = Qubit[1];
            let phases = [0.1, 0.2, 0.3];
            q_qsp_eigenvalue_transform(qs_phase, qs_target[0], phases, PI() / 6.0);
            ResetAll(qs_phase);
            ResetAll(qs_target);
            return 1.0;
        }
    }

    operation test_qsp_chebyshev_phase(p : Int) : Int {
        body {
            let phases = q_qsp_chebyshev_phase(5);
            return Length(phases);
        }
    }

    operation test_qsp_kernel(p : Int) : Double {
        body {
            use qs_signal = Qubit[2];
            use qs_ancilla = Qubit[2];
            let phases = [0.1, 0.2, 0.3];
            let coeffs = [1.0, 0.5, 0.25];
            q_qsp_kernel(qs_signal, qs_ancilla, phases, coeffs);
            ResetAll(qs_signal);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_qsp_validate_sequence(p : Int) : Int {
        body {
            let phases = [0.1, 0.2, 0.3, 0.4];
            let valid = q_qsp_validate_sequence(phases, 2, 1e-6);
            return valid ? 1 | 0;
        }
    }

    operation test_qsp_linear_combination(p : Int) : Double {
        body {
            use qs_target = Qubit[1];
            use qs_ancilla = Qubit[2];
            let coeffs = [1.0, 0.5, 0.25, 0.125];
            q_qsp_linear_combination(qs_target[0], qs_ancilla, coeffs, PI() / 8.0);
            ResetAll(qs_target);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_trotter_step_size(p : Int) : Double {
        body {
            let norms = [1.0, 2.0, 1.5];
            let dt = q_trotter_step_size(norms, PI(), 10);
            return dt;
        }
    }

    operation test_trotter_suzuki_2_coeffs(p : Int) : Int {
        body {
            let coeffs = q_trotter_suzuki_2_coeffs(3);
            return Length(coeffs);
        }
    }

    operation test_trotter_suzuki_high_order_coeffs(p : Int) : Int {
        body {
            let coeffs = q_trotter_suzuki_high_order_coeffs(2, 3);
            return Length(coeffs);
        }
    }

    operation test_trotter_optimal_steps(p : Int) : Int {
        body {
            let steps = q_trotter_optimal_steps(5.0, PI(), 2, 1e-6);
            return steps;
        }
    }

    operation test_trotter_first_order(p : Int) : Double {
        body {
            use qs_state = Qubit[3];
            use qs_ancilla = Qubit[5];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            let oracles = [ora];
            q_trotter_first_order(oracles, qs_state, qs_ancilla, PI() / 4.0);
            ResetAll(qs_state);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_trotter_suzuki_2nd_order(p : Int) : Double {
        body {
            use qs_state = Qubit[3];
            use qs_ancilla = Qubit[5];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            let oracles = [ora];
            q_trotter_suzuki_2nd_order(oracles, qs_state, qs_ancilla, PI() / 4.0);
            ResetAll(qs_state);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_trotter_C_first_order(p : Int) : Double {
        body {
            use qs_controls = Qubit[1];
            use qs_state = Qubit[3];
            use qs_ancilla = Qubit[5];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            let oracles = [ora];
            q_trotter_C_first_order(qs_controls, oracles, qs_state, qs_ancilla, PI() / 4.0);
            ResetAll(qs_controls);
            ResetAll(qs_state);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_trotter_is_valid_order(p : Int) : Int {
        body {
            let valid2 = q_trotter_is_valid_order(2) ? 1 | 0;
            let valid4 = q_trotter_is_valid_order(4) ? 1 | 0;
            let invalid3 = q_trotter_is_valid_order(3) ? 1 | 0;
            return valid2 * 100 + valid4 * 10 + invalid3;
        }
    }

    operation test_trotter_error_bound(p : Int) : Double {
        body {
            let norms = [1.0, 2.0, 1.5];
            let err = q_trotter_error_bound(norms, PI(), 10, 1);
            return err;
        }
    }

    operation test_trotter_decomposition_length(p : Int) : Int {
        body {
            let len2 = q_trotter_decomposition_length(2);
            let len4 = q_trotter_decomposition_length(4);
            return len2 * 10 + len4;
        }
    }

    operation test_trotter_verify_hamiltonian(p : Int) : Int {
        body {
            let norms = [1.0, 2.0, 1.5];
            return q_trotter_verify_hamiltonian(norms) ? 1 | 0;
        }
    }

    operation test_trotter_check_ancilla(p : Int) : Int {
        body {
            let result = q_trotter_check_ancilla(10, 4, 3) ? 1 | 0;
            return result;
        }
    }

    operation test_2sparse_is_2sparse(p : Int) : Int {
        body {
            let matrix = [[1.0, 0.0, 0.5], [0.0, 2.0, 0.0], [0.5, 0.0, 3.0]];
            return q_2sparse_is_2sparse(matrix, 1e-10) ? 1 | 0;
        }
    }

    operation test_2sparse_check_row_sparsity(p : Int) : Int {
        body {
            let matrix = [[1.0, 0.0, 0.5], [0.0, 2.0, 0.0], [0.5, 0.0, 3.0]];
            let result = q_2sparse_check_row_sparsity(matrix, 0, 2, 1e-10) ? 1 | 0;
            return result;
        }
    }

    operation test_2sparse_row_norm(p : Int) : Double {
        body {
            let matrix = [[1.0, 0.0, 0.5], [0.0, 2.0, 0.0], [0.5, 0.0, 3.0]];
            let norm = q_2sparse_row_norm(matrix, 0, 1e-10);
            return norm;
        }
    }

    operation test_2sparse_find_nonzero(p : Int) : Int {
        body {
            let matrix = [[1.0, 0.0, 0.5], [0.0, 2.0, 0.0], [0.5, 0.0, 3.0]];
            let entries = q_2sparse_find_nonzero(matrix, 0, 1e-10);
            return Length(entries);
        }
    }

    operation test_2sparse_combined_norm(p : Int) : Double {
        body {
            let norms1 = [1.0, 2.0, 1.5];
            let norms2 = [0.5, 1.0, 0.8];
            return q_2sparse_combined_norm(norms1, norms2);
        }
    }

    operation test_2sparse_walk_simulation(p : Int) : Double {
        body {
            use qs_state = Qubit[2];
            use qs_ancilla = Qubit[4];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            q_2sparse_walk_simulation(ora, ora, qs_state, qs_ancilla, PI() / 4.0);
            ResetAll(qs_state);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_2sparse_C_walk_simulation(p : Int) : Double {
        body {
            use qs_controls = Qubit[1];
            use qs_state = Qubit[2];
            use qs_ancilla = Qubit[4];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            q_2sparse_C_walk_simulation(qs_controls, ora, ora, qs_state, qs_ancilla, PI() / 4.0);
            ResetAll(qs_controls);
            ResetAll(qs_state);
            ResetAll(qs_ancilla);
            return 1.0;
        }
    }

    operation test_2sparse_stride_bits(p : Int) : Int {
        body {
            let bits = q_2sparse_stride_bits(4, 2);
            return bits;
        }
    }

    operation test_2sparse_estimate_norm(p : Int) : Double {
        body {
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            let norm = q_2sparse_estimate_norm(ora, ora, 3);
            return norm;
        }
    }

    operation test_2sparse_verify_decomposition(p : Int) : Int {
        body {
            let matrix = [[1.0, 0.0], [0.0, 1.0]];
            let H1 = [[1.0, 0.0], [0.0, 0.0]];
            let H2 = [[0.0, 0.0], [0.0, 1.0]];
            return q_2sparse_verify_decomposition(matrix, H1, H2, 1e-10) ? 1 | 0;
        }
    }

    operation test_2sparse_optimal_steps(p : Int) : Int {
        body {
            let steps = q_2sparse_optimal_steps(2.0, PI(), 1e-6);
            return steps;
        }
    }

    operation test_2sparse_check_ancilla(p : Int) : Int {
        body {
            let result = q_2sparse_check_ancilla(8, 3, 2, 1) ? 1 | 0;
            return result;
        }
    }

    operation test_2sparse_eigenvalue_bound(p : Int) : Double {
        body {
            let matrix = [[3.0, 1.0], [1.0, 2.0]];
            return q_2sparse_eigenvalue_bound(matrix);
        }
    }

    operation test_qaa_optimal_iterations(p : Int) : Int {
        body {
            let m = q_qaa_optimal_iterations(0.25, 100);
            return m;
        }
    }

    operation test_qaa_speedup(p : Int) : Double {
        body {
            let speedup = q_qaa_speedup(0.25);
            return speedup;
        }
    }

    operation test_qaa_valid_iterations(p : Int) : Int {
        body {
            let valid = q_qaa_valid_iterations(10, 0.25) ? 1 | 0;
            return valid;
        }
    }

    operation test_qaa_schedule(p : Int) : Int {
        body {
            let sched = q_qaa_schedule(0.1, 1e-6);
            return Length(sched);
        }
    }

    operation test_qaa_state_reflection(p : Int) : Double {
        body {
            use qs_state = Qubit[3];
            q_qaa_state_reflection(qs_state);
            ResetAll(qs_state);
            return 1.0;
        }
    }

    operation test_qpe_phase_from_eigenvalue(p : Int) : Double {
        body {
            let phase = q_qpe_phase_from_eigenvalue(3.14159);
            return phase;
        }
    }

    operation test_qpe_bayesian_update(p : Int) : Double {
        body {
            let mean = q_qpe_bayesian_update(0.5, 0.1, 1, 0.8);
            return mean;
        }
    }

    operation test_qpe_precision(p : Int) : Double {
        body {
            let precision = q_qpe_precision(10, 0.01);
            return precision;
        }
    }

    operation test_qpe_validate_eigenvalues(p : Int) : Int {
        body {
            let eigenvalues = [0.5, 1.0, 0.8];
            return q_qpe_validate_eigenvalues(eigenvalues, 0.1) ? 1 | 0;
        }
    }

    operation test_qpe_iteration_schedule(p : Int) : Int {
        body {
            let schedule = q_qpe_iteration_schedule(4, 0);
            return Length(schedule);
        }
    }

    operation test_qpe_success_probability(p : Int) : Double {
        body {
            let prob = q_qpe_success_probability(0.9, 5);
            return prob;
        }
    }

    operation test_qpe_variance(p : Int) : Double {
        body {
            let variance = q_qpe_variance(10, 0.9);
            return variance;
        }
    }

    operation test_qpe_check_eigenstate(p : Int) : Int {
        body {
            let valid = q_qpe_check_eigenstate(0.95, 0.9) ? 1 | 0;
            return valid;
        }
    }

    operation test_qpe_optimal_bits(p : Int) : Int {
        body {
            let bits = q_qpe_optimal_bits(1e-6, 0.01);
            return bits;
        }
    }

    operation test_qge_parameter_shift(p : Int) : Double {
        body {
            let grad = q_qge_parameter_shift(1.0, 0.5);
            return grad;
        }
    }

    operation test_qge_shift_angle(p : Int) : Double {
        body {
            let angle = q_qge_shift_angle();
            return angle;
        }
    }

    operation test_qge_gradient_magnitude(p : Int) : Double {
        body {
            let grads = [1.0, 2.0, 3.0];
            return q_qge_gradient_magnitude(grads);
        }
    }

    operation test_qge_quantum_natural_gradient(p : Int) : Int {
        body {
            let grads = [1.0, 2.0, 3.0];
            let fisher = [1.0, 1.0, 1.0];
            let qng = q_qge_quantum_natural_gradient(grads, fisher);
            return Length(qng);
        }
    }

    operation test_qge_converged(p : Int) : Int {
        body {
            let grads = [0.001, 0.001, 0.001];
            return q_qge_converged(grads, 0.01) ? 1 | 0;
        }
    }

    operation test_qge_optimal_learning_rate(p : Int) : Double {
        body {
            let lr = q_qge_optimal_learning_rate(0.5, 2.0);
            return lr;
        }
    }

    operation test_qge_gradient_descent_step(p : Int) : Int {
        body {
            let pr = [1.0, 2.0, 3.0];
            let grads = [0.1, 0.1, 0.1];
            let new_pr = q_qge_gradient_descent_step(pr, grads, 0.1);
            return Length(new_pr);
        }
    }

    operation test_qge_hessian_estimate(p : Int) : Double {
        body {
            let hess = q_qge_hessian_estimate(1.0, 0.8, 0.8, 0.6);
            return hess;
        }
    }

    operation test_qge_valid_shift(p : Int) : Int {
        body {
            return q_qge_valid_shift(PI() / 4.0) ? 1 | 0;
        }
    }

    operation test_qge_gradient_variance(p : Int) : Double {
        body {
            let samples = [1.0, 1.1, 0.9, 1.05, 0.95];
            return q_qge_gradient_variance(samples, 5);
        }
    }

operation test_qge_adam_step(p : Int) : Int {
        body {
            let (m_new, v_new, upd) = q_qge_adam_step(0.1, 0.0, 0.0, 0.9, 0.999, 1);
            return 3;
        }
    }

    // ============================================================
    // Tests for Enhanced Block Encoding v2
    // ============================================================

    operation test_qrom_read(p : Int) : Int {
        body {
            let data = [1.0, 0.5, 0.25, 0.125];
            let n = 2;
            mutable result = 0;

            using (qs = Qubit[3]) {
                let qs_addr = qs[0 .. 1];
                let qs_data = qs[2];

                qrom_read(data, qs_addr, qs_data);

                let res = M(qs_data) == One ? 1 | 0;
                set result = res;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_qrom_read_multi(p : Int) : Int {
        body {
            let data = [1.0, 0.5, 0.25];
            mutable result = 0;

            using (qs = Qubit[4]) {
                let qs_addr = qs[0 .. 1];
                let qs_data = qs[2 .. 3];

                qrom_read_multi(data, qs_addr, qs_data);

                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_lcu_block_encode(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[3]) {
                let qs_sys = qs[0 .. 1];
                let qs_anc = qs[2];

                let alpha = 2.0;
                let coeffs = [1.0, 0.5];
                let k = Length(coeffs);

                if (k > 0) {
                    set result = 1;
                }

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_lcu_prepare_coeffs(p : Int) : Int {
        body {
            let coeffs = [1.0, 0.5, 0.25];
            let alpha = 1.75;
            mutable result = 0;

            using (qs = Qubit[4]) {
                let qs_addr = qs[0 .. 1];
                let qs_anc = qs[2];

                if (q_lcu_validate_coeffs(coeffs, false)) {
                    set result = 1;
                }

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_lcu_compute_alpha(p : Int) : Double {
        body {
            let coeffs = [1.0, 0.5, 0.25, 0.125];
            let alpha = q_lcu_compute_alpha(coeffs);
            return alpha;
        }
    }

    operation test_lcu_validate_coeffs(p : Int) : Int {
        body {
            let coeffs_valid = [0.3, 0.3, 0.4];
            let coeffs_invalid = [-0.1, 0.5, 0.6];

            let v1 = q_lcu_validate_coeffs(coeffs_valid, true);
            let v2 = q_lcu_validate_coeffs(coeffs_invalid, false);

            return (v1 and not v2) ? 1 | 0;
        }
    }

    operation test_oaa_optimal_iterations(p : Int) : Int {
        body {
            let alpha = 2.0;
            let target_prob = 0.9;
            let iters = q_oaa_optimal_iterations(alpha, target_prob);
            return iters > 0 ? 1 | 0;
        }
    }

    operation test_oaa_check_amplification(p : Int) : Int {
        body {
            let current = 0.95;
            let target = 0.9;
            let tol = 0.01;

            let done = q_oaa_check_amplification(current, target, tol);
            return done ? 1 | 0;
        }
    }

    operation test_qrom_compute_addr_bits(p : Int) : Int {
        body {
            let bits = qrom_compute_addr_bits(10);
            return bits >= 1 ? 1 | 0;
        }
    }

    operation test_qrom_validate_addr_space(p : Int) : Int {
        body {
            let valid = qrom_validate_addr_space(4, 15);
            return valid ? 1 | 0;
        }
    }

    operation test_q_be_frobenius_norm(p : Int) : Double {
        body {
            let matrix = [[1.0, 0.0], [0.0, 1.0]];
            let norm = q_be_frobenius_norm(matrix);
            return norm;
        }
    }

    operation test_q_be_validate_block_encode(p : Int) : Int {
        body {
            let matrix = [[0.5, 0.0], [0.0, 0.5]];
            let alpha = 1.0;

            let valid = q_be_validate_block_encode(matrix, alpha);
            return valid ? 1 | 0;
        }
    }

    operation test_q_lcu_scale_coeffs(p : Int) : Double {
        body {
            let coeffs = [1.0, 1.0, 1.0];
            let target = 1.5;
            let scaled = q_lcu_scale_coeffs(coeffs, target);

            let alpha = q_lcu_compute_alpha(scaled);
            return alpha;
        }
    }

    operation test_q_signal_rotation_angle(p : Int) : Double {
        body {
            let angle = q_signal_rotation_angle(0.5, 1.0);
            return angle;
        }
    }

    // ============================================================
    // Tests for VQE Components
    // ============================================================

    operation test_vqe_hea(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[4]) {
                let p_arr = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6];
                q_vqe_hea(4, p_arr, qs, 1);
                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_vqe_qaoa(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[4]) {
                let gamma = [0.1, 0.2];
                let beta = [0.15, 0.25];

                q_vqe_qaoa(gamma, beta, qs, 2);
                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_vqe_su2(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[4]) {
                let theta_arr = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6];
                q_vqe_su2(theta_arr, qs, 1);
                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_vqe_param_shift_plus(p : Int) : Double {
        body {
            let pp = [0.1, 0.2, 0.3];
            let shifted = q_vqe_param_shift_plus(pp, PI() / 4.0);
            return Length(shifted) == 3 ? shifted[0] | 0.0;
        }
    }

    operation test_vqe_param_shift_minus(p : Int) : Double {
        body {
            let pp = [0.1, 0.2, 0.3];
            let shifted = q_vqe_param_shift_minus(pp, PI() / 4.0);
            return Length(shifted) == 3 ? shifted[1] | 0.0;
        }
    }

    operation test_vqe_gradient_from_shifts(p : Int) : Double {
        body {
            let grad = q_vqe_gradient_from_shifts(0.8, 0.4);
            return grad;
        }
    }

    operation test_vqe_weighted_sum(p : Int) : Double {
        body {
            let weights = [0.5, 0.3, 0.2];
            let expectations = [1.0, 0.5, -0.5];

            let sum = q_vqe_weighted_sum(weights, expectations);
            return sum;
        }
    }

    operation test_vqe_valid_expectation(p : Int) : Int {
        body {
            let v1 = q_vqe_valid_expectation(0.5);
            let v2 = q_vqe_valid_expectation(1.5);

            return (v1 and not v2) ? 1 | 0;
        }
    }

    operation test_vqe_gradient_descent_step(p : Int) : Double {
        body {
            let pp = [0.5, 0.5, 0.5];
            let grad = [0.1, 0.1, 0.1];
            let lr = 0.1;

            let upd = q_vqe_gradient_descent_step(pp, grad, lr);
            return Length(upd) == 3 ? upd[0] | 0.0;
        }
    }

    operation test_vqe_adam_step(p : Int) : Int {
        body {
            let pp = [0.1, 0.1, 0.1];
            let grad = [0.01, 0.01, 0.01];
            let mm = [0.0, 0.0, 0.0];
            let vv = [0.0, 0.0, 0.0];

            let (new_pp, new_mm, new_vv) = q_vqe_adam_step(pp, grad, 0.001, 0.9, 0.999, 1e-8, 1, mm, vv);
            return Length(new_pp) == 3 ? 1 | 0;
        }
    }

    operation test_vqe_converged(p : Int) : Int {
        body {
            let gradient = [0.001, 0.001, 0.001];
            let tol = 0.01;

            let converged = q_vqe_converged(gradient, tol);
            return converged ? 1 | 0;
        }
    }

    operation test_vqe_energy_converged(p : Int) : Int {
        body {
            let e_old = -1.5;
            let e_new = -1.51;
            let tol = 0.02;

            let converged = q_vqe_energy_converged(e_old, e_new, tol);
            return converged ? 1 | 0;
        }
    }

    operation test_vqe_init_adam(p : Int) : Int {
        body {
            let (m, v) = q_vqe_init_adam(5);
            return Length(m) == 5 and Length(v) == 5 ? 1 | 0;
        }
    }

    operation test_vqe_ansatz_depth(p : Int) : Int {
        body {
            let depth = q_vqe_ansatz_depth(4, 3, true);
            return depth > 0 ? 1 | 0;
        }
    }

    operation test_vqe_count_params(p : Int) : Int {
        body {
            let n_hea = q_vqe_count_params(4, 2, "hea");
            let n_qaoa = q_vqe_count_params(4, 2, "qaoa");
            let n_su2 = q_vqe_count_params(4, 2, "su2");

            return n_hea > 0 and n_qaoa > 0 and n_su2 > 0 ? 1 | 0;
        }
    }

    operation test_vqe_parse_pauli_string(p : Int) : Int {
        body {
            let paulis = q_vqe_parse_pauli_string("XYZ");
            return Length(paulis) == 3 ? 1 | 0;
        }
    }

    operation test_vqe_term_weight(p : Int) : Double {
        body {
            let weight = q_vqe_term_weight("XYZ", -0.5);
            return weight;
        }
    }

    operation test_vqe_shift_angle(p : Int) : Double {
        body {
            let angle = q_vqe_shift_angle(PI() / 4.0);
            return angle;
        }
    }

    operation test_vqe_hessian_diag(p : Int) : Int {
        body {
            let pp = [0.1, 0.2, 0.3];
            let exp_p = [0.5, 0.6, 0.7];
            let exp_m = [0.3, 0.4, 0.5];
            let exp_z = [0.4, 0.5, 0.6];

            let hess = q_vqe_hessian_diag(pp, exp_p, exp_m, exp_z);
            return Length(hess) == 3 ? 1 | 0;
        }
    }

    operation test_vqe_gradient_variance(p : Int) : Double {
        body {
            let expectations = [0.5, 0.6, 0.4, 0.55];
            let var_est = q_vqe_gradient_variance(expectations, 100);
            return var_est;
        }
    }

    operation test_vqe_adaptive_lr(p : Int) : Double {
        body {
            let lr = q_vqe_adaptive_lr(0.1, 0.5, 0.4, 0.001, 1.0);
            return lr;
        }
    }

    operation test_vqe_shot_allocation(p : Int) : Int {
        body {
            let weights = [0.5, 0.3, 0.2];
            let shots = q_vqe_shot_allocation(weights, 100);

            mutable sum = 0;
            for (s in shots) {
                set sum = sum + s;
            }

            return sum > 0 ? 1 | 0;
        }
    }

    operation test_vqe_init_state(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[3]) {
                let vector = [0.5, 0.5, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0];
                q_vqe_init_state(vector, qs);
                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_vqe_validate_params(p : Int) : Int {
        body {
            let p_arr = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16];
            let valid = q_vqe_validate_params(p_arr, 4, 2, "hea");
            return valid ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for Quantum Kernel Methods
    // ============================================================

    operation test_kernel_feature_angles(p : Int) : Int {
        body {
            let features = [1.0, 2.0, 3.0];
            let angles = q_kernel_feature_angles(features, 3);
            return Length(angles) == 3 ? 1 | 0;
        }
    }

    operation test_kernel_apply_feature_map(p : Int) : Int {
        body {
            mutable result = 0;

            using (qs = Qubit[3]) {
                let features = [0.5, 0.5, 0.0];
                q_kernel_apply_feature_map(features, qs, 1);
                set result = 1;

                ResetAll(qs);
            }

            return result;
        }
    }

    operation test_kernel_matrix(p : Int) : Int {
        body {
            let features = [[1.0, 0.0], [0.0, 1.0]];
            let K = q_kernel_matrix(features);
            return Length(K) == 2 ? 1 | 0;
        }
    }

    operation test_kernel_dot(p : Int) : Double {
        body {
            let a = [1.0, 2.0, 3.0];
            let b = [0.5, 1.0, 1.5];
            return q_kernel_dot(a, b);
        }
    }

    operation test_kernel_validate(p : Int) : Int {
        body {
            let K = [[1.0, 0.0], [0.0, 1.0]];
            return q_kernel_validate(K) ? 1 | 0;
        }
    }

    operation test_kernel_gaussian(p : Int) : Double {
        body {
            let x = [0.0, 0.0];
            let y = [1.0, 0.0];
            let sigma = 1.0;
            return q_kernel_gaussian(x, y, sigma);
        }
    }

    operation test_kernel_polynomial(p : Int) : Double {
        body {
            let x = [1.0, 0.0];
            let y = [1.0, 0.0];
            return q_kernel_polynomial(x, y, 2, 0.0);
        }
    }

    operation test_kernel_normalize(p : Int) : Double {
        body {
            let features = [3.0, 4.0];
            let normalized = q_kernel_normalize(features);
            return Sqrt(SquaredNorm(normalized));
        }
    }

    // ============================================================
    // Tests for Error Mitigation
    // ============================================================

    operation test_zne_extrapolate(p : Int) : Double {
        body {
            let values = [0.9, 0.8, 0.7];
            let factors = [1.0, 2.0, 3.0];
            return q_zne_extrapolate(values, factors);
        }
    }

    operation test_zne_linear(p : Int) : Double {
        body {
            let values = [0.9, 0.85];
            return q_zne_linear(values);
        }
    }

    operation test_zne_noise_factors(p : Int) : Int {
        body {
            let factors = q_zne_noise_factors(0.01, [1, 2, 3]);
            return Length(factors) == 3 ? 1 | 0;
        }
    }

    operation test_zne_optimal_factors(p : Int) : Int {
        body {
            let factors = q_zne_optimal_factors(1.0, 3.0, 3);
            return Length(factors) == 3 ? 1 | 0;
        }
    }

    operation test_pec_coefficients(p : Int) : Int {
        body {
            let fidelities = [0.99, 0.98, 0.97];
            let coeffs = q_pec_coefficients(fidelities, 3);
            return Length(coeffs) == 3 ? 1 | 0;
        }
    }

    operation test_pec_validate(p : Int) : Int {
        body {
            let coeffs = [0.5, 0.3, 0.2];
            return q_pec_validate(coeffs) ? 1 | 0;
        }
    }

    operation test_pec_sampling_prob(p : Int) : Double {
        body {
            let coeffs = [0.5, -0.3, 0.2];
            return q_pec_sampling_prob(coeffs);
        }
    }

    operation test_dd_xy_sequence(p : Int) : Int {
        body {
            let seq = q_dd_xy_sequence(4, 0.1);
            return Length(seq) == 4 ? 1 | 0;
        }
    }

    operation test_dd_padding_interval(p : Int) : Double {
        body {
            return q_dd_padding_interval(1.0, 4);
        }
    }

    operation test_dd_validate_sequence(p : Int) : Int {
        body {
            let seq = ["X", "Y", "X", "Y"];
            return q_dd_validate_sequence(seq) ? 1 | 0;
        }
    }

    operation test_readout_calibration(p : Int) : Int {
        body {
            let probs = [[0.95, 0.05], [0.05, 0.95]];
            let inv = q_readout_calibration(probs);
            return Length(inv) == 2 ? 1 | 0;
        }
    }

    operation test_readout_correct(p : Int) : Int {
        body {
            let measured = [0.5, 0.5];
            let cal_inv = [[2.0, 0.0], [0.0, 2.0]];
            let corrected = q_readout_correct(measured, cal_inv);
            return Length(corrected) == 2 ? 1 | 0;
        }
    }

    operation test_dd_fidelity_improvement(p : Int) : Double {
        body {
            return q_dd_fidelity_improvement(10.0, 4, 0.1);
        }
    }

    operation test_zne_verify(p : Int) : Int {
        body {
            let values = [0.9, 0.8, 0.7];
            let factors = [1.0, 2.0, 3.0];
            return q_zne_verify(values, factors, 0.1) ? 1 | 0;
        }
    }

    operation test_pec_normalize(p : Int) : Double {
        body {
            let coeffs = [0.5, 0.3, 0.2];
            let normalized = q_pec_normalize(coeffs);
            return Length(normalized) == 3 ? normalized[0] | 0.0;
        }
    }

    operation test_dd_pulse_timing(p : Int) : Int {
        body {
            let times = q_dd_pulse_timing(1.0, 4);
            return Length(times) == 4 ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for LU Decomposition
    // ============================================================

    operation test_lu_is_square(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            return q_lu_is_square(A) ? 1 | 0;
        }
    }

    operation test_lu_diagonal_nonzero(p : Int) : Int {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            return q_lu_diagonal_nonzero(A, true) ? 1 | 0;
        }
    }

    operation test_lu_extract_l(p : Int) : Int {
        body {
            let LU = [[1.0, 2.0], [0.5, 3.0]];
            let L = q_lu_extract_l(LU, 2);
            return Length(L) == 2 ? 1 | 0;
        }
    }

    operation test_lu_extract_u(p : Int) : Int {
        body {
            let LU = [[1.0, 2.0], [0.5, 3.0]];
            let U = q_lu_extract_u(LU, 2);
            return Length(U[0]) == 2 ? 1 | 0;
        }
    }

    operation test_lu_check_dims(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            return q_lu_check_dims(A, 2) ? 1 | 0;
        }
    }

    operation test_lu_pivot_indices(p : Int) : Int {
        body {
            let pivots = q_lu_pivot_indices([[1.0, 0.0], [0.0, 1.0]], 2);
            return Length(pivots) == 2 ? 1 | 0;
        }
    }

    operation test_lu_solve(p : Int) : Int {
        body {
            let L = [[1.0, 0.0], [0.5, 1.0]];
            let U = [[1.0, 2.0], [0.0, 3.0]];
            let pivots = [0, 1];
            let b = [1.0, 1.0];
            let x = q_lu_solve(L, U, pivots, b);
            return Length(x) == 2 ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for QR Decomposition
    // ============================================================

    operation test_qr_check_dims(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]];
            return q_qr_check_dims(A) ? 1 | 0;
        }
    }

    operation test_qr_column_norms(p : Int) : Int {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            let norms = q_qr_column_norms(A);
            return Length(norms) == 2 ? 1 | 0;
        }
    }

    operation test_qr_extract_r(p : Int) : Int {
        body {
            let Rfull = [[1.0, 2.0], [0.0, 3.0], [0.0, 0.0]];
            let Rmat = q_qr_extract_r(Rfull, 2);
            return Length(Rmat) == 2 and Length(Rmat[0]) == 2 ? 1 | 0;
        }
    }

    operation test_qr_check_orthogonal(p : Int) : Int {
        body {
            let Q = [[1.0, 0.0], [0.0, 1.0]];
            return q_qr_check_orthogonal(Q, 1e-6) ? 1 | 0;
        }
    }

    operation test_qr_rank_estimate(p : Int) : Int {
        body {
            let Rmat = [[2.0, 0.0], [0.0, 1.0]];
            let rank = q_qr_rank_estimate(Rmat, 1e-6);
            return rank == 2 ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for Cholesky Decomposition
    // ============================================================

    operation test_chol_is_symmetric(p : Int) : Int {
        body {
            let A = [[2.0, 1.0], [1.0, 2.0]];
            return q_chol_is_symmetric(A, 1e-6) ? 1 | 0;
        }
    }

    operation test_chol_matrix_norm(p : Int) : Double {
        body {
            let A = [[3.0, 1.0], [1.0, 3.0]];
            return q_chol_matrix_norm(A);
        }
    }

    operation test_chol_check_positive_diagonal(p : Int) : Int {
        body {
            let L = [[1.0, 0.0], [0.5, 1.0]];
            return q_chol_check_positive_diagonal(L, 1e-10) ? 1 | 0;
        }
    }

    operation test_chol_ldlt(p : Int) : Int {
        body {
            let A = [[4.0, 2.0], [2.0, 5.0]];
            let (L, D) = q_chol_ldlt(A);
            return Length(L) == 2 and Length(D) == 2 ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for Matrix Addition
    // ============================================================

    operation test_add_check_dims(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = [[5.0, 6.0], [7.0, 8.0]];
            return q_add_check_dims(A, B) ? 1 | 0;
        }
    }

    operation test_add_matrix_add(p : Int) : Double {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = [[1.0, 1.0], [1.0, 1.0]];
            let C = q_add_matrix_add(A, B);
            return C[0][0];
        }
    }

    operation test_add_matrix_subtract(p : Int) : Double {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = [[1.0, 1.0], [1.0, 1.0]];
            let C = q_add_matrix_subtract(A, B);
            return C[1][1];
        }
    }

    operation test_add_scalar_mult(p : Int) : Double {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = q_add_scalar_mult(A, 2.0);
            return B[0][0];
        }
    }

    operation test_add_negate(p : Int) : Double {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = q_add_negate(A);
            return B[0][0] + B[1][1];
        }
    }

    operation test_add_linear_combo(p : Int) : Double {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            let B = [[1.0, 0.0], [0.0, 1.0]];
            let C = q_add_linear_combo(A, B, 2.0, 3.0);
            return C[0][0];
        }
    }

    operation test_add_hadamard(p : Int) : Double {
        body {
            let A = [[2.0, 3.0], [4.0, 5.0]];
            let B = [[1.0, 2.0], [3.0, 4.0]];
            let C = q_add_hadamard(A, B);
            return C[0][0];
        }
    }

    // ============================================================
    // Tests for Vector Norm
    // ============================================================

    operation test_vnorm_l2(p : Int) : Double {
        body {
            let v = [3.0, 4.0];
            return q_vnorm_l2(v);
        }
    }

    operation test_vnorm_l1(p : Int) : Double {
        body {
            let v = [1.0, -2.0, 3.0];
            return q_vnorm_l1(v);
        }
    }

    operation test_vnorm_linf(p : Int) : Double {
        body {
            let v = [1.0, -5.0, 3.0];
            return q_vnorm_linf(v);
        }
    }

    operation test_vnorm_ratio(p : Int) : Double {
        body {
            let v = [1.0, 0.0];
            let w = [2.0, 0.0];
            return q_vnorm_ratio(v, w);
        }
    }

    operation test_vnorm_normalize(p : Int) : Double {
        body {
            let v = [3.0, 4.0];
            let n = q_vnorm_normalize(v, false);
            return q_vnorm_l2(n);
        }
    }

    operation test_vnorm_is_unit(p : Int) : Int {
        body {
            let v = [1.0, 0.0];
            return q_vnorm_is_unit(v, 1e-6) ? 1 | 0;
        }
    }

    operation test_vnorm_distance(p : Int) : Double {
        body {
            let v = [1.0, 0.0];
            let w = [0.0, 1.0];
            return q_vnorm_distance(v, w);
        }
    }

    // ============================================================
    // Tests for Inner Product
    // ============================================================

    operation test_ip_dot(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            let w = [1.0, 1.0, 1.0];
            return q_ip_dot(v, w);
        }
    }

    operation test_ip_fidelity(p : Int) : Double {
        body {
            let v = [1.0, 0.0];
            let w = [1.0, 0.0];
            return q_ip_fidelity(v, w);
        }
    }

    operation test_ip_normalize(p : Int) : Double {
        body {
            let v = [2.0, 0.0];
            let w = [2.0, 0.0];
            return q_ip_normalize(v, w, 4.0);
        }
    }

    operation test_ip_angle(p : Int) : Double {
        body {
            let v = [1.0, 0.0];
            let w = [1.0, 0.0];
            return q_ip_angle(v, w);
        }
    }

    operation test_ip_is_orthogonal(p : Int) : Int {
        body {
            let v = [1.0, 0.0];
            let w = [0.0, 1.0];
            return q_ip_is_orthogonal(v, w, 1e-6) ? 1 | 0;
        }
    }

    // ============================================================
    // Tests for Kronecker/Tensor Product
    // ============================================================

    operation test_tk_check_dims(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = [[5.0, 6.0], [7.0, 8.0]];
            return q_tk_check_dims(A, B) ? 1 | 0;
        }
    }

    operation test_tk_kronecker(p : Int) : Int {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            let B = [[2.0, 0.0], [0.0, 2.0]];
            let C = q_tk_kronecker(A, B);
            return Length(C) == 4 and Length(C[0]) == 4 ? 1 | 0;
        }
    }

    operation test_tk_vector_kronecker(p : Int) : Int {
        body {
            let v = [1.0, 2.0];
            let w = [3.0, 4.0];
            let r = q_tk_vector_kronecker(v, w);
            return Length(r) == 4 ? 1 | 0;
        }
    }

    operation test_tk_identity(p : Int) : Double {
        body {
            let Idmat = q_tk_identity(3);
            return Idmat[0][0] + Idmat[1][1] + Idmat[2][2];
        }
    }

    operation test_tk_hadamard(p : Int) : Double {
        body {
            let A = [[2.0, 3.0], [4.0, 5.0]];
            let B = [[1.0, 2.0], [3.0, 4.0]];
            let C = q_tk_hadamard(A, B);
            return C[0][0];
        }
    }

    operation test_tk_verify(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0]];
            let B = [[5.0, 6.0], [7.0, 8.0]];
            return q_tk_verify(A, B) ? 1 | 0;
        }
    }

    // ============================================================
    // Qubitization Tests
    // ============================================================

    operation test_qubitization_phases(p : Int) : Double {
        body {
            let phases = q_qubitization_prepare_phases(1.0, 1.0, 0.01);
            return IntAsDouble(Length(phases));
        }
    }

    operation test_qubitization_query_complexity(p : Int) : Int {
        body {
            let q = q_qubitization_query_complexity(2, 1.0, 1.0, 0.01);
            return q > 0 ? q | 0;
        }
    }

    operation test_qubitization_chebyshev(p : Int) : Double {
        body {
            let val = q_qubitization_chebyshev_value(3, 0.5);
            return val;
        }
    }

    operation test_qubitization_compute_phases(p : Int) : Double {
        body {
            let phases = q_qubitization_compute_phases(1.0, 1.0, 5);
            return IntAsDouble(Length(phases));
        }
    }

    operation test_qubitization_accuracy(p : Int) : Double {
        body {
            let err = q_qubitization_verify_accuracy(0.9, 1.0, 1.0);
            return err;
        }
    }

    operation test_qubitization_spectral_gap(p : Int) : Double {
        body {
            let Hmat = [[1.0, 0.0], [0.0, 2.0]];
            let gap = q_qubitization_spectral_gap(Hmat);
            return gap;
        }
    }

    operation test_qubitization_timestep(p : Int) : Double {
        body {
            let dt = q_qubitization_compute_timestep(2.0, 4);
            return dt;
        }
    }

    operation test_qubitization_qsp_phases(p : Int) : Double {
        body {
            let q_phases = q_qubitization_compute_phases(1.0, 1.0, 3);
            let qsp = q_qubitization_to_qsp_phases(q_phases);
            return IntAsDouble(Length(qsp));
        }
    }

    operation test_qubitization_estimate_queries(p : Int) : Int {
        body {
            let q = q_qubitization_estimate_queries(2, 1.0, 1.0, 0.01);
            return q > 0 ? q | 0;
        }
    }

    // ============================================================
    // LCU Optimized Tests
    // ============================================================

    operation test_lcu_ancilla_bits(p : Int) : Int {
        body {
            let bits = q_lcu_single_ancilla_bits(8);
            return bits == 3 ? 1 | 0;
        }
    }

    operation test_lcu_gate_count(p : Int) : Int {
        body {
            let gc = q_lcu_gate_count(4, 3);
            return gc > 0 ? gc | 0;
        }
    }

    operation test_lcu_coefficient_norm(p : Int) : Double {
        body {
            let norm = q_lcu_coefficient_norm([1.0, 2.0, 3.0]);
            return norm;
        }
    }

    operation test_lcu_check_coeffs(p : Int) : Int {
        body {
            let ok = q_lcu_check_coefficients([1.0, 2.0, 3.0]);
            return ok ? 1 | 0;
        }
    }

    operation test_lcu_amplitudes(p : Int) : Double {
        body {
            let (amps, alpha) = q_lcu_compute_amplitudes([1.0, 2.0]);
            return alpha;
        }
    }

    operation test_lcu_success_prob(p : Int) : Double {
        body {
            let prob = q_lcu_success_probability([1.0, 1.0]);
            return prob;
        }
    }

    operation test_lcu_is_power_of_two(p : Int) : Int {
        body {
            let ok = q_lcu_is_power_of_two(8);
            return ok ? 1 | 0;
        }
    }

    operation test_lcu_pad_coeffs(p : Int) : Int {
        body {
            let padded = q_lcu_pad_coefficients([1.0, 2.0, 3.0]);
            return Length(padded);
        }
    }

    operation test_lcu_query_complexity(p : Int) : Int {
        body {
            let q = q_lcu_query_complexity(4, 2.0, 1.0, 0.01);
            return q > 0 ? q | 0;
        }
    }

    operation test_lcu_csd_angles(p : Int) : Double {
        body {
            let angles = q_lcu_csd_angles(4);
            return IntAsDouble(Length(angles));
        }
    }

    // ============================================================
    // Gibbs Tests
    // ============================================================

    operation test_gibbs_compute_beta(p : Int) : Double {
        body {
            let beta = q_gibbs_compute_beta(1.0, 0.5);
            return beta;
        }
    }

    operation test_gibbs_partition_bound(p : Int) : Double {
        body {
            let bound = q_gibbs_partition_bound([1.0, 2.0, 3.0], 0.5);
            return bound;
        }
    }

    operation test_gibbs_spectral_gap(p : Int) : Double {
        body {
            let Hmat = [[1.0, 0.0], [0.0, 2.0]];
            let gap = q_gibbs_spectral_gap(Hmat);
            return gap;
        }
    }

    operation test_gibbs_verify_state(p : Int) : Double {
        body {
            let dist = q_gibbs_verify_state([0.5, 0.5], [0.6, 0.4]);
            return dist;
        }
    }

    operation test_gibbs_free_energy(p : Int) : Double {
        body {
            let F = q_gibbs_free_energy(2.0, 300.0);
            return F;
        }
    }

    operation test_gibbs_estimate_temp(p : Int) : Double {
        body {
            let TempVal = q_gibbs_estimate_temperature(1.0, 1.5);
            return TempVal;
        }
    }

    operation test_gibbs_partition_function(p : Int) : Double {
        body {
            let z = q_gibbs_partition_function([1.0, 2.0], 0.5);
            return z;
        }
    }

    operation test_gibbs_probabilities(p : Int) : Int {
        body {
            let probs = q_gibbs_probabilities([1.0, 2.0], 0.5);
            return Length(probs);
        }
    }

    operation test_gibbs_valid_temp(p : Int) : Int {
        body {
            let ok = q_gibbs_is_valid_temperature(300.0);
            return ok ? 1 | 0;
        }
    }

    operation test_gibbs_complexity(p : Int) : Int {
        body {
            let c = q_gibbs_complexity(0.1, 1.0, 0.01);
            return c > 0 ? c | 0;
        }
    }

    // ============================================================
    // Time-Dependent Hamiltonian Tests
    // ============================================================

    operation test_timedep_discretize_steps(p : Int) : Int {
        body {
            let steps = q_timedep_discretize_steps(1.0, 1.0, 0.01);
            return steps > 0 ? steps | 0;
        }
    }

    operation test_timedep_step_size(p : Int) : Double {
        body {
            let dt = q_timedep_step_size(2.0, 4);
            return dt;
        }
    }

    operation test_timedep_evaluate(p : Int) : Int {
        body {
            let H0mat = [[1.0, 0.0], [0.0, 1.0]];
            let H1mat = [[0.0, 1.0], [1.0, 0.0]];
            let Ht = q_timedep_evaluate(0.5, H0mat, H1mat);
            return Length(Ht);
        }
    }

    operation test_timedep_error_bound(p : Int) : Double {
        body {
            let err = q_timedep_error_bound(1.0, 4);
            return err;
        }
    }

    operation test_timedep_norm_variation(p : Int) : Double {
        body {
            let Hs = [[[1.0, 0.0], [0.0, 1.0]], [[2.0, 0.0], [0.0, 2.0]]];
            let var = q_timedep_norm_variation(Hs);
            return var;
        }
    }

    operation test_timedep_verify_evolution(p : Int) : Int {
        body {
            let ok = q_timedep_verify_evolution(0.0, 1.0, 0.5);
            return ok ? 1 | 0;
        }
    }

    operation test_timedep_optimal_order(p : Int) : Int {
        body {
            let order = q_timedep_optimal_order(1e-6, 1.0);
            return order;
        }
    }

    operation test_timedep_query_count(p : Int) : Int {
        body {
            let q = q_timedep_query_count(10, 2, 1.0, 0.01);
            return q > 0 ? q | 0;
        }
    }
}
