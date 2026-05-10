namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open qblas;

    operation test_gemv_diagonal(p : Int) : Double {
        body {
            mutable res = 0.0;
            use qs = Qubit[4];
            let diag = [1.0, 0.5, 0.25, 0.125];
            q_gemv_diagonal(diag, qs);
            ResetAll(qs);
            return res;
        }
    }

    operation test_gemv_iterated(p : Int) : Double {
        body {
            use qs = Qubit[3];
            use qs_work = Qubit[4];
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            q_gemv_iterated(ora, qs, qs_work, PI() / 4.0, 2);
            ResetAll(qs);
            ResetAll(qs_work);
            return 1.0;
        }
    }

    operation test_gemv_batch(p : Int) : Int {
        body {
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
    }

    operation test_gemm_iterated(p : Int) : Double {
        body {
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
    }

    operation test_gemm_block(p : Int) : Double {
        body {
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
    }

    operation test_gemm_diag_general(p : Int) : Double {
        body {
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
    }

    operation test_gemm_transpose_a(p : Int) : Double {
        body {
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
    }

    operation test_gemm_transpose_b(p : Int) : Double {
        body {
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
    }

    operation test_gemm_batch(p : Int) : Int {
        body {
            mutable count = 0;
            for (iter in 0 .. 2) {
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
    }

    operation test_gemm_check_dims(p : Int) : Int {
        body {
            let (m, n, k) = q_gemm_check_dims(4, 4, 4, 4);
            return m;
        }
    }

    operation test_svd_estimate_condition(p : Int) : Double {
        body {
            let singular_values = [1.0, 0.5, 0.25, 0.125];
            let cond = q_svd_estimate_condition(singular_values);
            return cond;
        }
    }

    operation test_svd_sort_descending(p : Int) : Int {
        body {
            let values = [0.25, 1.0, 0.5, 0.125];
            let sorted = q_svd_sort_descending(values);
            return 1;
        }
    }

    operation test_svd_filter(p : Int) : Int {
        body {
            let values = [1.0, 0.5, 0.25, 0.125];
            let filtered = q_svd_filter(values, 0.3);
            return Length(filtered);
        }
    }

    operation test_svd_normalize(p : Int) : Int {
        body {
            let values = [1.0, 0.5, 0.25, 0.125];
            let normalized = q_svd_normalize(values);
            return Length(normalized);
        }
    }

    operation test_hhl_enhanced_rotation(p : Int) : Double {
        body {
            mutable res = 0.0;
            use qs_phase = Qubit[4];
            use qs_r = Qubit[1];
            q_hhl_enhanced_rotation(qs_phase, qs_r[0], 10.0, 4);
            ResetAll(qs_phase);
            ResetAll(qs_r);
            return res;
        }
    }

    operation test_hhl_filtered(p : Int) : Int {
        body {
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
    }

    operation test_hhl_multiprecision(p : Int) : Double {
        body {
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
    }

    operation test_hhl_check_solution(p : Int) : Int {
        body {
            return 0;
        }
    }
}