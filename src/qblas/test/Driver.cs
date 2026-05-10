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
            }
            Console.WriteLine("\n=== All tests completed ===");
        }
    }
}