namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    open qblas;

    // U_test: U = exp(i * sigma_z * dt), Rz rotation
    operation U_test(n : Int, qs_u : Qubit[]) : Unit is Adj + Ctl {
        let dt = -1.0;
        let angle = 2.0 * dt * IntAsDouble(n);
        Rz(angle, qs_u[0]);
    }

    // U_hhl: Rx rotation for HHL test
    operation U_hhl(n : Int, u : Qubit[]) : Unit is Adj + Ctl {
        let dt = 3.0;
        let angle = dt * IntAsDouble(n);
        Rx(angle, u[0]);
    }

    // Test phase estimation: U = exp(i * sigma_z * t), |u> = |0>, U|u> = exp(i t)|u>
    operation test_qpe(s : Int) : Double {
        mutable phase = 0.0;
        { use qs = Qubit[11];
            X(qs[0]);
            q_phase_estimate(U_test, [qs[0]], qs[1..10]);
            let phase_base = 2.0 * PI() / IntAsDouble(2 ^ 10);
            mutable result_int = 0;
            for i in 0 .. 9 {
                if (M(qs[1 + i]) == One) {
                    set result_int = result_int + (2 ^ i);
                }
            }
            set phase = IntAsDouble(result_int) * phase_base;
            ResetAll(qs);
        }
        return phase;
    }

    // Test HHL: A|x> = |u>, |x> = A^-1 |u>, |u> = |1>, A = sigma_x
    operation test_hhl(s : Int) : Double {
        mutable res = 0.0;
        { use qs = Qubit[12];
            let qs_u = [qs[0]];
            let qs_r = [qs[1]];
            let qs_phase = qs[2..11];
            X(qs_u[0]);
            q_hhl_core(U_hhl, qs_u, qs_phase, qs_r[0]);
            ResetAll(qs_phase);
            mutable r = 0;
            if (M(qs_r[0]) == One) { set r = 1; }
            mutable result_u = 0;
            if (M(qs_u[0]) == One) { set result_u = 1; }
            set res = IntAsDouble(r);
            ResetAll(qs);
        }
        return res;
    }

    // Test density matrix simulation
    operation test_DM_simulation(p : Int) : Double {
        mutable res = 0.0;
        let N = 1;
        for s in 1..N {
            { use qs = Qubit[20];
                let qs_control = [qs[1]];
                let qs_sigma = [qs[0]];
                mutable qs_rhos : Qubit[][] = [];
                for i in 0..17 {
                    H(qs[2 + i]);
                    set qs_rhos += [[qs[2 + i]]];
                }
                X(qs_control[0]);
                let time = PI() / 3.0;
                q_simulation_C_densitymatrix(qs_control, qs_rhos, qs_sigma, time, 18);
                let r = M(qs_sigma[0]);
                if (r == One) { set res = res + 1.0 / IntAsDouble(N); }
                ResetAll(qs);
            }
        }
        return res;
    }

    operation test_swap_simulation(p : Int) : Double {
        { use qs = Qubit[5];
            let qs_a = qs[0..1];
            let qs_b = qs[2..3];
            let qs_control = [qs[4]];
            X(qs[0]);
            X(qs[1]);
            X(qs_control[0]);
            let time = PI() / 2.0;
            q_simulation_C_swap(qs_control, qs_a, qs_b, time);
            ResetAll(qs);
        }
        return 1.0;
    }

    operation test_1_sparse_bool(p : Int) : Double {
        { use qs = Qubit[3];
            let qs_b = [qs[1]];
            let time = PI() / 4.0;
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            q_walk_simulation_matrix_1_sparse_bool(ora, qs_b, time);
            ResetAll(qs);
        }
        return 1.0;
    }

    operation test_1_sparse_integer(p : Int) : Double {
        { use qs = Qubit[4];
            let qs_b = [qs[1]];
            let time = PI() / 8.0;
            let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_integer_test);
            q_walk_simulation_matrix_1_sparse_integer(ora, qs_b, time);
            ResetAll(qs);
        }
        return 1.0;
    }

    operation test_SwapA(p : Int) : Double {
        mutable res = 0.0;
        let N = 1;
        for j in 1..N {
            { use qs = Qubit[20];
                let ora = q_matrix_1_sparse_oracle(q_matrix_SwapA_test);
                let qs_u = [qs[0]];
                mutable qs_rhos : Qubit[][] = [];
                for i in 0..17 {
                    set qs_rhos += [[qs[1 + i]]];
                }
                let qs_control = [qs[19]];
                X(qs_control[0]);
                let time = PI() / 6.0;
                q_simulation_C_A_type(qs_control, 1, ora, qs_rhos, qs_u, time, 18);
                let r = M(qs_u[0]);
                if (r == One) { set res = res + 1.0 / IntAsDouble(N); }
                ResetAll(qs);
            }
        }
        return res;
    }
}