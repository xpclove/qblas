using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;

namespace Quantum.test
{
    class Driver
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== Qblas Test Suite ===");
            using (var sim = new QuantumSimulator())
            {
                // Test 1: Teleportation / Dense coding
                Console.WriteLine("\n[Test 1] q_tele_dense_coding_1");
                for (int i = 0; i < 4; i++) {
                    var res = test_qs_tele.Run(sim, i).Result;
                    Console.WriteLine($"  input={i} -> output={res} (expected {i})");
                }

                // Test 2: QFT
                Console.WriteLine("\n[Test 2] QFT");
                var res2 = test_qft.Run(sim, 0).Result;
                Console.WriteLine($"  test_qft(0) = {res2}");

                // Test 3: 1-sparse matrix walk (bool)
                Console.WriteLine("\n[Test 3] q_matrix_1_sparse_bool_test");
                var res3 = test_qwalk_bool.Run(sim, 0).Result;
                Console.WriteLine($"  test_qwalk_bool = {res3}");

                // Test 4: Swap simulation
                Console.WriteLine("\n[Test 4] q_simulation_C_swap");
                var res4 = test_swap_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_swap_simulation = {res4}");

                // Test 5: HHL stub
                Console.WriteLine("\n[Test 5] q_hhl");
                var res5 = test_hhl.Run(sim, 0).Result;
                Console.WriteLine($"  test_hhl = {res5}");

                // Test 6: GEMV - Diagonal matrix-vector
                Console.WriteLine("\n[Test 6] q_gemv_diagonal");
                var res6 = test_gemv_diagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemv_diagonal = {res6}");

                // Test 7: GEMV - Iterated
                Console.WriteLine("\n[Test 7] q_gemv_iterated");
                var res7 = test_gemv_iterated.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemv_iterated = {res7}");

                // Test 8: GEMM - Iterated
                Console.WriteLine("\n[Test 8] q_gemm_iterated");
                var res8 = test_gemm_iterated.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_iterated = {res8}");

                // Test 9: GEMM - Block
                Console.WriteLine("\n[Test 9] q_gemm_block");
                var res9 = test_gemm_block.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_block = {res9}");

                // Test 10: GEMM - Diag-General
                Console.WriteLine("\n[Test 10] q_gemm_diag_general");
                var res10 = test_gemm_diag_general.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_diag_general = {res10}");

                // Test 11: GEMM - Transpose A
                Console.WriteLine("\n[Test 11] q_gemm_transpose_a");
                var res11 = test_gemm_transpose_a.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_transpose_a = {res11}");

                // Test 12: GEMM - Transpose B
                Console.WriteLine("\n[Test 12] q_gemm_transpose_b");
                var res12 = test_gemm_transpose_b.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_transpose_b = {res12}");

                // Test 13: SVD - Condition estimation
                Console.WriteLine("\n[Test 13] q_svd_estimate_condition");
                var res13 = test_svd_estimate_condition.Run(sim, 0).Result;
                Console.WriteLine($"  test_svd_estimate_condition = {res13}");

                // Test 14: SVD - Sort descending
                Console.WriteLine("\n[Test 14] q_svd_sort_descending");
                var res14 = test_svd_sort_descending.Run(sim, 0).Result;
                Console.WriteLine($"  test_svd_sort_descending = {res14}");

                // Test 15: SVD - Filter
                Console.WriteLine("\n[Test 15] q_svd_filter");
                var res15 = test_svd_filter.Run(sim, 0).Result;
                Console.WriteLine($"  test_svd_filter (count) = {res15}");

                // Test 16: SVD - Normalize
                Console.WriteLine("\n[Test 16] q_svd_normalize");
                var res16 = test_svd_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_svd_normalize (count) = {res16}");

                // Test 17: HHL - Enhanced rotation
                Console.WriteLine("\n[Test 17] q_hhl_enhanced_rotation");
                var res17 = test_hhl_enhanced_rotation.Run(sim, 0).Result;
                Console.WriteLine($"  test_hhl_enhanced_rotation = {res17}");

                // Test 18: HHL - Filtered
                Console.WriteLine("\n[Test 18] q_hhl_filtered");
                var res18 = test_hhl_filtered.Run(sim, 0).Result;
                Console.WriteLine($"  test_hhl_filtered = {res18}");

                // Test 19: HHL - Multi-precision
                Console.WriteLine("\n[Test 19] q_hhl_multiprecision");
                var res19 = test_hhl_multiprecision.Run(sim, 0).Result;
                Console.WriteLine($"  test_hhl_multiprecision = {res19}");

                // Test 20: HHL - Check solution
                Console.WriteLine("\n[Test 20] q_hhl_check_solution");
                var res20 = test_hhl_check_solution.Run(sim, 0).Result;
                Console.WriteLine($"  test_hhl_check_solution = {res20}");

                // Test 21: GEMM - Check dimensions
                Console.WriteLine("\n[Test 21] q_gemm_check_dims");
                var res21 = test_gemm_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_check_dims = {res21}");

                // Test 22: GEMV - Batch
                Console.WriteLine("\n[Test 22] q_gemv_batch");
                var res22 = test_gemv_batch.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemv_batch = {res22}");

                // Test 23: GEMM - Batch
                Console.WriteLine("\n[Test 23] q_gemm_batch");
                var res23 = test_gemm_batch.Run(sim, 0).Result;
                Console.WriteLine($"  test_gemm_batch = {res23}");

                // Test 24: QPE test
                Console.WriteLine("\n[Test 24] q_phase_estimate");
                var res24 = test_qpe.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe = {res24}");

                // Test 25: DM simulation
                Console.WriteLine("\n[Test 25] q_simulation_densitymatrix");
                var res25 = test_DM_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_DM_simulation = {res25}");

                // Test 26: 1-sparse integer walk
                Console.WriteLine("\n[Test 26] q_walk_1_sparse_integer");
                var res26 = test_1_sparse_integer.Run(sim, 0).Result;
                Console.WriteLine($"  test_1_sparse_integer = {res26}");

                // Test 27: SwapA simulation
                Console.WriteLine("\n[Test 27] q_simulation_SwapA");
                var res27 = test_SwapA.Run(sim, 0).Result;
                Console.WriteLine($"  test_SwapA = {res27}");

                // Test 28: QSVT apply diagonal
                Console.WriteLine("\n[Test 28] q_qsvt_apply_diagonal");
                var res28 = test_qsvt_apply_diagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsvt_apply_diagonal = {res28}");

                // Test 29: QSVT amplitude encode
                Console.WriteLine("\n[Test 29] q_qsvt_amplitude_encode");
                var res29 = test_qsvt_amplitude_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsvt_amplitude_encode = {res29}");

                // Test 30: QSVT normalize vector
                Console.WriteLine("\n[Test 30] q_qsvt_normalize_vector");
                var res30 = test_qsvt_normalize_vector.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsvt_normalize_vector count = {res30}");

                // Test 31: QSVT check dims
                Console.WriteLine("\n[Test 31] q_qsvt_check_dims");
                var res31 = test_qsvt_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsvt_check_dims = {res31}");

                // Test 32: QRLS lambda CV
                Console.WriteLine("\n[Test 32] q_rls_lambda_cv");
                var res32 = test_q_rls_lambda_cv.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_rls_lambda_cv = {res32}");

                // Test 33: QRLS check lambda
                Console.WriteLine("\n[Test 33] q_rls_check_lambda");
                var res33 = test_q_rls_check_lambda.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_rls_check_lambda = {res33}");

                // Test 34: QRLS effective condition
                Console.WriteLine("\n[Test 34] q_rls_effective_condition");
                var res34 = test_q_rls_effective_condition.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_rls_effective_condition = {res34}");

                // Test 35: Block encoding diagonal
                Console.WriteLine("\n[Test 35] q_be_diagonal");
                var res35 = test_q_be_diagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_diagonal = {res35}");

                // Test 36: Block encoding Householder
                Console.WriteLine("\n[Test 36] q_be_householder");
                var res36 = test_q_be_householder.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_householder = {res36}");

                // Test 37: Block encoding tridiagonal
                Console.WriteLine("\n[Test 37] q_be_tridiagonal");
                var res37 = test_q_be_tridiagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_tridiagonal = {res37}");

                // Test 38: Block encoding compute scaling
                Console.WriteLine("\n[Test 38] q_be_compute_scaling");
                var res38 = test_q_be_compute_scaling.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_compute_scaling = {res38}");

                // Test 39: Block encoding check sparsity
                Console.WriteLine("\n[Test 39] q_be_check_sparsity");
                var res39 = test_q_be_check_sparsity.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_check_sparsity = {res39}");

                // Test 40: Pseudoinverse coefficients
                Console.WriteLine("\n[Test 40] q_pseudoinverse_coeffs");
                var res40 = test_pseudoinverse_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_pseudoinverse_coeffs = {res40}");

                // Test 41: Pseudoinverse check applicable
                Console.WriteLine("\n[Test 41] q_pseudoinverse_check");
                var res41 = test_pseudoinverse_check.Run(sim, 0).Result;
                Console.WriteLine($"  test_pseudoinverse_check = {res41}");

                // Test 42: Pseudoinverse effective condition
                Console.WriteLine("\n[Test 42] q_pseudoinverse_effective_condition");
                var res42 = test_pseudoinverse_effective_condition.Run(sim, 0).Result;
                Console.WriteLine($"  test_pseudoinverse_effective_condition = {res42}");

                // Test 43: Chebyshev polynomials
                Console.WriteLine("\n[Test 43] q_chebyshev_polynomials");
                var res43 = test_chebyshev_polynomials.Run(sim, 0).Result;
                Console.WriteLine($"  test_chebyshev_polynomials = {res43}");

                // Test 44: Chebyshev coefficients
                Console.WriteLine("\n[Test 44] q_chebyshev_coefficients");
                var res44 = test_chebyshev_coefficients.Run(sim, 0).Result;
                Console.WriteLine($"  test_chebyshev_coefficients = {res44}");

                // Test 45: Chebyshev map to interval
                Console.WriteLine("\n[Test 45] q_chebyshev_map");
                var res45 = test_chebyshev_map.Run(sim, 0).Result;
                Console.WriteLine($"  test_chebyshev_map = {res45}");

                // Test 46: Chebyshev error bound
                Console.WriteLine("\n[Test 46] q_chebyshev_error_bound");
                var res46 = test_chebyshev_error_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_chebyshev_error_bound = {res46}");

                // Test 47: Chebyshev select degree
                Console.WriteLine("\n[Test 47] q_chebyshev_select_degree");
                var res47 = test_chebyshev_select_degree.Run(sim, 0).Result;
                Console.WriteLine($"  test_chebyshev_select_degree = {res47}");

                // Test 48: Matrix trace power
                Console.WriteLine("\n[Test 48] q_matrix_trace_power");
                var res48 = test_matrix_trace_power.Run(sim, 0).Result;
                Console.WriteLine($"  test_matrix_trace_power = {res48}");

                // Test 49: Eigenvalue filter lowpass
                Console.WriteLine("\n[Test 49] q_eigenvalue_filter_lowpass");
                var res49 = test_eigenvalue_filter_lowpass.Run(sim, 0).Result;
                Console.WriteLine($"  test_eigenvalue_filter_lowpass = {res49}");

                // Test 50: Eigenvalue filter highpass
                Console.WriteLine("\n[Test 50] q_eigenvalue_filter_highpass");
                var res50 = test_eigenvalue_filter_highpass.Run(sim, 0).Result;
                Console.WriteLine($"  test_eigenvalue_filter_highpass = {res50}");

                // Test 51: Eigenvalue filter bandpass
                Console.WriteLine("\n[Test 51] q_eigenvalue_filter_bandpass");
                var res51 = test_eigenvalue_filter_bandpass.Run(sim, 0).Result;
                Console.WriteLine($"  test_eigenvalue_filter_bandpass = {res51}");

                // Test 52: Eigenvalue filter verify
                Console.WriteLine("\n[Test 52] q_eigenvalue_filter_verify");
                var res52 = test_eigenvalue_filter_verify.Run(sim, 0).Result;
                Console.WriteLine($"  test_eigenvalue_filter_verify = {res52}");

                // Test 53: CG residual norm
                Console.WriteLine("\n[Test 53] q_cg_residual_norm");
                var res53 = test_cg_residual_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_cg_residual_norm = {res53}");

                // Test 54: CG converged
                Console.WriteLine("\n[Test 54] q_cg_converged");
                var res54 = test_cg_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_cg_converged = {res54}");

                // Test 55: CG compute beta
                Console.WriteLine("\n[Test 55] q_cg_compute_beta");
                var res55 = test_cg_compute_beta.Run(sim, 0).Result;
                Console.WriteLine($"  test_cg_compute_beta = {res55}");

                // Test 56: CG compute alpha
                Console.WriteLine("\n[Test 56] q_cg_compute_alpha");
                var res56 = test_cg_compute_alpha.Run(sim, 0).Result;
                Console.WriteLine($"  test_cg_compute_alpha = {res56}");

                // Test 57: Lanczos norm
                Console.WriteLine("\n[Test 57] q_lanczos_norm");
                var res57 = test_lanczos_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_norm = {res57}");

                // Test 58: Lanczos normalize
                Console.WriteLine("\n[Test 58] q_lanczos_normalize");
                var res58 = test_lanczos_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_normalize = {res58}");

                // Test 59: Lanczos alpha compute
                Console.WriteLine("\n[Test 59] q_lanczos_alpha_compute");
                var res59 = test_lanczos_alpha_compute.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_alpha_compute = {res59}");

                // Test 60: Lanczos beta compute
                Console.WriteLine("\n[Test 60] q_lanczos_beta_compute");
                var res60 = test_lanczos_beta_compute.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_beta_compute = {res60}");

                // Test 61: Lanczos tridiag
                Console.WriteLine("\n[Test 61] q_lanczos_tridiag");
                var res61 = test_lanczos_tridiag.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_tridiag = {res61}");

                // Test 62: Lanczos eigenvalue sum
                Console.WriteLine("\n[Test 62] q_lanczos_eigenvalue_sum");
                var res62 = test_lanczos_eigenvalue_sum.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_eigenvalue_sum = {res62}");

                // Test 63: Krylov residual norm
                Console.WriteLine("\n[Test 63] q_krylov_residual_norm");
                var res63 = test_krylov_residual_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_residual_norm = {res63}");

                // Test 64: Krylov converged
                Console.WriteLine("\n[Test 64] q_krylov_converged");
                var res64 = test_krylov_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_converged = {res64}");

                // Test 65: Krylov norm sq
                Console.WriteLine("\n[Test 65] q_krylov_norm_sq");
                var res65 = test_krylov_norm_sq.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_norm_sq = {res65}");

                // Test 66: Krylov inner product
                Console.WriteLine("\n[Test 66] q_krylov_inner_product");
                var res66 = test_krylov_inner_product.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_inner_product = {res66}");

                // Test 67: GMRES norm
                Console.WriteLine("\n[Test 67] q_gmres_norm");
                var res67 = test_gmres_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_gmres_norm = {res67}");

                // Test 68: GMRES converged
                Console.WriteLine("\n[Test 68] q_gmres_converged");
                var res68 = test_gmres_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_gmres_converged = {res68}");

                // Test 69: GMRES hessenberg size
                Console.WriteLine("\n[Test 69] q_gmres_hessenberg_size");
                var res69 = test_gmres_hessenberg_size.Run(sim, 0).Result;
                Console.WriteLine($"  test_gmres_hessenberg_size = {res69}");

                // Test 70: GD norm
                Console.WriteLine("\n[Test 70] q_gd_norm");
                var res70 = test_gd_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_gd_norm = {res70}");

                // Test 71: GD converged
                Console.WriteLine("\n[Test 71] q_gd_converged");
                var res71 = test_gd_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_gd_converged = {res71}");

                // Test 72: GD norm sq
                Console.WriteLine("\n[Test 72] q_gd_norm_sq");
                var res72 = test_gd_norm_sq.Run(sim, 0).Result;
                Console.WriteLine($"  test_gd_norm_sq = {res72}");

                // Test 73: Newton norm
                Console.WriteLine("\n[Test 73] q_newton_norm");
                var res73 = test_newton_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_newton_norm = {res73}");

                // Test 74: Newton converged
                Console.WriteLine("\n[Test 74] q_newton_converged");
                var res74 = test_newton_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_newton_converged = {res74}");

                // Test 75: PCA eigenvalue norm
                Console.WriteLine("\n[Test 75] q_pca_eigenvalue_norm");
                var res75 = test_pca_eigenvalue_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_eigenvalue_norm = {res75}");

                // Test 76: PCA explained var
                Console.WriteLine("\n[Test 76] q_pca_explained_var");
                var res76 = test_pca_explained_var.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_explained_var = {res76}");

                // Test 77: PCA projection matrix
                Console.WriteLine("\n[Test 77] q_pca_projection_matrix");
                var res77 = test_pca_projection_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_projection_matrix = {res77}");

                // Test 78: Ridge effective cond
                Console.WriteLine("\n[Test 78] q_ridge_effective_cond");
                var res78 = test_ridge_effective_cond.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_effective_cond = {res78}");

                // Test 79: Ridge lambda opt
                Console.WriteLine("\n[Test 79] q_ridge_lambda_opt");
                var res79 = test_ridge_lambda_opt.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_lambda_opt = {res79}");

                // Test 80: Ridge matrix dim
                Console.WriteLine("\n[Test 80] q_ridge_matrix_dim");
                var res80 = test_ridge_matrix_dim.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_matrix_dim = {res80}");

                // Test 81: Trisol is triangular
                Console.WriteLine("\n[Test 81] q_trisol_is_triangular");
                var res81 = test_trisol_is_triangular.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_is_triangular = {res81}");

                // Test 82: Trisol diagonal nonzero
                Console.WriteLine("\n[Test 82] q_trisol_diagonal_nonzero");
                var res82 = test_trisol_diagonal_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_diagonal_nonzero = {res82}");

                // Test 83: Trisol norm
                Console.WriteLine("\n[Test 83] q_trisol_norm");
                var res83 = test_trisol_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_norm = {res83}");

                // Test 84: QSP is valid phase
                Console.WriteLine("\n[Test 84] q_qsp_is_valid_phase");
                var res84 = test_qsp_is_valid_phase.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_is_valid_phase = {res84}");

                // Test 85: QSP poly eval
                Console.WriteLine("\n[Test 85] q_qsp_poly_eval");
                var res85 = test_qsp_poly_eval.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_poly_eval = {res85}");

                // Test 86: QSP phase from degree
                Console.WriteLine("\n[Test 86] q_qsp_phase_from_degree");
                var res86 = test_qsp_phase_from_degree.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_phase_from_degree = {res86}");

                // Test 87: QSP symmetric phase seq
                Console.WriteLine("\n[Test 87] q_qsp_symmetric_phase_seq");
                var res87 = test_qsp_symmetric_phase_seq.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_symmetric_phase_seq = {res87}");

                // Test 88: QSP apply rotation
                Console.WriteLine("\n[Test 88] q_qsp_apply_rotation");
                var res88 = test_qsp_apply_rotation.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_apply_rotation = {res88}");

                // Test 89: QSP polynomial unitary
                Console.WriteLine("\n[Test 89] q_qsp_polynomial_unitary");
                var res89 = test_qsp_polynomial_unitary.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_polynomial_unitary = {res89}");

                // Test 90: QSP eigenvalue transform
                Console.WriteLine("\n[Test 90] q_qsp_eigenvalue_transform");
                var res90 = test_qsp_eigenvalue_transform.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_eigenvalue_transform = {res90}");

                // Test 91: QSP Chebyshev phase
                Console.WriteLine("\n[Test 91] q_qsp_chebyshev_phase");
                var res91 = test_qsp_chebyshev_phase.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_chebyshev_phase = {res91}");

                // Test 92: QSP kernel
                Console.WriteLine("\n[Test 92] q_qsp_kernel");
                var res92 = test_qsp_kernel.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_kernel = {res92}");

                // Test 93: QSP validate sequence
                Console.WriteLine("\n[Test 93] q_qsp_validate_sequence");
                var res93 = test_qsp_validate_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_validate_sequence = {res93}");

                // Test 94: QSP linear combination
                Console.WriteLine("\n[Test 94] q_qsp_linear_combination");
                var res94 = test_qsp_linear_combination.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_linear_combination = {res94}");

                // Test 95: Trotter step size
                Console.WriteLine("\n[Test 95] q_trotter_step_size");
                var res95 = test_trotter_step_size.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_step_size = {res95}");

                // Test 96: Trotter Suzuki 2nd order coeffs
                Console.WriteLine("\n[Test 96] q_trotter_suzuki_2_coeffs");
                var res96 = test_trotter_suzuki_2_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_2_coeffs = {res96}");

                // Test 97: Trotter high order coeffs
                Console.WriteLine("\n[Test 97] q_trotter_suzuki_high_order_coeffs");
                var res97 = test_trotter_suzuki_high_order_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_high_order_coeffs = {res97}");

                // Test 98: Trotter optimal steps
                Console.WriteLine("\n[Test 98] q_trotter_optimal_steps");
                var res98 = test_trotter_optimal_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_optimal_steps = {res98}");

                // Test 99: Trotter first order
                Console.WriteLine("\n[Test 99] q_trotter_first_order");
                var res99 = test_trotter_first_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_first_order = {res99}");

                // Test 100: Trotter Suzuki 2nd order
                Console.WriteLine("\n[Test 100] q_trotter_suzuki_2nd_order");
                var res100 = test_trotter_suzuki_2nd_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_2nd_order = {res100}");

                // Test 101: Trotter controlled first order
                Console.WriteLine("\n[Test 101] q_trotter_C_first_order");
                var res101 = test_trotter_C_first_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_C_first_order = {res101}");

                // Test 102: Trotter is valid order
                Console.WriteLine("\n[Test 102] q_trotter_is_valid_order");
                var res102 = test_trotter_is_valid_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_is_valid_order = {res102}");

                // Test 103: Trotter error bound
                Console.WriteLine("\n[Test 103] q_trotter_error_bound");
                var res103 = test_trotter_error_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_error_bound = {res103}");

                // Test 104: Trotter decomposition length
                Console.WriteLine("\n[Test 104] q_trotter_decomposition_length");
                var res104 = test_trotter_decomposition_length.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_decomposition_length = {res104}");

                // Test 105: Trotter verify hamiltonian
                Console.WriteLine("\n[Test 105] q_trotter_verify_hamiltonian");
                var res105 = test_trotter_verify_hamiltonian.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_verify_hamiltonian = {res105}");

                // Test 106: Trotter check ancilla
                Console.WriteLine("\n[Test 106] q_trotter_check_ancilla");
                var res106 = test_trotter_check_ancilla.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_check_ancilla = {res106}");

                // Test 107: 2-sparse is 2-sparse
                Console.WriteLine("\n[Test 107] q_2sparse_is_2sparse");
                var res107 = test_2sparse_is_2sparse.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_is_2sparse = {res107}");

                // Test 108: 2-sparse check row sparsity
                Console.WriteLine("\n[Test 108] q_2sparse_check_row_sparsity");
                var res108 = test_2sparse_check_row_sparsity.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_check_row_sparsity = {res108}");

                // Test 109: 2-sparse row norm
                Console.WriteLine("\n[Test 109] q_2sparse_row_norm");
                var res109 = test_2sparse_row_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_row_norm = {res109}");

                // Test 110: 2-sparse find nonzero
                Console.WriteLine("\n[Test 110] q_2sparse_find_nonzero");
                var res110 = test_2sparse_find_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_find_nonzero = {res110}");

                // Test 111: 2-sparse combined norm
                Console.WriteLine("\n[Test 111] q_2sparse_combined_norm");
                var res111 = test_2sparse_combined_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_combined_norm = {res111}");

                // Test 112: 2-sparse walk simulation
                Console.WriteLine("\n[Test 112] q_2sparse_walk_simulation");
                var res112 = test_2sparse_walk_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_walk_simulation = {res112}");

                // Test 113: 2-sparse controlled walk simulation
                Console.WriteLine("\n[Test 113] q_2sparse_C_walk_simulation");
                var res113 = test_2sparse_C_walk_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_C_walk_simulation = {res113}");

                // Test 114: 2-sparse stride bits
                Console.WriteLine("\n[Test 114] q_2sparse_stride_bits");
                var res114 = test_2sparse_stride_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_stride_bits = {res114}");

                // Test 115: 2-sparse estimate norm
                Console.WriteLine("\n[Test 115] q_2sparse_estimate_norm");
                var res115 = test_2sparse_estimate_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_estimate_norm = {res115}");

                // Test 116: 2-sparse verify decomposition
                Console.WriteLine("\n[Test 116] q_2sparse_verify_decomposition");
                var res116 = test_2sparse_verify_decomposition.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_verify_decomposition = {res116}");

                // Test 117: 2-sparse optimal steps
                Console.WriteLine("\n[Test 117] q_2sparse_optimal_steps");
                var res117 = test_2sparse_optimal_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_optimal_steps = {res117}");

                // Test 118: 2-sparse check ancilla
                Console.WriteLine("\n[Test 118] q_2sparse_check_ancilla");
                var res118 = test_2sparse_check_ancilla.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_check_ancilla = {res118}");

                // Test 119: 2-sparse eigenvalue bound
                Console.WriteLine("\n[Test 119] q_2sparse_eigenvalue_bound");
                var res119 = test_2sparse_eigenvalue_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_eigenvalue_bound = {res119}");

                // Test 120: QAA optimal iterations
                Console.WriteLine("\n[Test 120] q_qaa_optimal_iterations");
                var res120 = test_qaa_optimal_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_optimal_iterations = {res120}");

                // Test 121: QAA speedup
                Console.WriteLine("\n[Test 121] q_qaa_speedup");
                var res121 = test_qaa_speedup.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_speedup = {res121}");

                // Test 122: QAA valid iterations
                Console.WriteLine("\n[Test 122] q_qaa_valid_iterations");
                var res122 = test_qaa_valid_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_valid_iterations = {res122}");

                // Test 123: QAA schedule
                Console.WriteLine("\n[Test 123] q_qaa_schedule");
                var res123 = test_qaa_schedule.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_schedule = {res123}");

                // Test 124: QAA state reflection
                Console.WriteLine("\n[Test 124] q_qaa_state_reflection");
                var res124 = test_qaa_state_reflection.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_state_reflection = {res124}");

                // Test 125: QPE phase from eigenvalue
                Console.WriteLine("\n[Test 125] q_qpe_phase_from_eigenvalue");
                var res125 = test_qpe_phase_from_eigenvalue.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_phase_from_eigenvalue = {res125}");

                // Test 126: QPE Bayesian update
                Console.WriteLine("\n[Test 126] q_qpe_bayesian_update");
                var res126 = test_qpe_bayesian_update.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_bayesian_update = {res126}");

                // Test 127: QPE precision
                Console.WriteLine("\n[Test 127] q_qpe_precision");
                var res127 = test_qpe_precision.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_precision = {res127}");

                // Test 128: QPE validate eigenvalues
                Console.WriteLine("\n[Test 128] q_qpe_validate_eigenvalues");
                var res128 = test_qpe_validate_eigenvalues.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_validate_eigenvalues = {res128}");

                // Test 129: QPE iteration schedule
                Console.WriteLine("\n[Test 129] q_qpe_iteration_schedule");
                var res129 = test_qpe_iteration_schedule.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_iteration_schedule = {res129}");

                // Test 130: QPE success probability
                Console.WriteLine("\n[Test 130] q_qpe_success_probability");
                var res130 = test_qpe_success_probability.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_success_probability = {res130}");

                // Test 131: QPE variance
                Console.WriteLine("\n[Test 131] q_qpe_variance");
                var res131 = test_qpe_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_variance = {res131}");

                // Test 132: QPE check eigenstate
                Console.WriteLine("\n[Test 132] q_qpe_check_eigenstate");
                var res132 = test_qpe_check_eigenstate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_check_eigenstate = {res132}");

                // Test 133: QPE optimal bits
                Console.WriteLine("\n[Test 133] q_qpe_optimal_bits");
                var res133 = test_qpe_optimal_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_optimal_bits = {res133}");

                // Test 134: QGE parameter shift
                Console.WriteLine("\n[Test 134] q_qge_parameter_shift");
                var res134 = test_qge_parameter_shift.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_parameter_shift = {res134}");

                // Test 135: QGE shift angle
                Console.WriteLine("\n[Test 135] q_qge_shift_angle");
                var res135 = test_qge_shift_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_shift_angle = {res135}");

                // Test 136: QGE gradient magnitude
                Console.WriteLine("\n[Test 136] q_qge_gradient_magnitude");
                var res136 = test_qge_gradient_magnitude.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_magnitude = {res136}");

                // Test 137: QGE quantum natural gradient
                Console.WriteLine("\n[Test 137] q_qge_quantum_natural_gradient");
                var res137 = test_qge_quantum_natural_gradient.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_quantum_natural_gradient = {res137}");

                // Test 138: QGE converged
                Console.WriteLine("\n[Test 138] q_qge_converged");
                var res138 = test_qge_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_converged = {res138}");

                // Test 139: QGE optimal learning rate
                Console.WriteLine("\n[Test 139] q_qge_optimal_learning_rate");
                var res139 = test_qge_optimal_learning_rate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_optimal_learning_rate = {res139}");

                // Test 140: QGE gradient descent step
                Console.WriteLine("\n[Test 140] q_qge_gradient_descent_step");
                var res140 = test_qge_gradient_descent_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_descent_step = {res140}");

                // Test 141: QGE hessian estimate
                Console.WriteLine("\n[Test 141] q_qge_hessian_estimate");
                var res141 = test_qge_hessian_estimate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_hessian_estimate = {res141}");

                // Test 142: QGE valid shift
                Console.WriteLine("\n[Test 142] q_qge_valid_shift");
                var res142 = test_qge_valid_shift.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_valid_shift = {res142}");

                // Test 143: QGE gradient variance
                Console.WriteLine("\n[Test 143] q_qge_gradient_variance");
                var res143 = test_qge_gradient_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_variance = {res143}");

                // Test 144: QGE adam step
                Console.WriteLine("\n[Test 144] q_qge_adam_step");
                var res144 = test_qge_adam_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_adam_step = {res144}");

                // Test 145: QROM read
                Console.WriteLine("\n[Test 145] qrom_read");
                var res145 = test_qrom_read.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_read = {res145}");

                // Test 146: QROM read multi
                Console.WriteLine("\n[Test 146] qrom_read_multi");
                var res146 = test_qrom_read_multi.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_read_multi = {res146}");

                // Test 147: LCU block encode
                Console.WriteLine("\n[Test 147] lcu_block_encode");
                var res147 = test_lcu_block_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_block_encode = {res147}");

                // Test 148: LCU prepare coeffs
                Console.WriteLine("\n[Test 148] lcu_prepare_coeffs");
                var res148 = test_lcu_prepare_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_prepare_coeffs = {res148}");

                // Test 149: LCU compute alpha
                Console.WriteLine("\n[Test 149] lcu_compute_alpha");
                var res149 = test_lcu_compute_alpha.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_compute_alpha = {res149}");

                // Test 150: LCU validate coeffs
                Console.WriteLine("\n[Test 150] lcu_validate_coeffs");
                var res150 = test_lcu_validate_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_validate_coeffs = {res150}");

                // Test 151: OAA optimal iterations
                Console.WriteLine("\n[Test 151] oaa_optimal_iterations");
                var res151 = test_oaa_optimal_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_oaa_optimal_iterations = {res151}");

                // Test 152: OAA check amplification
                Console.WriteLine("\n[Test 152] oaa_check_amplification");
                var res152 = test_oaa_check_amplification.Run(sim, 0).Result;
                Console.WriteLine($"  test_oaa_check_amplification = {res152}");

                // Test 153: QROM compute addr bits
                Console.WriteLine("\n[Test 153] qrom_compute_addr_bits");
                var res153 = test_qrom_compute_addr_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_compute_addr_bits = {res153}");

                // Test 154: QROM validate addr space
                Console.WriteLine("\n[Test 154] qrom_validate_addr_space");
                var res154 = test_qrom_validate_addr_space.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_validate_addr_space = {res154}");

                // Test 155: BE frobenius norm
                Console.WriteLine("\n[Test 155] q_be_frobenius_norm");
                var res155 = test_q_be_frobenius_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_frobenius_norm = {res155}");

                // Test 156: BE validate block encode
                Console.WriteLine("\n[Test 156] q_be_validate_block_encode");
                var res156 = test_q_be_validate_block_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_validate_block_encode = {res156}");

                // Test 157: LCU scale coeffs
                Console.WriteLine("\n[Test 157] q_lcu_scale_coeffs");
                var res157 = test_q_lcu_scale_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_lcu_scale_coeffs = {res157}");

                // Test 158: Signal rotation angle
                Console.WriteLine("\n[Test 158] q_signal_rotation_angle");
                var res158 = test_q_signal_rotation_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_signal_rotation_angle = {res158}");

                // Test 159: VQE HEA
                Console.WriteLine("\n[Test 159] vqe_hea");
                var res159 = test_vqe_hea.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_hea = {res159}");

                // Test 160: VQE QAOA
                Console.WriteLine("\n[Test 160] vqe_qaoa");
                var res160 = test_vqe_qaoa.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_qaoa = {res160}");

                // Test 161: VQE SU2
                Console.WriteLine("\n[Test 161] vqe_su2");
                var res161 = test_vqe_su2.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_su2 = {res161}");

                // Test 162: VQE param shift plus
                Console.WriteLine("\n[Test 162] vqe_param_shift_plus");
                var res162 = test_vqe_param_shift_plus.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_param_shift_plus = {res162}");

                // Test 163: VQE param shift minus
                Console.WriteLine("\n[Test 163] vqe_param_shift_minus");
                var res163 = test_vqe_param_shift_minus.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_param_shift_minus = {res163}");

                // Test 164: VQE gradient from shifts
                Console.WriteLine("\n[Test 164] vqe_gradient_from_shifts");
                var res164 = test_vqe_gradient_from_shifts.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_from_shifts = {res164}");

                // Test 165: VQE weighted sum
                Console.WriteLine("\n[Test 165] vqe_weighted_sum");
                var res165 = test_vqe_weighted_sum.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_weighted_sum = {res165}");

                // Test 166: VQE valid expectation
                Console.WriteLine("\n[Test 166] vqe_valid_expectation");
                var res166 = test_vqe_valid_expectation.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_valid_expectation = {res166}");

                // Test 167: VQE gradient descent step
                Console.WriteLine("\n[Test 167] vqe_gradient_descent_step");
                var res167 = test_vqe_gradient_descent_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_descent_step = {res167}");

                // Test 168: VQE adam step
                Console.WriteLine("\n[Test 168] vqe_adam_step");
                var res168 = test_vqe_adam_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_adam_step = {res168}");

                // Test 169: VQE converged
                Console.WriteLine("\n[Test 169] vqe_converged");
                var res169 = test_vqe_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_converged = {res169}");

                // Test 170: VQE energy converged
                Console.WriteLine("\n[Test 170] vqe_energy_converged");
                var res170 = test_vqe_energy_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_energy_converged = {res170}");

                // Test 171: VQE init adam
                Console.WriteLine("\n[Test 171] vqe_init_adam");
                var res171 = test_vqe_init_adam.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_init_adam = {res171}");

                // Test 172: VQE ansatz depth
                Console.WriteLine("\n[Test 172] vqe_ansatz_depth");
                var res172 = test_vqe_ansatz_depth.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_ansatz_depth = {res172}");

                // Test 173: VQE count params
                Console.WriteLine("\n[Test 173] vqe_count_params");
                var res173 = test_vqe_count_params.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_count_params = {res173}");

                // Test 174: VQE parse pauli string
                Console.WriteLine("\n[Test 174] vqe_parse_pauli_string");
                var res174 = test_vqe_parse_pauli_string.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_parse_pauli_string = {res174}");

                // Test 175: VQE term weight
                Console.WriteLine("\n[Test 175] vqe_term_weight");
                var res175 = test_vqe_term_weight.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_term_weight = {res175}");

                // Test 176: VQE shift angle
                Console.WriteLine("\n[Test 176] vqe_shift_angle");
                var res176 = test_vqe_shift_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_shift_angle = {res176}");

                // Test 177: VQE hessian diag
                Console.WriteLine("\n[Test 177] vqe_hessian_diag");
                var res177 = test_vqe_hessian_diag.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_hessian_diag = {res177}");

                // Test 178: VQE gradient variance
                Console.WriteLine("\n[Test 178] vqe_gradient_variance");
                var res178 = test_vqe_gradient_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_variance = {res178}");

                // Test 179: VQE adaptive lr
                Console.WriteLine("\n[Test 179] vqe_adaptive_lr");
                var res179 = test_vqe_adaptive_lr.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_adaptive_lr = {res179}");

                // Test 180: VQE shot allocation
                Console.WriteLine("\n[Test 180] vqe_shot_allocation");
                var res180 = test_vqe_shot_allocation.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_shot_allocation = {res180}");

                // Test 181: VQE init state
                Console.WriteLine("\n[Test 181] vqe_init_state");
                var res181 = test_vqe_init_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_init_state = {res181}");

                // Test 182: VQE validate params
                Console.WriteLine("\n[Test 182] vqe_validate_params");
                var res182 = test_vqe_validate_params.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_validate_params = {res182}");

                // Test 183: Kernel feature angles
                Console.WriteLine("\n[Test 183] kernel_feature_angles");
                var res183 = test_kernel_feature_angles.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_feature_angles = {res183}");

                // Test 184: Kernel apply feature map
                Console.WriteLine("\n[Test 184] kernel_apply_feature_map");
                var res184 = test_kernel_apply_feature_map.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_apply_feature_map = {res184}");

                // Test 185: Kernel matrix
                Console.WriteLine("\n[Test 185] kernel_matrix");
                var res185 = test_kernel_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_matrix = {res185}");

                // Test 186: Kernel dot
                Console.WriteLine("\n[Test 186] kernel_dot");
                var res186 = test_kernel_dot.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_dot = {res186}");

                // Test 187: Kernel validate
                Console.WriteLine("\n[Test 187] kernel_validate");
                var res187 = test_kernel_validate.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_validate = {res187}");

                // Test 188: Kernel gaussian
                Console.WriteLine("\n[Test 188] kernel_gaussian");
                var res188 = test_kernel_gaussian.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_gaussian = {res188}");

                // Test 189: Kernel polynomial
                Console.WriteLine("\n[Test 189] kernel_polynomial");
                var res189 = test_kernel_polynomial.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_polynomial = {res189}");

                // Test 190: Kernel normalize
                Console.WriteLine("\n[Test 190] kernel_normalize");
                var res190 = test_kernel_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_normalize = {res190}");

                // Test 191: ZNE extrapolate
                Console.WriteLine("\n[Test 191] zne_extrapolate");
                var res191 = test_zne_extrapolate.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_extrapolate = {res191}");

                // Test 192: ZNE linear
                Console.WriteLine("\n[Test 192] zne_linear");
                var res192 = test_zne_linear.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_linear = {res192}");

                // Test 193: ZNE noise factors
                Console.WriteLine("\n[Test 193] zne_noise_factors");
                var res193 = test_zne_noise_factors.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_noise_factors = {res193}");

                // Test 194: ZNE optimal factors
                Console.WriteLine("\n[Test 194] zne_optimal_factors");
                var res194 = test_zne_optimal_factors.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_optimal_factors = {res194}");

                // Test 195: PEC coefficients
                Console.WriteLine("\n[Test 195] pec_coefficients");
                var res195 = test_pec_coefficients.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_coefficients = {res195}");

                // Test 196: PEC validate
                Console.WriteLine("\n[Test 196] pec_validate");
                var res196 = test_pec_validate.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_validate = {res196}");

                // Test 197: PEC sampling prob
                Console.WriteLine("\n[Test 197] pec_sampling_prob");
                var res197 = test_pec_sampling_prob.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_sampling_prob = {res197}");

                // Test 198: DD XY sequence
                Console.WriteLine("\n[Test 198] dd_xy_sequence");
                var res198 = test_dd_xy_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_xy_sequence = {res198}");

                // Test 199: DD padding interval
                Console.WriteLine("\n[Test 199] dd_padding_interval");
                var res199 = test_dd_padding_interval.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_padding_interval = {res199}");

                // Test 200: DD validate sequence
                Console.WriteLine("\n[Test 200] dd_validate_sequence");
                var res200 = test_dd_validate_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_validate_sequence = {res200}");

                // Test 201: Readout calibration
                Console.WriteLine("\n[Test 201] readout_calibration");
                var res201 = test_readout_calibration.Run(sim, 0).Result;
                Console.WriteLine($"  test_readout_calibration = {res201}");

                // Test 202: Readout correct
                Console.WriteLine("\n[Test 202] readout_correct");
                var res202 = test_readout_correct.Run(sim, 0).Result;
                Console.WriteLine($"  test_readout_correct = {res202}");

                // Test 203: DD fidelity improvement
                Console.WriteLine("\n[Test 203] dd_fidelity_improvement");
                var res203 = test_dd_fidelity_improvement.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_fidelity_improvement = {res203}");

                // Test 204: ZNE verify
                Console.WriteLine("\n[Test 204] zne_verify");
                var res204 = test_zne_verify.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_verify = {res204}");

                // Test 205: PEC normalize
                Console.WriteLine("\n[Test 205] pec_normalize");
                var res205 = test_pec_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_normalize = {res205}");

                // Test 206: DD pulse timing
                Console.WriteLine("\n[Test 206] dd_pulse_timing");
                var res206 = test_dd_pulse_timing.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_pulse_timing = {res206}");

                // Test 207: LU is square
                Console.WriteLine("\n[Test 207] lu_is_square");
                var res207 = test_lu_is_square.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_is_square = {res207}");

                // Test 208: LU diagonal nonzero
                Console.WriteLine("\n[Test 208] lu_diagonal_nonzero");
                var res208 = test_lu_diagonal_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_diagonal_nonzero = {res208}");

                // Test 209: LU extract L
                Console.WriteLine("\n[Test 209] lu_extract_l");
                var res209 = test_lu_extract_l.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_extract_l = {res209}");

                // Test 210: LU extract U
                Console.WriteLine("\n[Test 210] lu_extract_u");
                var res210 = test_lu_extract_u.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_extract_u = {res210}");

                // Test 211: LU check dims
                Console.WriteLine("\n[Test 211] lu_check_dims");
                var res211 = test_lu_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_check_dims = {res211}");

                // Test 212: LU pivot indices
                Console.WriteLine("\n[Test 212] lu_pivot_indices");
                var res212 = test_lu_pivot_indices.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_pivot_indices = {res212}");

                // Test 213: LU solve
                Console.WriteLine("\n[Test 213] lu_solve");
                var res213 = test_lu_solve.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_solve = {res213}");

                // Test 214: QR check dims
                Console.WriteLine("\n[Test 214] qr_check_dims");
                var res214 = test_qr_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_check_dims = {res214}");

                // Test 215: QR column norms
                Console.WriteLine("\n[Test 215] qr_column_norms");
                var res215 = test_qr_column_norms.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_column_norms = {res215}");

                // Test 216: QR extract R
                Console.WriteLine("\n[Test 216] qr_extract_r");
                var res216 = test_qr_extract_r.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_extract_r = {res216}");

                // Test 217: QR check orthogonal
                Console.WriteLine("\n[Test 217] qr_check_orthogonal");
                var res217 = test_qr_check_orthogonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_check_orthogonal = {res217}");

                // Test 218: QR rank estimate
                Console.WriteLine("\n[Test 218] qr_rank_estimate");
                var res218 = test_qr_rank_estimate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_rank_estimate = {res218}");

                // Test 219: Chol is symmetric
                Console.WriteLine("\n[Test 219] chol_is_symmetric");
                var res219 = test_chol_is_symmetric.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_is_symmetric = {res219}");

                // Test 220: Chol matrix norm
                Console.WriteLine("\n[Test 220] chol_matrix_norm");
                var res220 = test_chol_matrix_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_matrix_norm = {res220}");

                // Test 221: Chol positive diagonal
                Console.WriteLine("\n[Test 221] chol_check_positive_diagonal");
                var res221 = test_chol_check_positive_diagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_check_positive_diagonal = {res221}");

                // Test 222: Chol LDLT
                Console.WriteLine("\n[Test 222] chol_ldlt");
                var res222 = test_chol_ldlt.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_ldlt = {res222}");

                // Test 223: Add check dims
                Console.WriteLine("\n[Test 223] add_check_dims");
                var res223 = test_add_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_check_dims = {res223}");

                // Test 224: Add matrix add
                Console.WriteLine("\n[Test 224] add_matrix_add");
                var res224 = test_add_matrix_add.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_matrix_add = {res224}");

                // Test 225: Add matrix subtract
                Console.WriteLine("\n[Test 225] add_matrix_subtract");
                var res225 = test_add_matrix_subtract.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_matrix_subtract = {res225}");

                // Test 226: Add scalar mult
                Console.WriteLine("\n[Test 226] add_scalar_mult");
                var res226 = test_add_scalar_mult.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_scalar_mult = {res226}");

                // Test 227: Add negate
                Console.WriteLine("\n[Test 227] add_negate");
                var res227 = test_add_negate.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_negate = {res227}");

                // Test 228: Add linear combo
                Console.WriteLine("\n[Test 228] add_linear_combo");
                var res228 = test_add_linear_combo.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_linear_combo = {res228}");

                // Test 229: Add Hadamard
                Console.WriteLine("\n[Test 229] add_hadamard");
                var res229 = test_add_hadamard.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_hadamard = {res229}");

                // Test 230: Vnorm L2
                Console.WriteLine("\n[Test 230] vnorm_l2");
                var res230 = test_vnorm_l2.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_l2 = {res230}");

                // Test 231: Vnorm L1
                Console.WriteLine("\n[Test 231] vnorm_l1");
                var res231 = test_vnorm_l1.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_l1 = {res231}");

                // Test 232: Vnorm Linf
                Console.WriteLine("\n[Test 232] vnorm_linf");
                var res232 = test_vnorm_linf.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_linf = {res232}");

                // Test 233: Vnorm ratio
                Console.WriteLine("\n[Test 233] vnorm_ratio");
                var res233 = test_vnorm_ratio.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_ratio = {res233}");

                // Test 234: Vnorm normalize
                Console.WriteLine("\n[Test 234] vnorm_normalize");
                var res234 = test_vnorm_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_normalize = {res234}");

                // Test 235: Vnorm is unit
                Console.WriteLine("\n[Test 235] vnorm_is_unit");
                var res235 = test_vnorm_is_unit.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_is_unit = {res235}");

                // Test 236: Vnorm distance
                Console.WriteLine("\n[Test 236] vnorm_distance");
                var res236 = test_vnorm_distance.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_distance = {res236}");

                // Test 237: IP dot
                Console.WriteLine("\n[Test 237] ip_dot");
                var res237 = test_ip_dot.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_dot = {res237}");

                // Test 238: IP fidelity
                Console.WriteLine("\n[Test 238] ip_fidelity");
                var res238 = test_ip_fidelity.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_fidelity = {res238}");

                // Test 239: IP normalize
                Console.WriteLine("\n[Test 239] ip_normalize");
                var res239 = test_ip_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_normalize = {res239}");

                // Test 240: IP angle
                Console.WriteLine("\n[Test 240] ip_angle");
                var res240 = test_ip_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_angle = {res240}");

                // Test 241: IP is orthogonal
                Console.WriteLine("\n[Test 241] ip_is_orthogonal");
                var res241 = test_ip_is_orthogonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_is_orthogonal = {res241}");

                // Test 242: TK check dims
                Console.WriteLine("\n[Test 242] tk_check_dims");
                var res242 = test_tk_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_check_dims = {res242}");

                // Test 243: TK Kronecker
                Console.WriteLine("\n[Test 243] tk_kronecker");
                var res243 = test_tk_kronecker.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_kronecker = {res243}");

                // Test 244: TK vector Kronecker
                Console.WriteLine("\n[Test 244] tk_vector_kronecker");
                var res244 = test_tk_vector_kronecker.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_vector_kronecker = {res244}");

                // Test 245: TK identity
                Console.WriteLine("\n[Test 245] tk_identity");
                var res245 = test_tk_identity.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_identity = {res245}");

                // Test 246: TK Hadamard
                Console.WriteLine("\n[Test 246] tk_hadamard");
                var res246 = test_tk_hadamard.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_hadamard = {res246}");

                // Test 247: TK verify
                Console.WriteLine("\n[Test 247] tk_verify");
                var res247 = test_tk_verify.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_verify = {res247}");

                // ============ Qubitization Tests ============
                // Test 248: qubitization phases
                Console.WriteLine("\n[Test 248] qubitization_phases");
                var res248 = test_qubitization_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_phases = {res248}");

                // Test 249: qubitization query complexity
                Console.WriteLine("\n[Test 249] qubitization_query_complexity");
                var res249 = test_qubitization_query_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_query_complexity = {res249}");

                // Test 250: qubitization chebyshev
                Console.WriteLine("\n[Test 250] qubitization_chebyshev");
                var res250 = test_qubitization_chebyshev.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_chebyshev = {res250}");

                // Test 251: qubitization compute phases
                Console.WriteLine("\n[Test 251] qubitization_compute_phases");
                var res251 = test_qubitization_compute_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_compute_phases = {res251}");

                // Test 252: qubitization accuracy
                Console.WriteLine("\n[Test 252] qubitization_accuracy");
                var res252 = test_qubitization_accuracy.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_accuracy = {res252}");

                // Test 253: qubitization spectral gap
                Console.WriteLine("\n[Test 253] qubitization_spectral_gap");
                var res253 = test_qubitization_spectral_gap.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_spectral_gap = {res253}");

                // Test 254: qubitization timestep
                Console.WriteLine("\n[Test 254] qubitization_timestep");
                var res254 = test_qubitization_timestep.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_timestep = {res254}");

                // Test 255: qubitization qsp phases
                Console.WriteLine("\n[Test 255] qubitization_qsp_phases");
                var res255 = test_qubitization_qsp_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_qsp_phases = {res255}");

                // Test 256: qubitization estimate queries
                Console.WriteLine("\n[Test 256] qubitization_estimate_queries");
                var res256 = test_qubitization_estimate_queries.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_estimate_queries = {res256}");

                // ============ LCU Optimized Tests ============
                // Test 257: lcu ancilla bits
                Console.WriteLine("\n[Test 257] lcu_ancilla_bits");
                var res257 = test_lcu_ancilla_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_ancilla_bits = {res257}");

                // Test 258: lcu gate count
                Console.WriteLine("\n[Test 258] lcu_gate_count");
                var res258 = test_lcu_gate_count.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_gate_count = {res258}");

                // Test 259: lcu coefficient norm
                Console.WriteLine("\n[Test 259] lcu_coefficient_norm");
                var res259 = test_lcu_coefficient_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_coefficient_norm = {res259}");

                // Test 260: lcu check coeffs
                Console.WriteLine("\n[Test 260] lcu_check_coeffs");
                var res260 = test_lcu_check_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_check_coeffs = {res260}");

                // Test 261: lcu amplitudes
                Console.WriteLine("\n[Test 261] lcu_amplitudes");
                var res261 = test_lcu_amplitudes.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_amplitudes = {res261}");

                // Test 262: lcu success prob
                Console.WriteLine("\n[Test 262] lcu_success_prob");
                var res262 = test_lcu_success_prob.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_success_prob = {res262}");

                // Test 263: lcu is power of two
                Console.WriteLine("\n[Test 263] lcu_is_power_of_two");
                var res263 = test_lcu_is_power_of_two.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_is_power_of_two = {res263}");

                // Test 264: lcu pad coeffs
                Console.WriteLine("\n[Test 264] lcu_pad_coeffs");
                var res264 = test_lcu_pad_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_pad_coeffs = {res264}");

                // Test 265: lcu query complexity
                Console.WriteLine("\n[Test 265] lcu_query_complexity");
                var res265 = test_lcu_query_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_query_complexity = {res265}");

                // Test 266: lcu csd angles
                Console.WriteLine("\n[Test 266] lcu_csd_angles");
                var res266 = test_lcu_csd_angles.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_csd_angles = {res266}");

                // ============ Gibbs Tests ============
                // Test 267: gibbs compute beta
                Console.WriteLine("\n[Test 267] gibbs_compute_beta");
                var res267 = test_gibbs_compute_beta.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_compute_beta = {res267}");

                // Test 268: gibbs partition bound
                Console.WriteLine("\n[Test 268] gibbs_partition_bound");
                var res268 = test_gibbs_partition_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_partition_bound = {res268}");

                // Test 269: gibbs spectral gap
                Console.WriteLine("\n[Test 269] gibbs_spectral_gap");
                var res269 = test_gibbs_spectral_gap.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_spectral_gap = {res269}");

                // Test 270: gibbs verify state
                Console.WriteLine("\n[Test 270] gibbs_verify_state");
                var res270 = test_gibbs_verify_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_verify_state = {res270}");

                // Test 271: gibbs free energy
                Console.WriteLine("\n[Test 271] gibbs_free_energy");
                var res271 = test_gibbs_free_energy.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_free_energy = {res271}");

                // Test 272: gibbs estimate temp
                Console.WriteLine("\n[Test 272] gibbs_estimate_temp");
                var res272 = test_gibbs_estimate_temp.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_estimate_temp = {res272}");

                // Test 273: gibbs partition function
                Console.WriteLine("\n[Test 273] gibbs_partition_function");
                var res273 = test_gibbs_partition_function.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_partition_function = {res273}");

                // Test 274: gibbs probabilities
                Console.WriteLine("\n[Test 274] gibbs_probabilities");
                var res274 = test_gibbs_probabilities.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_probabilities = {res274}");

                // Test 275: gibbs valid temp
                Console.WriteLine("\n[Test 275] gibbs_valid_temp");
                var res275 = test_gibbs_valid_temp.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_valid_temp = {res275}");

                // Test 276: gibbs complexity
                Console.WriteLine("\n[Test 276] gibbs_complexity");
                var res276 = test_gibbs_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_complexity = {res276}");

                // ============ Time-Dependent Tests ============
                // Test 277: timedep discretize steps
                Console.WriteLine("\n[Test 277] timedep_discretize_steps");
                var res277 = test_timedep_discretize_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_discretize_steps = {res277}");

                // Test 278: timedep step size
                Console.WriteLine("\n[Test 278] timedep_step_size");
                var res278 = test_timedep_step_size.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_step_size = {res278}");

                // Test 279: timedep evaluate
                Console.WriteLine("\n[Test 279] timedep_evaluate");
                var res279 = test_timedep_evaluate.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_evaluate = {res279}");

                // Test 280: timedep error bound
                Console.WriteLine("\n[Test 280] timedep_error_bound");
                var res280 = test_timedep_error_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_error_bound = {res280}");

                // Test 281: timedep norm variation
                Console.WriteLine("\n[Test 281] timedep_norm_variation");
                var res281 = test_timedep_norm_variation.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_norm_variation = {res281}");

                // Test 282: timedep verify evolution
                Console.WriteLine("\n[Test 282] timedep_verify_evolution");
                var res282 = test_timedep_verify_evolution.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_verify_evolution = {res282}");

                // Test 283: timedep optimal order
                Console.WriteLine("\n[Test 283] timedep_optimal_order");
                var res283 = test_timedep_optimal_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_optimal_order = {res283}");

                // Test 284: timedep query count
                Console.WriteLine("\n[Test 284] timedep_query_count");
                var res284 = test_timedep_query_count.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_query_count = {res284}");
            }
            Console.WriteLine("\n=== All tests completed ===");
        }
    }
}