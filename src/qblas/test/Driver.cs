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

                // Test 53: CG converged
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

                // ======= Lanczos Quantum Tests (63-67) =======
                // Test 63: Lanczos apply matrix
                Console.WriteLine("\n[Test 63] test_lanczos_apply_matrix");
                var res_lan1 = test_lanczos_apply_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_apply_matrix = {res_lan1}");

                // Test 64: Lanczos estimate alpha
                Console.WriteLine("\n[Test 64] test_lanczos_estimate_alpha");
                var res_lan2 = test_lanczos_estimate_alpha.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_estimate_alpha = {res_lan2}");

                // Test 65: Lanczos iterate
                Console.WriteLine("\n[Test 65] test_lanczos_iterate");
                var res_lan3 = test_lanczos_iterate.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_iterate = {res_lan3}");

                // Test 66: Lanczos step
                Console.WriteLine("\n[Test 66] test_lanczos_step");
                var res_lan4 = test_lanczos_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_step = {res_lan4}");

                // Test 67: Lanczos tridiagonalization
                Console.WriteLine("\n[Test 67] test_lanczos_compute_tridiag");
                var res_lan5 = test_lanczos_compute_tridiag.Run(sim, 0).Result;
                Console.WriteLine($"  test_lanczos_compute_tridiag = {res_lan5}");

                // Test 68: Krylov SWAP test one shot
                Console.WriteLine("\n[Test 63] test_krylov_swap_test_one_shot");
                var t63 = test_krylov_swap_test_one_shot.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_swap_test_one_shot = {t63} (expected 1)");

                // Test 69: Krylov estimate overlap
                Console.WriteLine("\n[Test 64] test_krylov_estimate_overlap");
                var t64 = test_krylov_estimate_overlap.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_estimate_overlap = {t64} (expected ~1.0)");

                // Test 70: Krylov apply matrix
                Console.WriteLine("\n[Test 65] test_krylov_apply_matrix");
                var t65 = test_krylov_apply_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_apply_matrix = {t65}");

                // Test 71: Krylov generate subspace
                Console.WriteLine("\n[Test 66] test_krylov_generate_subspace");
                var t66 = test_krylov_generate_subspace.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_generate_subspace = {t66}");

                // Test 72: Krylov swap overlap (two identical states)
                Console.WriteLine("\n[Test 67] test_krylov_swap_overlap");
                var t67 = test_krylov_swap_overlap.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_swap_overlap = {t67} (expected ~1.0)");

                // Test 73: Krylov Gram matrix
                Console.WriteLine("\n[Test 68] test_krylov_gram_matrix");
                var t68 = test_krylov_gram_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_gram_matrix = {t68} (expected ~1.0)");

                // Test 74: Krylov Arnoldi overlaps
                Console.WriteLine("\n[Test 69] test_krylov_arnoldi_overlaps");
                var t69 = test_krylov_arnoldi_overlaps.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_arnoldi_overlaps = {t69}");

                // Tests 70-72: Classic Krylov helpers (kept)
                Console.WriteLine("\n[Test 70] q_krylov_converged");
                var t70 = test_krylov_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_converged = {t70}");

                Console.WriteLine("\n[Test 71] q_krylov_norm_sq");
                var t71 = test_krylov_norm_sq.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_norm_sq = {t71}");

                Console.WriteLine("\n[Test 72] q_krylov_inner_product");
                var t72 = test_krylov_inner_product.Run(sim, 0).Result;
                Console.WriteLine($"  test_krylov_inner_product = {t72}");

                // Test 73: GMRES converged
                Console.WriteLine("\n[Test 74] q_gmres_converged");
                var rgmr2 = test_gmres_converged.Run(sim, 0).Result;
                Console.WriteLine($"  q_gmres_converged = {rgmr2}");

                // Test 77: GMRES hessenberg size
                Console.WriteLine("\n[Test 75] q_gmres_hessenberg_size");
                var rgmr3 = test_gmres_hessenberg_size.Run(sim, 0).Result;
                Console.WriteLine($"  q_gmres_hessenberg_size = {rgmr3}");

                // Test 78: GD norm
                Console.WriteLine("\n[Test 76] q_gd_norm");
                var rgd1 = test_gd_norm.Run(sim, 0).Result;
                Console.WriteLine($"  q_gd_norm = {rgd1}");

                // Test 79: GD converged
                Console.WriteLine("\n[Test 77] q_gd_converged");
                var rgd2 = test_gd_converged.Run(sim, 0).Result;
                Console.WriteLine($"  q_gd_converged = {rgd2}");

                // Test 80: GD norm sq
                Console.WriteLine("\n[Test 78] q_gd_norm_sq");
                var rgd3 = test_gd_norm_sq.Run(sim, 0).Result;
                Console.WriteLine($"  q_gd_norm_sq = {rgd3}");

                // Test 81: Newton norm
                Console.WriteLine("\n[Test 73] q_newton_norm");
                var r73 = test_newton_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_newton_norm = {r73}");

                // Test 82: Newton converged
                Console.WriteLine("\n[Test 74] q_newton_converged");
                var r74 = test_newton_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_newton_converged = {r74}");

                // Test 83: PCA eigenvalue norm
                Console.WriteLine("\n[Test 75] q_pca_eigenvalue_norm");
                var r75 = test_pca_eigenvalue_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_eigenvalue_norm = {r75}");

                // Test 84: PCA explained var
                Console.WriteLine("\n[Test 76] q_pca_explained_var");
                var r76 = test_pca_explained_var.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_explained_var = {r76}");

                // Test 85: PCA projection matrix
                Console.WriteLine("\n[Test 77] q_pca_projection_matrix");
                var r77 = test_pca_projection_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_projection_matrix = {r77}");

                // Test 86: Ridge effective cond
                Console.WriteLine("\n[Test 78] q_ridge_effective_cond");
                var r78 = test_ridge_effective_cond.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_effective_cond = {r78}");

                // Test 87: Ridge lambda opt
                Console.WriteLine("\n[Test 79] q_ridge_lambda_opt");
                var r79 = test_ridge_lambda_opt.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_lambda_opt = {r79}");

                // Test 88: Ridge matrix dim
                Console.WriteLine("\n[Test 80] q_ridge_matrix_dim");
                var r80 = test_ridge_matrix_dim.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_matrix_dim = {r80}");

                // Test 89: Trisol is triangular
                Console.WriteLine("\n[Test 81] q_trisol_is_triangular");
                var r81 = test_trisol_is_triangular.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_is_triangular = {r81}");

                // Test 90: Trisol diagonal nonzero
                Console.WriteLine("\n[Test 82] q_trisol_diagonal_nonzero");
                var r82 = test_trisol_diagonal_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_diagonal_nonzero = {r82}");

                // Test 83: QSP is valid phase
                Console.WriteLine("\n[Test 84] q_qsp_is_valid_phase");
                var r84 = test_qsp_is_valid_phase.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_is_valid_phase = {r84}");

                // Test 93: QSP poly eval
                Console.WriteLine("\n[Test 85] q_qsp_poly_eval");
                var r85 = test_qsp_poly_eval.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_poly_eval = {r85}");

                // Test 94: QSP phase from degree
                Console.WriteLine("\n[Test 86] q_qsp_phase_from_degree");
                var r86 = test_qsp_phase_from_degree.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_phase_from_degree = {r86}");

                // Test 95: QSP symmetric phase seq
                Console.WriteLine("\n[Test 87] q_qsp_symmetric_phase_seq");
                var r87 = test_qsp_symmetric_phase_seq.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_symmetric_phase_seq = {r87}");

                // Test 96: QSP apply rotation
                Console.WriteLine("\n[Test 88] q_qsp_apply_rotation");
                var r88 = test_qsp_apply_rotation.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_apply_rotation = {r88}");

                // Test 97: QSP polynomial unitary
                Console.WriteLine("\n[Test 89] q_qsp_polynomial_unitary");
                var r89 = test_qsp_polynomial_unitary.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_polynomial_unitary = {r89}");

                // Test 98: QSP eigenvalue transform
                Console.WriteLine("\n[Test 90] q_qsp_eigenvalue_transform");
                var r90 = test_qsp_eigenvalue_transform.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_eigenvalue_transform = {r90}");

                // Test 99: QSP Chebyshev phase
                Console.WriteLine("\n[Test 91] q_qsp_chebyshev_phase");
                var r91 = test_qsp_chebyshev_phase.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_chebyshev_phase = {r91}");

                // Test 100: QSP kernel
                Console.WriteLine("\n[Test 92] q_qsp_kernel");
                var r92 = test_qsp_kernel.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_kernel = {r92}");

                // Test 101: QSP validate sequence
                Console.WriteLine("\n[Test 93] q_qsp_validate_sequence");
                var r93 = test_qsp_validate_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_validate_sequence = {r93}");

                // Test 102: QSP linear combination
                Console.WriteLine("\n[Test 94] q_qsp_linear_combination");
                var r94 = test_qsp_linear_combination.Run(sim, 0).Result;
                Console.WriteLine($"  test_qsp_linear_combination = {r94}");

                // Test 103: Trotter step size
                Console.WriteLine("\n[Test 95] q_trotter_step_size");
                var r95 = test_trotter_step_size.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_step_size = {r95}");

                // Test 104: Trotter Suzuki 2nd order coeffs
                Console.WriteLine("\n[Test 96] q_trotter_suzuki_2_coeffs");
                var r96 = test_trotter_suzuki_2_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_2_coeffs = {r96}");

                // Test 105: Trotter high order coeffs
                Console.WriteLine("\n[Test 97] q_trotter_suzuki_high_order_coeffs");
                var r97 = test_trotter_suzuki_high_order_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_high_order_coeffs = {r97}");

                // Test 106: Trotter optimal steps
                Console.WriteLine("\n[Test 98] q_trotter_optimal_steps");
                var r98 = test_trotter_optimal_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_optimal_steps = {r98}");

                // Test 107: Trotter first order
                Console.WriteLine("\n[Test 99] q_trotter_first_order");
                var r99 = test_trotter_first_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_first_order = {r99}");

                // Test 108: Trotter Suzuki 2nd order
                Console.WriteLine("\n[Test 100] q_trotter_suzuki_2nd_order");
                var r100 = test_trotter_suzuki_2nd_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_suzuki_2nd_order = {r100}");

                // Test 109: Trotter controlled first order
                Console.WriteLine("\n[Test 101] q_trotter_C_first_order");
                var r101 = test_trotter_C_first_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_C_first_order = {r101}");

                // Test 110: Trotter is valid order
                Console.WriteLine("\n[Test 102] q_trotter_is_valid_order");
                var r102 = test_trotter_is_valid_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_is_valid_order = {r102}");

                // Test 111: Trotter error bound
                Console.WriteLine("\n[Test 103] q_trotter_error_bound");
                var r103 = test_trotter_error_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_error_bound = {r103}");

                // Test 112: Trotter decomposition length
                Console.WriteLine("\n[Test 104] q_trotter_decomposition_length");
                var r104 = test_trotter_decomposition_length.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_decomposition_length = {r104}");

                // Test 113: Trotter verify hamiltonian
                Console.WriteLine("\n[Test 105] q_trotter_verify_hamiltonian");
                var r105 = test_trotter_verify_hamiltonian.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_verify_hamiltonian = {r105}");

                // Test 114: Trotter check ancilla
                Console.WriteLine("\n[Test 106] q_trotter_check_ancilla");
                var r106 = test_trotter_check_ancilla.Run(sim, 0).Result;
                Console.WriteLine($"  test_trotter_check_ancilla = {r106}");

                // Test 115: 2-sparse is 2-sparse
                Console.WriteLine("\n[Test 107] q_2sparse_is_2sparse");
                var r107 = test_2sparse_is_2sparse.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_is_2sparse = {r107}");

                // Test 116: 2-sparse check row sparsity
                Console.WriteLine("\n[Test 108] q_2sparse_check_row_sparsity");
                var r108 = test_2sparse_check_row_sparsity.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_check_row_sparsity = {r108}");

                // Test 117: 2-sparse row norm
                Console.WriteLine("\n[Test 109] q_2sparse_row_norm");
                var r109 = test_2sparse_row_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_row_norm = {r109}");

                // Test 118: 2-sparse find nonzero
                Console.WriteLine("\n[Test 110] q_2sparse_find_nonzero");
                var r110 = test_2sparse_find_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_find_nonzero = {r110}");

                // Test 119: 2-sparse combined norm
                Console.WriteLine("\n[Test 111] q_2sparse_combined_norm");
                var r111 = test_2sparse_combined_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_combined_norm = {r111}");

                // Test 120: 2-sparse walk simulation
                Console.WriteLine("\n[Test 112] q_2sparse_walk_simulation");
                var r112 = test_2sparse_walk_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_walk_simulation = {r112}");

                // Test 121: 2-sparse controlled walk simulation
                Console.WriteLine("\n[Test 113] q_2sparse_C_walk_simulation");
                var r113 = test_2sparse_C_walk_simulation.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_C_walk_simulation = {r113}");

                // Test 122: 2-sparse stride bits
                Console.WriteLine("\n[Test 114] q_2sparse_stride_bits");
                var r114 = test_2sparse_stride_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_stride_bits = {r114}");

                // Test 123: 2-sparse estimate norm
                Console.WriteLine("\n[Test 115] q_2sparse_estimate_norm");
                var r115 = test_2sparse_estimate_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_estimate_norm = {r115}");

                // Test 124: 2-sparse verify decomposition
                Console.WriteLine("\n[Test 116] q_2sparse_verify_decomposition");
                var r116 = test_2sparse_verify_decomposition.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_verify_decomposition = {r116}");

                // Test 125: 2-sparse optimal steps
                Console.WriteLine("\n[Test 117] q_2sparse_optimal_steps");
                var r117 = test_2sparse_optimal_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_optimal_steps = {r117}");

                // Test 126: 2-sparse check ancilla
                Console.WriteLine("\n[Test 118] q_2sparse_check_ancilla");
                var r118 = test_2sparse_check_ancilla.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_check_ancilla = {r118}");

                // Test 127: 2-sparse eigenvalue bound
                Console.WriteLine("\n[Test 119] q_2sparse_eigenvalue_bound");
                var r119 = test_2sparse_eigenvalue_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_2sparse_eigenvalue_bound = {r119}");

                // Test 128: QAA optimal iterations
                Console.WriteLine("\n[Test 120] q_qaa_optimal_iterations");
                var r120 = test_qaa_optimal_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_optimal_iterations = {r120}");

                // Test 129: QAA speedup
                Console.WriteLine("\n[Test 121] q_qaa_speedup");
                var r121 = test_qaa_speedup.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_speedup = {r121}");

                // Test 130: QAA valid iterations
                Console.WriteLine("\n[Test 122] q_qaa_valid_iterations");
                var r122 = test_qaa_valid_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_valid_iterations = {r122}");

                // Test 131: QAA schedule
                Console.WriteLine("\n[Test 123] q_qaa_schedule");
                var r123 = test_qaa_schedule.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_schedule = {r123}");

                // Test 132: QAA state reflection
                Console.WriteLine("\n[Test 124] q_qaa_state_reflection");
                var r124 = test_qaa_state_reflection.Run(sim, 0).Result;
                Console.WriteLine($"  test_qaa_state_reflection = {r124}");

                // Test 133: QPE phase from eigenvalue
                Console.WriteLine("\n[Test 125] q_qpe_phase_from_eigenvalue");
                var r125 = test_qpe_phase_from_eigenvalue.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_phase_from_eigenvalue = {r125}");

                // Test 134: QPE Bayesian update
                Console.WriteLine("\n[Test 126] q_qpe_bayesian_update");
                var r126 = test_qpe_bayesian_update.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_bayesian_update = {r126}");

                // Test 135: QPE precision
                Console.WriteLine("\n[Test 127] q_qpe_precision");
                var r127 = test_qpe_precision.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_precision = {r127}");

                // Test 136: QPE validate eigenvalues
                Console.WriteLine("\n[Test 128] q_qpe_validate_eigenvalues");
                var r128 = test_qpe_validate_eigenvalues.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_validate_eigenvalues = {r128}");

                // Test 137: QPE iteration schedule
                Console.WriteLine("\n[Test 129] q_qpe_iteration_schedule");
                var r129 = test_qpe_iteration_schedule.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_iteration_schedule = {r129}");

                // Test 138: QPE success probability
                Console.WriteLine("\n[Test 130] q_qpe_success_probability");
                var r130 = test_qpe_success_probability.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_success_probability = {r130}");

                // Test 139: QPE variance
                Console.WriteLine("\n[Test 131] q_qpe_variance");
                var r131 = test_qpe_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_variance = {r131}");

                // Test 140: QPE check eigenstate
                Console.WriteLine("\n[Test 132] q_qpe_check_eigenstate");
                var r132 = test_qpe_check_eigenstate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_check_eigenstate = {r132}");

                // Test 141: QPE optimal bits
                Console.WriteLine("\n[Test 133] q_qpe_optimal_bits");
                var r133 = test_qpe_optimal_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_qpe_optimal_bits = {r133}");

                // Test 142: QGE parameter shift
                Console.WriteLine("\n[Test 134] q_qge_parameter_shift");
                var r134 = test_qge_parameter_shift.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_parameter_shift = {r134}");

                // Test 143: QGE shift angle
                Console.WriteLine("\n[Test 135] q_qge_shift_angle");
                var r135 = test_qge_shift_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_shift_angle = {r135}");

                // Test 144: QGE gradient magnitude
                Console.WriteLine("\n[Test 136] q_qge_gradient_magnitude");
                var r136 = test_qge_gradient_magnitude.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_magnitude = {r136}");

                // Test 145: QGE quantum natural gradient
                Console.WriteLine("\n[Test 137] q_qge_quantum_natural_gradient");
                var r137 = test_qge_quantum_natural_gradient.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_quantum_natural_gradient = {r137}");

                // Test 146: QGE converged
                Console.WriteLine("\n[Test 138] q_qge_converged");
                var r138 = test_qge_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_converged = {r138}");

                // Test 147: QGE optimal learning rate
                Console.WriteLine("\n[Test 139] q_qge_optimal_learning_rate");
                var r139 = test_qge_optimal_learning_rate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_optimal_learning_rate = {r139}");

                // Test 148: QGE gradient descent step
                Console.WriteLine("\n[Test 140] q_qge_gradient_descent_step");
                var r140 = test_qge_gradient_descent_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_descent_step = {r140}");

                // Test 149: QGE hessian estimate
                Console.WriteLine("\n[Test 141] q_qge_hessian_estimate");
                var r141 = test_qge_hessian_estimate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_hessian_estimate = {r141}");

                // Test 150: QGE valid shift
                Console.WriteLine("\n[Test 142] q_qge_valid_shift");
                var r142 = test_qge_valid_shift.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_valid_shift = {r142}");

                // Test 151: QGE gradient variance
                Console.WriteLine("\n[Test 143] q_qge_gradient_variance");
                var r143 = test_qge_gradient_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_gradient_variance = {r143}");

                // Test 152: QGE adam step
                Console.WriteLine("\n[Test 144] q_qge_adam_step");
                var r144 = test_qge_adam_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_qge_adam_step = {r144}");

                // Test 153: QROM read
                Console.WriteLine("\n[Test 145] qrom_read");
                var r145 = test_qrom_read.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_read = {r145}");

                // Test 154: QROM read multi
                Console.WriteLine("\n[Test 146] qrom_read_multi");
                var r146 = test_qrom_read_multi.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_read_multi = {r146}");

                // Test 155: LCU block encode
                Console.WriteLine("\n[Test 147] lcu_block_encode");
                var r147 = test_lcu_block_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_block_encode = {r147}");

                // Test 156: LCU prepare coeffs
                Console.WriteLine("\n[Test 148] lcu_prepare_coeffs");
                var r148 = test_lcu_prepare_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_prepare_coeffs = {r148}");

                // Test 157: LCU compute alpha
                Console.WriteLine("\n[Test 149] lcu_compute_alpha");
                var r149 = test_lcu_compute_alpha.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_compute_alpha = {r149}");

                // Test 158: LCU validate coeffs
                Console.WriteLine("\n[Test 150] lcu_validate_coeffs");
                var r150 = test_lcu_validate_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_validate_coeffs = {r150}");

                // Test 159: OAA optimal iterations
                Console.WriteLine("\n[Test 151] oaa_optimal_iterations");
                var r151 = test_oaa_optimal_iterations.Run(sim, 0).Result;
                Console.WriteLine($"  test_oaa_optimal_iterations = {r151}");

                // Test 160: OAA check amplification
                Console.WriteLine("\n[Test 152] oaa_check_amplification");
                var r152 = test_oaa_check_amplification.Run(sim, 0).Result;
                Console.WriteLine($"  test_oaa_check_amplification = {r152}");

                // Test 161: QROM compute addr bits
                Console.WriteLine("\n[Test 153] qrom_compute_addr_bits");
                var r153 = test_qrom_compute_addr_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_compute_addr_bits = {r153}");

                // Test 162: QROM validate addr space
                Console.WriteLine("\n[Test 154] qrom_validate_addr_space");
                var r154 = test_qrom_validate_addr_space.Run(sim, 0).Result;
                Console.WriteLine($"  test_qrom_validate_addr_space = {r154}");

                // Test 163: BE frobenius norm
                Console.WriteLine("\n[Test 155] q_be_frobenius_norm");
                var r155 = test_q_be_frobenius_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_frobenius_norm = {r155}");

                // Test 164: BE validate block encode
                Console.WriteLine("\n[Test 156] q_be_validate_block_encode");
                var r156 = test_q_be_validate_block_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_be_validate_block_encode = {r156}");

                // Test 165: LCU scale coeffs
                Console.WriteLine("\n[Test 157] q_lcu_scale_coeffs");
                var r157 = test_q_lcu_scale_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_lcu_scale_coeffs = {r157}");

                // Test 166: Signal rotation angle
                Console.WriteLine("\n[Test 158] q_signal_rotation_angle");
                var r158 = test_q_signal_rotation_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_q_signal_rotation_angle = {r158}");

                // Test 167: VQE HEA
                Console.WriteLine("\n[Test 159] vqe_hea");
                var r159 = test_vqe_hea.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_hea = {r159}");

                // Test 168: VQE QAOA
                Console.WriteLine("\n[Test 160] vqe_qaoa");
                var r160 = test_vqe_qaoa.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_qaoa = {r160}");

                // Test 169: VQE SU2
                Console.WriteLine("\n[Test 161] vqe_su2");
                var r161 = test_vqe_su2.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_su2 = {r161}");

                // Test 170: VQE param shift plus
                Console.WriteLine("\n[Test 162] vqe_param_shift_plus");
                var r162 = test_vqe_param_shift_plus.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_param_shift_plus = {r162}");

                // Test 171: VQE param shift minus
                Console.WriteLine("\n[Test 163] vqe_param_shift_minus");
                var r163 = test_vqe_param_shift_minus.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_param_shift_minus = {r163}");

                // Test 172: VQE gradient from shifts
                Console.WriteLine("\n[Test 164] vqe_gradient_from_shifts");
                var r164 = test_vqe_gradient_from_shifts.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_from_shifts = {r164}");

                // Test 173: VQE weighted sum
                Console.WriteLine("\n[Test 165] vqe_weighted_sum");
                var r165 = test_vqe_weighted_sum.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_weighted_sum = {r165}");

                // Test 174: VQE valid expectation
                Console.WriteLine("\n[Test 166] vqe_valid_expectation");
                var r166 = test_vqe_valid_expectation.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_valid_expectation = {r166}");

                // Test 175: VQE gradient descent step
                Console.WriteLine("\n[Test 167] vqe_gradient_descent_step");
                var r167 = test_vqe_gradient_descent_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_descent_step = {r167}");

                // Test 176: VQE adam step
                Console.WriteLine("\n[Test 168] vqe_adam_step");
                var r168 = test_vqe_adam_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_adam_step = {r168}");

                // Test 177: VQE converged
                Console.WriteLine("\n[Test 169] vqe_converged");
                var r169 = test_vqe_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_converged = {r169}");

                // Test 178: VQE energy converged
                Console.WriteLine("\n[Test 170] vqe_energy_converged");
                var r170 = test_vqe_energy_converged.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_energy_converged = {r170}");

                // Test 179: VQE init adam
                Console.WriteLine("\n[Test 171] vqe_init_adam");
                var r171 = test_vqe_init_adam.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_init_adam = {r171}");

                // Test 180: VQE ansatz depth
                Console.WriteLine("\n[Test 172] vqe_ansatz_depth");
                var r172 = test_vqe_ansatz_depth.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_ansatz_depth = {r172}");

                // Test 181: VQE count params
                Console.WriteLine("\n[Test 173] vqe_count_params");
                var r173 = test_vqe_count_params.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_count_params = {r173}");

                // Test 182: VQE parse pauli string
                Console.WriteLine("\n[Test 174] vqe_parse_pauli_string");
                var r174 = test_vqe_parse_pauli_string.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_parse_pauli_string = {r174}");

                // Test 183: VQE term weight
                Console.WriteLine("\n[Test 175] vqe_term_weight");
                var r175 = test_vqe_term_weight.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_term_weight = {r175}");

                // Test 184: VQE shift angle
                Console.WriteLine("\n[Test 176] vqe_shift_angle");
                var r176 = test_vqe_shift_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_shift_angle = {r176}");

                // Test 185: VQE hessian diag
                Console.WriteLine("\n[Test 177] vqe_hessian_diag");
                var r177 = test_vqe_hessian_diag.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_hessian_diag = {r177}");

                // Test 186: VQE gradient variance
                Console.WriteLine("\n[Test 178] vqe_gradient_variance");
                var r178 = test_vqe_gradient_variance.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_gradient_variance = {r178}");

                // Test 187: VQE adaptive lr
                Console.WriteLine("\n[Test 179] vqe_adaptive_lr");
                var r179 = test_vqe_adaptive_lr.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_adaptive_lr = {r179}");

                // Test 188: VQE shot allocation
                Console.WriteLine("\n[Test 180] vqe_shot_allocation");
                var r180 = test_vqe_shot_allocation.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_shot_allocation = {r180}");

                // Test 189: VQE init state
                Console.WriteLine("\n[Test 181] vqe_init_state");
                var r181 = test_vqe_init_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_init_state = {r181}");

                // Test 190: VQE validate params
                Console.WriteLine("\n[Test 182] vqe_validate_params");
                var r182 = test_vqe_validate_params.Run(sim, 0).Result;
                Console.WriteLine($"  test_vqe_validate_params = {r182}");

                // Test 191: Kernel feature angles
                Console.WriteLine("\n[Test 183] kernel_feature_angles");
                var r183 = test_kernel_feature_angles.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_feature_angles = {r183}");

                // Test 192: Kernel apply feature map
                Console.WriteLine("\n[Test 184] kernel_apply_feature_map");
                var r184 = test_kernel_apply_feature_map.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_apply_feature_map = {r184}");

                // Test 193: Kernel matrix
                Console.WriteLine("\n[Test 185] kernel_matrix");
                var r185 = test_kernel_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_matrix = {r185}");

                // Test 194: Kernel dot
                Console.WriteLine("\n[Test 186] kernel_dot");
                var r186 = test_kernel_dot.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_dot = {r186}");

                // Test 195: Kernel validate
                Console.WriteLine("\n[Test 187] kernel_validate");
                var r187 = test_kernel_validate.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_validate = {r187}");

                // Test 196: Kernel gaussian
                Console.WriteLine("\n[Test 188] kernel_gaussian");
                var r188 = test_kernel_gaussian.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_gaussian = {r188}");

                // Test 197: Kernel polynomial
                Console.WriteLine("\n[Test 189] kernel_polynomial");
                var r189 = test_kernel_polynomial.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_polynomial = {r189}");

                // Test 198: Kernel normalize
                Console.WriteLine("\n[Test 190] kernel_normalize");
                var r190 = test_kernel_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_normalize = {r190}");

                // Test 199: ZNE extrapolate
                Console.WriteLine("\n[Test 191] zne_extrapolate");
                var r191 = test_zne_extrapolate.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_extrapolate = {r191}");

                // Test 200: ZNE linear
                Console.WriteLine("\n[Test 192] zne_linear");
                var r192 = test_zne_linear.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_linear = {r192}");

                // Test 201: ZNE noise factors
                Console.WriteLine("\n[Test 193] zne_noise_factors");
                var r193 = test_zne_noise_factors.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_noise_factors = {r193}");

                // Test 202: ZNE optimal factors
                Console.WriteLine("\n[Test 194] zne_optimal_factors");
                var r194 = test_zne_optimal_factors.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_optimal_factors = {r194}");

                // Test 203: PEC coefficients
                Console.WriteLine("\n[Test 195] pec_coefficients");
                var r195 = test_pec_coefficients.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_coefficients = {r195}");

                // Test 204: PEC validate
                Console.WriteLine("\n[Test 196] pec_validate");
                var r196 = test_pec_validate.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_validate = {r196}");

                // Test 205: PEC sampling prob
                Console.WriteLine("\n[Test 197] pec_sampling_prob");
                var r197 = test_pec_sampling_prob.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_sampling_prob = {r197}");

                // Test 206: DD XY sequence
                Console.WriteLine("\n[Test 198] dd_xy_sequence");
                var r198 = test_dd_xy_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_xy_sequence = {r198}");

                // Test 207: DD padding interval
                Console.WriteLine("\n[Test 199] dd_padding_interval");
                var r199 = test_dd_padding_interval.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_padding_interval = {r199}");

                // Test 208: DD validate sequence
                Console.WriteLine("\n[Test 200] dd_validate_sequence");
                var r200 = test_dd_validate_sequence.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_validate_sequence = {r200}");

                // Test 209: Readout calibration
                Console.WriteLine("\n[Test 201] readout_calibration");
                var r201 = test_readout_calibration.Run(sim, 0).Result;
                Console.WriteLine($"  test_readout_calibration = {r201}");

                // Test 210: Readout correct
                Console.WriteLine("\n[Test 202] readout_correct");
                var r202 = test_readout_correct.Run(sim, 0).Result;
                Console.WriteLine($"  test_readout_correct = {r202}");

                // Test 211: DD fidelity improvement
                Console.WriteLine("\n[Test 203] dd_fidelity_improvement");
                var r203 = test_dd_fidelity_improvement.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_fidelity_improvement = {r203}");

                // Test 212: ZNE verify
                Console.WriteLine("\n[Test 204] zne_verify");
                var r204 = test_zne_verify.Run(sim, 0).Result;
                Console.WriteLine($"  test_zne_verify = {r204}");

                // Test 213: PEC normalize
                Console.WriteLine("\n[Test 205] pec_normalize");
                var r205 = test_pec_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_pec_normalize = {r205}");

                // Test 214: DD pulse timing
                Console.WriteLine("\n[Test 206] dd_pulse_timing");
                var r206 = test_dd_pulse_timing.Run(sim, 0).Result;
                Console.WriteLine($"  test_dd_pulse_timing = {r206}");

                // Test 215: LU is square
                Console.WriteLine("\n[Test 207] lu_is_square");
                var r207 = test_lu_is_square.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_is_square = {r207}");

                // Test 216: LU diagonal nonzero
                Console.WriteLine("\n[Test 208] lu_diagonal_nonzero");
                var r208 = test_lu_diagonal_nonzero.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_diagonal_nonzero = {r208}");

                // Test 217: LU extract L
                Console.WriteLine("\n[Test 209] lu_extract_l");
                var r209 = test_lu_extract_l.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_extract_l = {r209}");

                // Test 218: LU extract U
                Console.WriteLine("\n[Test 210] lu_extract_u");
                var r210 = test_lu_extract_u.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_extract_u = {r210}");

                // Test 219: LU check dims
                Console.WriteLine("\n[Test 211] lu_check_dims");
                var r211 = test_lu_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_check_dims = {r211}");

                // Test 220: LU pivot indices
                Console.WriteLine("\n[Test 212] lu_pivot_indices");
                var r212 = test_lu_pivot_indices.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_pivot_indices = {r212}");

                // Test 221: LU solve
                Console.WriteLine("\n[Test 213] lu_solve");
                var r213 = test_lu_solve.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_solve = {r213}");

                // Test 222: QR check dims
                Console.WriteLine("\n[Test 214] qr_check_dims");
                var r214 = test_qr_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_check_dims = {r214}");

                // Test 223: QR column norms
                Console.WriteLine("\n[Test 215] qr_column_norms");
                var r215 = test_qr_column_norms.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_column_norms = {r215}");

                // Test 224: QR extract R
                Console.WriteLine("\n[Test 216] qr_extract_r");
                var r216 = test_qr_extract_r.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_extract_r = {r216}");

                // Test 225: QR check orthogonal
                Console.WriteLine("\n[Test 217] qr_check_orthogonal");
                var r217 = test_qr_check_orthogonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_check_orthogonal = {r217}");

                // Test 226: QR rank estimate
                Console.WriteLine("\n[Test 218] qr_rank_estimate");
                var r218 = test_qr_rank_estimate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_rank_estimate = {r218}");

                // Test 227: Chol is symmetric
                Console.WriteLine("\n[Test 219] chol_is_symmetric");
                var r219 = test_chol_is_symmetric.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_is_symmetric = {r219}");

                // Test 228: Chol matrix norm
                Console.WriteLine("\n[Test 220] chol_matrix_norm");
                var r220 = test_chol_matrix_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_matrix_norm = {r220}");

                // Test 229: Chol positive diagonal
                Console.WriteLine("\n[Test 221] chol_check_positive_diagonal");
                var r221 = test_chol_check_positive_diagonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_check_positive_diagonal = {r221}");

                // Test 230: Chol LDLT
                Console.WriteLine("\n[Test 222] chol_ldlt");
                var r222 = test_chol_ldlt.Run(sim, 0).Result;
                Console.WriteLine($"  test_chol_ldlt = {r222}");

                // Test 231: Add check dims
                Console.WriteLine("\n[Test 223] add_check_dims");
                var r223 = test_add_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_check_dims = {r223}");

                // Test 232: Add matrix add
                Console.WriteLine("\n[Test 224] add_matrix_add");
                var r224 = test_add_matrix_add.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_matrix_add = {r224}");

                // Test 233: Add matrix subtract
                Console.WriteLine("\n[Test 225] add_matrix_subtract");
                var r225 = test_add_matrix_subtract.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_matrix_subtract = {r225}");

                // Test 234: Add scalar mult
                Console.WriteLine("\n[Test 226] add_scalar_mult");
                var r226 = test_add_scalar_mult.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_scalar_mult = {r226}");

                // Test 235: Add negate
                Console.WriteLine("\n[Test 227] add_negate");
                var r227 = test_add_negate.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_negate = {r227}");

                // Test 236: Add linear combo
                Console.WriteLine("\n[Test 228] add_linear_combo");
                var r228 = test_add_linear_combo.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_linear_combo = {r228}");

                // Test 237: Add Hadamard
                Console.WriteLine("\n[Test 229] add_hadamard");
                var r229 = test_add_hadamard.Run(sim, 0).Result;
                Console.WriteLine($"  test_add_hadamard = {r229}");

                // Test 238: Vnorm L2
                Console.WriteLine("\n[Test 230] vnorm_l2");
                var r230 = test_vnorm_l2.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_l2 = {r230}");

                // Test 239: Vnorm L1
                Console.WriteLine("\n[Test 231] vnorm_l1");
                var r231 = test_vnorm_l1.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_l1 = {r231}");

                // Test 240: Vnorm Linf
                Console.WriteLine("\n[Test 232] vnorm_linf");
                var r232 = test_vnorm_linf.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_linf = {r232}");

                // Test 241: Vnorm ratio
                Console.WriteLine("\n[Test 233] vnorm_ratio");
                var r233 = test_vnorm_ratio.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_ratio = {r233}");

                // Test 242: Vnorm normalize
                Console.WriteLine("\n[Test 234] vnorm_normalize");
                var r234 = test_vnorm_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_normalize = {r234}");

                // Test 243: Vnorm is unit
                Console.WriteLine("\n[Test 235] vnorm_is_unit");
                var r235 = test_vnorm_is_unit.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_is_unit = {r235}");

                // Test 244: Vnorm distance
                Console.WriteLine("\n[Test 236] vnorm_distance");
                var r236 = test_vnorm_distance.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_distance = {r236}");

                // Test 245: IP dot
                Console.WriteLine("\n[Test 237] ip_dot");
                var r237 = test_ip_dot.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_dot = {r237}");

                // Test 246: IP fidelity
                Console.WriteLine("\n[Test 238] ip_fidelity");
                var r238 = test_ip_fidelity.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_fidelity = {r238}");

                // Test 247: IP normalize
                Console.WriteLine("\n[Test 239] ip_normalize");
                var r239 = test_ip_normalize.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_normalize = {r239}");

                // Test 248: IP angle
                Console.WriteLine("\n[Test 240] ip_angle");
                var r240 = test_ip_angle.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_angle = {r240}");

                // Test 249: IP is orthogonal
                Console.WriteLine("\n[Test 241] ip_is_orthogonal");
                var r241 = test_ip_is_orthogonal.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_is_orthogonal = {r241}");

                // Test 250: TK check dims
                Console.WriteLine("\n[Test 242] tk_check_dims");
                var r242 = test_tk_check_dims.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_check_dims = {r242}");

                // Test 251: TK Kronecker
                Console.WriteLine("\n[Test 243] tk_kronecker");
                var r243 = test_tk_kronecker.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_kronecker = {r243}");

                // Test 252: TK vector Kronecker
                Console.WriteLine("\n[Test 244] tk_vector_kronecker");
                var r244 = test_tk_vector_kronecker.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_vector_kronecker = {r244}");

                // Test 253: TK identity
                Console.WriteLine("\n[Test 245] tk_identity");
                var r245 = test_tk_identity.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_identity = {r245}");

                // Test 254: TK Hadamard
                Console.WriteLine("\n[Test 246] tk_hadamard");
                var r246 = test_tk_hadamard.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_hadamard = {r246}");

                // Test 255: TK verify
                Console.WriteLine("\n[Test 247] tk_verify");
                var r247 = test_tk_verify.Run(sim, 0).Result;
                Console.WriteLine($"  test_tk_verify = {r247}");

                // ============ Qubitization Tests ============
                // Test 256: qubitization phases
                Console.WriteLine("\n[Test 248] qubitization_phases");
                var r248 = test_qubitization_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_phases = {r248}");

                // Test 257: qubitization query complexity
                Console.WriteLine("\n[Test 249] qubitization_query_complexity");
                var r249 = test_qubitization_query_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_query_complexity = {r249}");

                // Test 258: qubitization chebyshev
                Console.WriteLine("\n[Test 250] qubitization_chebyshev");
                var r250 = test_qubitization_chebyshev.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_chebyshev = {r250}");

                // Test 259: qubitization compute phases
                Console.WriteLine("\n[Test 251] qubitization_compute_phases");
                var r251 = test_qubitization_compute_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_compute_phases = {r251}");

                // Test 260: qubitization accuracy
                Console.WriteLine("\n[Test 252] qubitization_accuracy");
                var r252 = test_qubitization_accuracy.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_accuracy = {r252}");

                // Test 261: qubitization spectral gap
                Console.WriteLine("\n[Test 253] qubitization_spectral_gap");
                var r253 = test_qubitization_spectral_gap.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_spectral_gap = {r253}");

                // Test 262: qubitization timestep
                Console.WriteLine("\n[Test 254] qubitization_timestep");
                var r254 = test_qubitization_timestep.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_timestep = {r254}");

                // Test 263: qubitization qsp phases
                Console.WriteLine("\n[Test 255] qubitization_qsp_phases");
                var r255 = test_qubitization_qsp_phases.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_qsp_phases = {r255}");

                // Test 264: qubitization estimate queries
                Console.WriteLine("\n[Test 256] qubitization_estimate_queries");
                var r256 = test_qubitization_estimate_queries.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_estimate_queries = {r256}");

                // ============ LCU Optimized Tests ============
                // Test 265: lcu ancilla bits
                Console.WriteLine("\n[Test 257] lcu_ancilla_bits");
                var r257 = test_lcu_ancilla_bits.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_ancilla_bits = {r257}");

                // Test 266: lcu gate count
                Console.WriteLine("\n[Test 258] lcu_gate_count");
                var r258 = test_lcu_gate_count.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_gate_count = {r258}");

                // Test 267: lcu coefficient norm
                Console.WriteLine("\n[Test 259] lcu_coefficient_norm");
                var r259 = test_lcu_coefficient_norm.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_coefficient_norm = {r259}");

                // Test 268: lcu check coeffs
                Console.WriteLine("\n[Test 260] lcu_check_coeffs");
                var r260 = test_lcu_check_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_check_coeffs = {r260}");

                // Test 269: lcu amplitudes
                Console.WriteLine("\n[Test 261] lcu_amplitudes");
                var r261 = test_lcu_amplitudes.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_amplitudes = {r261}");

                // Test 270: lcu success prob
                Console.WriteLine("\n[Test 262] lcu_success_prob");
                var r262 = test_lcu_success_prob.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_success_prob = {r262}");

                // Test 271: lcu is power of two
                Console.WriteLine("\n[Test 263] lcu_is_power_of_two");
                var r263 = test_lcu_is_power_of_two.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_is_power_of_two = {r263}");

                // Test 272: lcu pad coeffs
                Console.WriteLine("\n[Test 264] lcu_pad_coeffs");
                var r264 = test_lcu_pad_coeffs.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_pad_coeffs = {r264}");

                // Test 273: lcu query complexity
                Console.WriteLine("\n[Test 265] lcu_query_complexity");
                var r265 = test_lcu_query_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_query_complexity = {r265}");

                // Test 274: lcu csd angles
                Console.WriteLine("\n[Test 266] lcu_csd_angles");
                var r266 = test_lcu_csd_angles.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_csd_angles = {r266}");

                // ============ Gibbs Tests ============
                // Test 275: gibbs compute beta
                Console.WriteLine("\n[Test 267] gibbs_compute_beta");
                var r267 = test_gibbs_compute_beta.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_compute_beta = {r267}");

                // Test 276: gibbs partition bound
                Console.WriteLine("\n[Test 268] gibbs_partition_bound");
                var r268 = test_gibbs_partition_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_partition_bound = {r268}");

                // Test 277: gibbs spectral gap
                Console.WriteLine("\n[Test 269] gibbs_spectral_gap");
                var r269 = test_gibbs_spectral_gap.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_spectral_gap = {r269}");

                // Test 278: gibbs verify state
                Console.WriteLine("\n[Test 270] gibbs_verify_state");
                var r270 = test_gibbs_verify_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_verify_state = {r270}");

                // Test 279: gibbs free energy
                Console.WriteLine("\n[Test 271] gibbs_free_energy");
                var r271 = test_gibbs_free_energy.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_free_energy = {r271}");

                // Test 280: gibbs estimate temp
                Console.WriteLine("\n[Test 272] gibbs_estimate_temp");
                var r272 = test_gibbs_estimate_temp.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_estimate_temp = {r272}");

                // Test 281: gibbs partition function
                Console.WriteLine("\n[Test 273] gibbs_partition_function");
                var r273 = test_gibbs_partition_function.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_partition_function = {r273}");

                // Test 282: gibbs probabilities
                Console.WriteLine("\n[Test 274] gibbs_probabilities");
                var r274 = test_gibbs_probabilities.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_probabilities = {r274}");

                // Test 283: gibbs valid temp
                Console.WriteLine("\n[Test 275] gibbs_valid_temp");
                var r275 = test_gibbs_valid_temp.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_valid_temp = {r275}");

                // Test 284: gibbs complexity
                Console.WriteLine("\n[Test 276] gibbs_complexity");
                var r276 = test_gibbs_complexity.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_complexity = {r276}");

                // ============ Time-Dependent Tests ============
                // Test 285: timedep discretize steps
                Console.WriteLine("\n[Test 277] timedep_discretize_steps");
                var r277 = test_timedep_discretize_steps.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_discretize_steps = {r277}");

                // Test 286: timedep step size
                Console.WriteLine("\n[Test 278] timedep_step_size");
                var r278 = test_timedep_step_size.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_step_size = {r278}");

                // Test 287: timedep evaluate
                Console.WriteLine("\n[Test 279] timedep_evaluate");
                var r279 = test_timedep_evaluate.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_evaluate = {r279}");

                // Test 288: timedep error bound
                Console.WriteLine("\n[Test 280] timedep_error_bound");
                var r280 = test_timedep_error_bound.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_error_bound = {r280}");

                // Test 289: timedep norm variation
                Console.WriteLine("\n[Test 281] timedep_norm_variation");
                var r281 = test_timedep_norm_variation.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_norm_variation = {r281}");

                // Test 290: timedep verify evolution
                Console.WriteLine("\n[Test 282] timedep_verify_evolution");
                var r282 = test_timedep_verify_evolution.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_verify_evolution = {r282}");

                // Test 291: timedep optimal order
                Console.WriteLine("\n[Test 283] timedep_optimal_order");
                var r283 = test_timedep_optimal_order.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_optimal_order = {r283}");

                // Test 292: timedep query count
                Console.WriteLine("\n[Test 284] timedep_query_count");
                var r284 = test_timedep_query_count.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_query_count = {r284}");

                // ======= New Quantum Operation Tests (285+) =======
                Console.WriteLine("\n[Test 285] test_gmres_apply_matrix");
                var r285 = test_gmres_apply_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_gmres_apply_matrix = {r285}");

                Console.WriteLine("\n[Test 286] test_gmres_apply_givens");
                var r286 = test_gmres_apply_givens.Run(sim, 0).Result;
                Console.WriteLine($"  test_gmres_apply_givens = {r286}");

                Console.WriteLine("\n[Test 287] test_cg_apply_matrix");
                var r287 = test_cg_apply_matrix.Run(sim, 0).Result;
                Console.WriteLine($"  test_cg_apply_matrix = {r287}");

                Console.WriteLine("\n[Test 288] test_gd_step");
                var r288 = test_gd_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_gd_step = {r288}");

                Console.WriteLine("\n[Test 289] test_newton_hessian_diag");
                var r289 = test_newton_hessian_diag.Run(sim, 0).Result;
                Console.WriteLine($"  test_newton_hessian_diag = {r289}");

                Console.WriteLine("\n[Test 290] test_pca_estimate_eigenvalues");
                var r290 = test_pca_estimate_eigenvalues.Run(sim, 0).Result;
                Console.WriteLine($"  test_pca_estimate_eigenvalues = {r290}");

                Console.WriteLine("\n[Test 291] test_ridge_apply_regularized");
                var r291 = test_ridge_apply_regularized.Run(sim, 0).Result;
                Console.WriteLine($"  test_ridge_apply_regularized = {r291}");

                Console.WriteLine("\n[Test 292] test_trisol_forward_substitute");
                var r292 = test_trisol_forward_substitute.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_forward_substitute = {r292}");

                Console.WriteLine("\n[Test 293] test_trisol_backward_substitute");
                var r293 = test_trisol_backward_substitute.Run(sim, 0).Result;
                Console.WriteLine($"  test_trisol_backward_substitute = {r293}");

                // ======= Layer 0 Quantum Tests (294+) =======
                Console.WriteLine("\n[Test 294] test_qubitization_simulate");
                var r294 = test_qubitization_simulate.Run(sim, 0).Result;
                Console.WriteLine($"  test_qubitization_simulate = {r294}");

                Console.WriteLine("\n[Test 295] test_lcu_optimized_prepare");
                var r295 = test_lcu_optimized_prepare.Run(sim, 0).Result;
                Console.WriteLine($"  test_lcu_optimized_prepare = {r295}");

                Console.WriteLine("\n[Test 296] test_gibbs_prepare_state");
                var r296 = test_gibbs_prepare_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_gibbs_prepare_state = {r296}");

                Console.WriteLine("\n[Test 297] test_timedep_simulate_step");
                var r297 = test_timedep_simulate_step.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_simulate_step = {r297}");

                Console.WriteLine("\n[Test 298] test_timedep_simulate");
                var r298 = test_timedep_simulate.Run(sim, 0).Result;
                Console.WriteLine($"  test_timedep_simulate = {r298}");

                Console.WriteLine("\n[Test 299] test_ip_swap_test_measure");
                var r299 = test_ip_swap_test_measure.Run(sim, 0).Result;
                Console.WriteLine($"  test_ip_swap_test_measure = {r299}");

                Console.WriteLine("\n[Test 300] test_vnorm_measure_state");
                var r300 = test_vnorm_measure_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_vnorm_measure_state = {r300}");

                Console.WriteLine("\n[Test 301] test_ge_parameter_shift");
                var r301 = test_ge_parameter_shift.Run(sim, 0).Result;
                Console.WriteLine($"  test_ge_parameter_shift = {r301}");

                Console.WriteLine("\n[Test 302] test_lu_solve_quantum");
                var r302 = test_lu_solve_quantum.Run(sim, 0).Result;
                Console.WriteLine($"  test_lu_solve_quantum = {r302}");

                Console.WriteLine("\n[Test 303] test_cholesky_solve_quantum");
                var r303 = test_cholesky_solve_quantum.Run(sim, 0).Result;
                Console.WriteLine($"  test_cholesky_solve_quantum = {r303}");

                Console.WriteLine("\n[Test 304] test_qr_least_squares_quantum");
                var r304 = test_qr_least_squares_quantum.Run(sim, 0).Result;
                Console.WriteLine($"  test_qr_least_squares_quantum = {r304}");

                Console.WriteLine("\n[Test 305] test_matrix_add_block_encode");
                var r305 = test_matrix_add_block_encode.Run(sim, 0).Result;
                Console.WriteLine($"  test_matrix_add_block_encode = {r305}");

                Console.WriteLine("\n[Test 306] test_kronecker_apply_state");
                var r306 = test_kronecker_apply_state.Run(sim, 0).Result;
                Console.WriteLine($"  test_kronecker_apply_state = {r306}");

                Console.WriteLine("\n[Test 307] test_em_zne_execute");
                var r307 = test_em_zne_execute.Run(sim, 0).Result;
                Console.WriteLine($"  test_em_zne_execute = {r307}");

                Console.WriteLine("\n[Test 308] test_kernel_compute_matrix_quantum");
                var r308 = test_kernel_compute_matrix_quantum.Run(sim, 0).Result;
                Console.WriteLine($"  test_kernel_compute_matrix_quantum = {r308}");
            }
            Console.WriteLine("\n=== All tests completed ===");
        }
    }
}