namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    operation q_rls_ridge(
        oracle_A : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        lambda_reg : Double,
        condition_num : Double,
        precision : Double
    ) : Unit {
        body (...) {
            let effective_cond = condition_num / (1.0 + lambda_reg);
            let epsilon = 1.0 / effective_cond;
            let degree = Floor(Log(1.0 / precision) / Log(2.0 / epsilon));

            mutable coeffs = [];
            let exp_val = 0.5;
            mutable two_k_plus_1 = 0;
            mutable k_plus_1 = 0;
            mutable denom = 0.0;
            mutable ck = 0.0;
            for (k in 0 .. degree) {
                set two_k_plus_1 = 2 * k + 1;
                set k_plus_1 = k + 1;
                set denom = IntAsDouble(two_k_plus_1 * k_plus_1);
                set ck = 2.0 * exp_val / denom;
                set coeffs += [ck];
            }

            q_qsvt_polynomial_transform(oracle_A, qs_state, qs_ancilla, coeffs, precision);
        }
    }

    operation q_rls_weighted(
        oracle_A : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        weights : Double[],
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        lambda_reg : Double,
        precision : Double
    ) : Unit {
        body (...) {
            mutable wnorms = [];
            for (w in weights) {
                mutable w2 = 0.0;
                set w2 = w * w;
                set wnorms += [w2];
            }

            q_qsvt_apply_diagonal(wnorms, qs_ancilla);

            mutable max_w = 0.0;
            mutable min_w = 0.0;
            mutable effective_cond = 0.0;
            set max_w = weights[0];
            set min_w = weights[0];
            set effective_cond = max_w / min_w;

            q_rls_ridge(oracle_A, qs_state, qs_ancilla, lambda_reg, effective_cond, precision);
        }
    }

    operation q_rls_generalized(
        oracle_A : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        oracle_W : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        lambda_reg : Double,
        precision : Double
    ) : Unit {
        body (...) {
            oracle_W(qs_ancilla, qs_state);
            q_rls_ridge(oracle_A, qs_state, qs_ancilla, lambda_reg, 100.0, precision);
            (Adjoint oracle_W)(qs_ancilla, qs_state);
        }
    }

    function q_rls_lambda_cv(
        n_samples : Int,
        condition_number : Double,
        precision : Double
    ) : Double {
        let sigma_max = 1.0;
        let sigma_min = 1.0 / condition_number;
        let lambda_loo = sigma_max * sigma_min * precision;
        return lambda_loo;
    }

    function q_rls_check_lambda(lambda_reg : Double, precision : Double) : Bool {
        return lambda_reg >= precision and lambda_reg <= 1.0 / precision;
    }

    function q_rls_effective_condition(
        cond_A : Double,
        lambda_reg : Double
    ) : Double {
        let sigma_max = 1.0;
        let sigma_min = 1.0 / cond_A;
        let cond_reg = (sigma_max + lambda_reg) / (sigma_min + lambda_reg);
        return cond_reg;
    }

    operation q_rls_iterative_refine(
        oracle_A : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        lambda_reg : Double,
        condition_num : Double,
        n_iter : Int,
        precision : Double
    ) : Unit {
        body (...) {
            for (iter in 0 .. n_iter - 1) {
                q_rls_ridge(oracle_A, qs_state, qs_ancilla, lambda_reg, condition_num, precision);

                mutable improved_lambda = 0.0;
                mutable improved_cond = 0.0;
                set improved_lambda = lambda_reg * (1.0 + precision);
                set improved_cond = condition_num * (1.0 - precision);

                q_rls_ridge(oracle_A, qs_state, qs_ancilla, improved_lambda, improved_cond, precision);
            }
        }
    }

    operation q_rls_preconditioned(
        oracle_P : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        oracle_A : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        lambda_reg : Double,
        precision : Double
    ) : Unit {
        body (...) {
            oracle_P(qs_state, qs_ancilla);
            q_rls_ridge(oracle_A, qs_state, qs_ancilla, lambda_reg, 10.0, precision);
            (Adjoint oracle_P)(qs_state, qs_ancilla);
        }
    }
}