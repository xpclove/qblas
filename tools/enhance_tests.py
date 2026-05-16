#!/usr/bin/env python3
"""Add Fact() result validation to Q# tests using captured baseline values."""

import re
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEST_FILE = os.path.join(REPO, 'src', 'qblas', 'test', 'test_new_modules.qs')

# Expected values from a passing test run
# "test_name": (type, value, tolerance)
E = {
    "test_cg_converged": ("Int", 0, 0),
    "test_cg_compute_beta": ("Dbl", 0.25, 1e-10),
    "test_cg_compute_alpha": ("Dbl", 0.25, 1e-10),
    "test_lanczos_norm": ("Dbl", 3.7416573867739413, 1e-10),
    "test_lanczos_normalize": ("Dbl", 3.0, 1e-10),
    "test_lanczos_alpha_compute": ("Dbl", 4.666666666666667, 1e-10),
    "test_lanczos_beta_compute": ("Dbl", 5.0, 1e-10),
    "test_lanczos_tridiag": ("Int", 3, 0),
    "test_lanczos_eigenvalue_sum": ("Dbl", 6.0, 1e-10),
    "test_lanczos_apply_matrix": ("Int", 1, 0),
    "test_lanczos_estimate_alpha": ("Dbl", 1.0, 1e-10),
    "test_lanczos_iterate": ("Dbl", 1.0, 1e-10),
    "test_lanczos_step": ("Int", 1, 0),
    "test_lanczos_compute_tridiag": ("Int", 2, 0),
    "test_krylov_swap_test_one_shot": ("Int", 1, 0),
    "test_krylov_estimate_overlap": ("Dbl", 1.0, 1e-10),
    "test_krylov_apply_matrix": ("Int", 1, 0),
    "test_krylov_generate_subspace": ("Int", 1, 0),
    "test_krylov_swap_overlap": ("Dbl", 1.0, 1e-10),
    "test_krylov_gram_matrix": ("Dbl", 1.0, 1e-10),
    "test_krylov_arnoldi_overlaps": ("Int", 1, 0),
    "test_krylov_converged": ("Int", 0, 0),
    "test_krylov_norm_sq": ("Dbl", 14.0, 1e-10),
    "test_krylov_inner_product": ("Dbl", 7.0, 1e-10),
    "test_gmres_converged": ("Int", 0, 0),
    "test_gmres_hessenberg_size": ("Int", 6, 0),
    "test_gd_norm": ("Dbl", 3.7416573867739413, 1e-10),
    "test_gd_converged": ("Int", 1, 0),
    "test_gd_norm_sq": ("Dbl", 14.0, 1e-10),
    "test_newton_norm": ("Dbl", 3.7416573867739413, 1e-10),
    "test_newton_converged": ("Int", 1, 0),
    "test_pca_eigenvalue_norm": ("Dbl", 6.0, 1e-10),
    "test_pca_explained_var": ("Int", 3, 0),
    "test_pca_projection_matrix": ("Int", 3, 0),
    "test_ridge_effective_cond": ("Dbl", 3.015113445777636, 1e-10),
    "test_ridge_lambda_opt": ("Dbl", 0.01, 1e-10),
    "test_ridge_matrix_dim": ("Int", 3, 0),
    "test_trisol_is_triangular": ("Int", 1, 0),
    "test_trisol_diagonal_nonzero": ("Int", 1, 0),
    "test_qsp_is_valid_phase": ("Int", 0, 0),
    "test_qsp_poly_eval": ("Dbl", 2.25, 1e-10),
    "test_qsp_phase_from_degree": ("Dbl", 0.5235987755982988, 1e-10),
    "test_qsp_symmetric_phase_seq": ("Int", 7, 0),
    "test_qsp_apply_rotation": ("Dbl", 1.0, 1e-10),
    "test_qsp_polynomial_unitary": ("Dbl", 1.0, 1e-10),
    "test_qsp_eigenvalue_transform": ("Dbl", 1.0, 1e-10),
    "test_qsp_chebyshev_phase": ("Int", 6, 0),
    "test_qsp_kernel": ("Dbl", 1.0, 1e-10),
    "test_qsp_validate_sequence": ("Int", 1, 0),
    "test_qsp_linear_combination": ("Dbl", 1.0, 1e-10),
    "test_trotter_step_size": ("Dbl", 0.6283185307179586, 1e-10),
    "test_trotter_suzuki_2_coeffs": ("Int", 3, 0),
    "test_trotter_suzuki_high_order_coeffs": ("Int", 9, 0),
    "test_trotter_optimal_steps": ("Int", 15, 0),
    "test_trotter_first_order": ("Dbl", 1.0, 1e-10),
    "test_trotter_suzuki_2nd_order": ("Dbl", 1.0, 1e-10),
    "test_trotter_C_first_order": ("Dbl", 1.0, 1e-10),
    "test_trotter_is_valid_order": ("Int", 110, 0),
    "test_trotter_error_bound": ("Dbl", 9.992974456102976, 1e-10),
    "test_trotter_decomposition_length": ("Int", 45, 0),
    "test_trotter_verify_hamiltonian": ("Int", 1, 0),
    "test_trotter_check_ancilla": ("Int", 1, 0),
    "test_2sparse_is_2sparse": ("Int", 1, 0),
    "test_2sparse_check_row_sparsity": ("Int", 1, 0),
    "test_2sparse_row_norm": ("Dbl", 1.118033988749895, 1e-10),
    "test_2sparse_find_nonzero": ("Int", 2, 0),
    "test_2sparse_combined_norm": ("Dbl", 3.0, 1e-10),
    "test_2sparse_walk_simulation": ("Dbl", 1.0, 1e-10),
    "test_2sparse_C_walk_simulation": ("Dbl", 1.0, 1e-10),
    "test_2sparse_stride_bits": ("Int", 3, 0),
    "test_2sparse_estimate_norm": ("Dbl", 8.0, 1e-10),
    "test_2sparse_verify_decomposition": ("Int", 1, 0),
    "test_2sparse_optimal_steps": ("Int", 14, 0),
    "test_2sparse_check_ancilla": ("Int", 1, 0),
    "test_2sparse_eigenvalue_bound": ("Dbl", 4.0, 1e-10),
    "test_qaa_optimal_iterations": ("Int", 1, 0),
    "test_qaa_speedup": ("Dbl", 2.0, 1e-10),
    "test_qaa_valid_iterations": ("Int", 0, 0),
    "test_qaa_schedule": ("Int", 4, 0),
    "test_qaa_state_reflection": ("Dbl", 1.0, 1e-10),
    "test_qpe_phase_from_eigenvalue": ("Dbl", 0.49999957766806746, 1e-10),
    "test_qpe_bayesian_update": ("Dbl", 0.625, 1e-10),
    "test_qpe_precision": ("Dbl", 0.19090909090909092, 1e-10),
    "test_qpe_validate_eigenvalues": ("Int", 1, 0),
    "test_qpe_iteration_schedule": ("Int", 4, 0),
    "test_qpe_success_probability": ("Dbl", 0.8628430416666668, 1e-10),
    "test_qpe_variance": ("Dbl", 0.09068870523415976, 1e-10),
    "test_qpe_check_eigenstate": ("Int", 1, 0),
    "test_qpe_optimal_bits": ("Int", 26, 0),
    "test_qge_parameter_shift": ("Dbl", 0.25, 1e-10),
    "test_qge_shift_angle": ("Dbl", 1.5707963267948966, 1e-10),
    "test_qge_gradient_magnitude": ("Dbl", 3.7416573867739413, 1e-10),
    "test_qge_quantum_natural_gradient": ("Int", 3, 0),
    "test_qge_converged": ("Int", 1, 0),
    "test_qge_optimal_learning_rate": ("Dbl", 0.25, 1e-10),
    "test_qge_gradient_descent_step": ("Int", 3, 0),
    "test_qge_hessian_estimate": ("Dbl", -2.7755575615628914e-17, 1e-10),
    "test_qge_valid_shift": ("Int", 1, 0),
    "test_qge_gradient_variance": ("Dbl", 0.005, 1e-10),
    "test_qge_adam_step": ("Int", 3, 0),
    "test_qrom_read": ("Int", 0, 0),
    "test_qrom_read_multi": ("Int", 1, 0),
    "test_qrom_compute_addr_bits": ("Int", 1, 0),
    "test_qrom_validate_addr_space": ("Int", 1, 0),
    "test_lcu_block_encode": ("Int", 1, 0),
    "test_lcu_prepare_coeffs": ("Int", 1, 0),
    "test_lcu_compute_alpha": ("Dbl", 1.875, 1e-10),
    "test_lcu_validate_coeffs": ("Int", 1, 0),
    "test_lcu_scale_coeffs": ("Dbl", 1.5, 1e-10),
    "test_lcu_ancilla_bits": ("Int", 0, 0),
    "test_lcu_gate_count": ("Int", 51, 0),
    "test_lcu_coefficient_norm": ("Dbl", 6.0, 1e-10),
    "test_lcu_check_coeffs": ("Int", 1, 0),
    "test_lcu_amplitudes": ("Dbl", 3.0, 1e-10),
    "test_lcu_success_prob": ("Dbl", 0.25, 1e-10),
    "test_lcu_is_power_of_two": ("Int", 0, 0),
    "test_lcu_pad_coeffs": ("Int", 4, 0),
    "test_lcu_query_complexity": ("Int", 7, 0),
    "test_lcu_csd_angles": ("Dbl", 8.0, 1e-10),
    "test_oaa_optimal_iterations": ("Int", 1, 0),
    "test_oaa_check_amplification": ("Int", 1, 0),
    "test_q_signal_rotation_angle": ("Dbl", 1.0471975511965979, 1e-10),
    "test_vqe_hea": ("Int", 1, 0),
    "test_vqe_qaoa": ("Int", 1, 0),
    "test_vqe_su2": ("Int", 1, 0),
    "test_vqe_param_shift_plus": ("Dbl", 0.8853981633974483, 1e-10),
    "test_vqe_param_shift_minus": ("Dbl", -0.5853981633974483, 1e-10),
    "test_vqe_gradient_from_shifts": ("Dbl", 0.2, 1e-10),
    "test_vqe_weighted_sum": ("Dbl", 0.55, 1e-10),
    "test_vqe_valid_expectation": ("Int", 1, 0),
    "test_vqe_gradient_descent_step": ("Dbl", 0.49, 1e-10),
    "test_vqe_adam_step": ("Int", 1, 0),
    "test_vqe_converged": ("Int", 1, 0),
    "test_vqe_energy_converged": ("Int", 1, 0),
    "test_vqe_init_adam": ("Int", 1, 0),
    "test_vqe_ansatz_depth": ("Int", 1, 0),
    "test_vqe_count_params": ("Int", 1, 0),
    "test_vqe_parse_pauli_string": ("Int", 0, 0),
    "test_vqe_term_weight": ("Dbl", 0.5, 1e-10),
    "test_vqe_shift_angle": ("Dbl", 1.5707963267948966, 1e-10),
    "test_vqe_hessian_diag": ("Int", 1, 0),
    "test_vqe_gradient_variance": ("Dbl", 5.4687500000000225e-05, 1e-10),
    "test_vqe_adaptive_lr": ("Dbl", 0.125, 1e-10),
    "test_vqe_shot_allocation": ("Int", 1, 0),
    "test_vqe_init_state": ("Int", 1, 0),
    "test_vqe_validate_params": ("Int", 1, 0),
    "test_kernel_feature_angles": ("Int", 1, 0),
    "test_kernel_apply_feature_map": ("Int", 1, 0),
    "test_kernel_matrix": ("Int", 1, 0),
    "test_kernel_dot": ("Dbl", 7.0, 1e-10),
    "test_kernel_validate": ("Int", 1, 0),
    "test_kernel_gaussian": ("Dbl", 0.6065306597126334, 1e-10),
    "test_kernel_polynomial": ("Dbl", 1.0, 1e-10),
    "test_kernel_normalize": ("Dbl", 1.0, 1e-10),
    "test_zne_extrapolate": ("Dbl", 0.9, 1e-10),
    "test_zne_linear": ("Dbl", 0.95, 1e-10),
    "test_zne_noise_factors": ("Int", 1, 0),
    "test_zne_optimal_factors": ("Int", 1, 0),
    "test_zne_verify": ("Int", 1, 0),
    "test_pec_coefficients": ("Int", 1, 0),
    "test_pec_validate": ("Int", 1, 0),
    "test_pec_sampling_prob": ("Dbl", 1.0, 1e-10),
    "test_pec_normalize": ("Dbl", 0.5, 1e-10),
    "test_dd_xy_sequence": ("Int", 1, 0),
    "test_dd_padding_interval": ("Dbl", 0.2, 1e-10),
    "test_dd_validate_sequence": ("Int", 1, 0),
    "test_dd_fidelity_improvement": ("Dbl", 1.050220350740028, 1e-10),
    "test_dd_pulse_timing": ("Int", 1, 0),
    "test_readout_calibration": ("Int", 1, 0),
    "test_readout_correct": ("Int", 1, 0),
    "test_lu_is_square": ("Int", 1, 0),
    "test_lu_diagonal_nonzero": ("Int", 1, 0),
    "test_lu_extract_l": ("Int", 1, 0),
    "test_lu_extract_u": ("Int", 1, 0),
    "test_lu_check_dims": ("Int", 1, 0),
    "test_lu_pivot_indices": ("Int", 1, 0),
    "test_lu_solve": ("Int", 1, 0),
    "test_qr_check_dims": ("Int", 1, 0),
    "test_qr_column_norms": ("Int", 1, 0),
    "test_qr_extract_r": ("Int", 1, 0),
    "test_qr_check_orthogonal": ("Int", 1, 0),
    "test_qr_rank_estimate": ("Int", 1, 0),
    "test_chol_is_symmetric": ("Int", 1, 0),
    "test_chol_matrix_norm": ("Dbl", 4.47213595499958, 1e-10),
    "test_chol_check_positive_diagonal": ("Int", 1, 0),
    "test_chol_ldlt": ("Int", 1, 0),
    "test_add_check_dims": ("Int", 1, 0),
    "test_add_matrix_add": ("Dbl", 2.0, 1e-10),
    "test_add_matrix_subtract": ("Dbl", 3.0, 1e-10),
    "test_add_scalar_mult": ("Dbl", 2.0, 1e-10),
    "test_add_negate": ("Dbl", -5.0, 1e-10),
    "test_add_linear_combo": ("Dbl", 5.0, 1e-10),
    "test_add_hadamard": ("Dbl", 2.0, 1e-10),
    "test_vnorm_l2": ("Dbl", 5.0, 1e-10),
    "test_vnorm_l1": ("Dbl", 6.0, 1e-10),
    "test_vnorm_linf": ("Dbl", 5.0, 1e-10),
    "test_vnorm_ratio": ("Dbl", 0.5, 1e-10),
    "test_vnorm_normalize": ("Dbl", 1.0, 1e-10),
    "test_vnorm_is_unit": ("Int", 1, 0),
    "test_vnorm_distance": ("Dbl", 1.4142135623730951, 1e-10),
    "test_ip_dot": ("Dbl", 6.0, 1e-10),
    "test_ip_fidelity": ("Dbl", 1.0, 1e-10),
    "test_ip_normalize": ("Dbl", 1.0, 1e-10),
    "test_ip_angle": ("Dbl", 0.0, 1e-10),
    "test_ip_is_orthogonal": ("Int", 1, 0),
    "test_tk_check_dims": ("Int", 1, 0),
    "test_tk_kronecker": ("Int", 1, 0),
    "test_tk_vector_kronecker": ("Int", 1, 0),
    "test_tk_identity": ("Dbl", 3.0, 1e-10),
    "test_tk_hadamard": ("Dbl", 2.0, 1e-10),
    "test_tk_verify": ("Int", 1, 0),
    "test_qubitization_phases": ("Dbl", 10.0, 1e-10),
    "test_qubitization_query_complexity": ("Int", 6, 0),
    "test_qubitization_chebyshev": ("Dbl", -1.0, 1e-10),
    "test_qubitization_compute_phases": ("Dbl", 5.0, 1e-10),
    "test_qubitization_accuracy": ("Dbl", 0.09999999999999998, 1e-10),
    "test_qubitization_spectral_gap": ("Dbl", 2.0, 1e-10),
    "test_qubitization_timestep": ("Dbl", 0.5, 1e-10),
    "test_qubitization_qsp_phases": ("Dbl", 3.0, 1e-10),
    "test_qubitization_estimate_queries": ("Int", 5, 0),
    "test_gibbs_compute_beta": ("Dbl", 2.0, 1e-10),
    "test_gibbs_partition_bound": ("Dbl", 1.5, 1e-10),
    "test_gibbs_spectral_gap": ("Dbl", 1.0, 1e-10),
    "test_gibbs_verify_state": ("Dbl", 0.09999999999999998, 1e-10),
    "test_gibbs_free_energy": ("Dbl", -2.870978885078724e-21, 1e-10),
    "test_gibbs_estimate_temp": ("Dbl", 2.0, 1e-10),
    "test_gibbs_partition_function": ("Dbl", 1.0, 1e-10),
    "test_gibbs_probabilities": ("Int", 2, 0),
    "test_gibbs_valid_temp": ("Int", 1, 0),
    "test_gibbs_complexity": ("Int", 0, 0),
    "test_timedep_discretize_steps": ("Int", 5, 0),
    "test_timedep_step_size": ("Dbl", 0.5, 1e-10),
    "test_timedep_evaluate": ("Int", 2, 0),
    "test_timedep_error_bound": ("Dbl", 0.03125, 1e-10),
    "test_timedep_norm_variation": ("Dbl", 2.0, 1e-10),
    "test_timedep_verify_evolution": ("Int", 1, 0),
    "test_timedep_optimal_order": ("Int", 1, 0),
    "test_timedep_query_count": ("Int", 90, 0),
    "test_q_be_check_sparsity": ("Int", 1, 0),
    "test_q_be_diagonal": ("Int", 1, 0),
    "test_q_be_frobenius_norm": ("Dbl", 1.4142135623730951, 1e-10),
    "test_q_be_validate_block_encode": ("Int", 1, 0),
    "test_q_be_householder": ("Int", 1, 0),
    "test_q_be_compute_scaling": ("Dbl", 1.118033988749895, 1e-10),
    "test_q_be_tridiagonal": ("Int", 1, 0),
    "test_gemm_check_dims": ("Int", 4, 0),
    "test_chebyshev_polynomials": ("Dbl", 4.0, 1e-10),
    "test_chebyshev_coefficients": ("Dbl", 5.0, 1e-10),
    "test_chebyshev_map": ("Dbl", 0.5, 1e-10),
    "test_chebyshev_error_bound": ("Dbl", 0.1875, 1e-10),
    "test_chebyshev_select_degree": ("Int", 1, 0),
    "test_eigenvalue_filter_lowpass": ("Int", 1, 0),
    "test_eigenvalue_filter_highpass": ("Int", 1, 0),
    "test_eigenvalue_filter_bandpass": ("Int", 1, 0),
    "test_eigenvalue_filter_verify": ("Int", 0, 0),
    "test_pseudoinverse_coeffs": ("Dbl", 4.0, 1e-10),
    "test_pseudoinverse_check": ("Int", 1, 0),
    "test_pseudoinverse_effective_condition": ("Dbl", 11.11111111111111, 1e-10),
    "test_svd_estimate_condition": ("Dbl", 8.0, 1e-10),
    "test_svd_sort_descending": ("Int", 1, 0),
    "test_svd_filter": ("Int", 2, 0),
    "test_svd_normalize": ("Int", 4, 0),
    "test_hhl_enhanced_rotation": ("Dbl", 0.0, 1e-10),
    "test_hhl_filtered": ("Int", 1, 0),
    "test_hhl_multiprecision": ("Dbl", 1.0, 1e-10),
    "test_hhl_check_solution": ("Int", 0, 0),
    "test_q_rls_lambda_cv": ("Dbl", 2e-05, 1e-10),
    "test_q_rls_check_lambda": ("Int", 1, 0),
    "test_q_rls_effective_condition": ("Dbl", 9.166666666666666, 1e-10),
    "test_qsvt_apply_diagonal": ("Dbl", 1.0, 1e-10),
    "test_qsvt_amplitude_encode": ("Dbl", 1.0, 1e-10),
    "test_qsvt_normalize_vector": ("Int", 4, 0),
    "test_qsvt_check_dims": ("Int", 1, 0),
    "test_matrix_trace_power": ("Int", 1, 0),
    "test_cg_apply_matrix": ("Int", 1, 0),
    "test_gmres_apply_matrix": ("Int", 1, 0),
    "test_gmres_apply_givens": ("Int", 1, 0),
    "test_gd_step": ("Int", 1, 0),
    "test_newton_hessian_diag": ("Int", 1, 0),
    "test_pca_estimate_eigenvalues": ("Int", 1, 0),
    "test_ridge_apply_regularized": ("Int", 1, 0),
    "test_trisol_forward_substitute": ("Int", 1, 0),
    "test_trisol_backward_substitute": ("Int", 1, 0),
    # Quantum tests with probabilistic output (accept as-is with range)
    "test_swap_simulation": ("Dbl", 1.0, 0.1),
    "test_SwapA": ("Dbl", 1.0, 0.1),
    "test_DM_simulation": ("Dbl", 0.0, 0.1),
    "test_1_sparse_integer": ("Dbl", 1.0, 0.1),
    "test_qubitization_simulate": ("Int", 1, 0),
    "test_lcu_optimized_prepare": ("Int", 1, 0),
    "test_gibbs_prepare_state": ("Int", 1, 0),
    "test_timedep_simulate_step": ("Int", 1, 0),
    "test_timedep_simulate": ("Int", 1, 0),
    "test_ip_swap_test_measure": ("Dbl", 1.0, 0.1),
    "test_vnorm_measure_state": ("Dbl", 1.0, 0.1),
    "test_ge_parameter_shift": ("Int", 1, 0),
    "test_lu_solve_quantum": ("Int", 1, 0),
    "test_cholesky_solve_quantum": ("Int", 1, 0),
    "test_qr_least_squares_quantum": ("Int", 1, 0),
    "test_matrix_add_block_encode": ("Int", 1, 0),
    "test_kronecker_apply_state": ("Int", 1, 0),
    "test_em_zne_execute": ("Dbl", 1.0, 0.1),
    "test_kernel_compute_matrix_quantum": ("Dbl", 1.0, 0.1),
}


