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
            }
            Console.WriteLine("\n=== All tests completed ===");
        }
    }
}