def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = 0
    added_import = False
    
    i = 0
    while i < len(lines):
        line = lines[i]
        m = re.match(r'^(\s+)operation\s+(test_\w+)\(p\s*:\s*Int\)\s*:\s*(\w+)', line)
        if m:
            indent = m.group(1)
            test_name = m.group(2)
            
            if test_name not in E:
                i += 1
                continue
            
            # Find the return line
            depth = 0
            j = i
            in_body = False
            while j < len(lines):
                for c in lines[j]:
                    if c == '{': depth += 1
                    elif c == '}': depth -= 1
                if depth == 0:
                    break  # end of operation
                if '{' in lines[j] and not in_body:
                    in_body = True
                    j += 1
                    continue
                
                if in_body:
                    ret_m = re.match(r'^(\s*)return\s+(.+);', lines[j])
                    if ret_m:
                        ret_indent = ret_m.group(1)
                        ret_expr = ret_m.group(2)
                        
                        typ, exp_val, tol = E[test_name]
                        
                        if typ == 'Int':
                            fact = f'{ret_indent}Fact({ret_expr} == {exp_val}, "{test_name}");'
                            lines[j] = fact + '\n' + f'{ret_indent}return {ret_expr};'
                        else:  # Dbl
                            fact = f'{ret_indent}Fact(AbsD({ret_expr} - {exp_val}) < {tol}, "{test_name}");'
                            lines[j] = fact + '\n' + f'{ret_indent}return {ret_expr};'
                        
                        modified += 1
                        break
                j += 1
        
        i += 1
    
    # Add import for Fact if not present
    for i, line in enumerate(lines):
        if 'import Std.Math.*;' in line:
            if not any('Std.Diagnostics.Fact' in l or 'Microsoft.Quantum.Diagnostics' in l for l in lines):
                lines.insert(i + 1, '    import Std.Diagnostics.Fact;')
                added_import = True
            break
    
    new_content = '\n'.join(lines)
    with open(filepath, 'w') as f:
        f.write(new_content)
    
    print(f'Modified {modified} tests with Fact() assertions')
    if added_import:
        print('Added import Std.Diagnostics.Fact')
    return modified


if __name__ == '__main__':
    total = process_file(TEST_FILE)
    print(f'Done. {total} tests enhanced.')
