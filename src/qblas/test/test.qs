namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;
    open qblas;

    // Test quantum walk - 1-sparse bool matrix
    operation test_qwalk_bool(s : Int) : Int {
        mutable res = 0;
        { use qs = Qubit[3];
            let m = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
            q_walk_simulation_matrix_1_sparse_bool(m, qs, PI() / 4.0);
            for i in 0 .. 2 {
                if (M(qs[i]) == One) { set res = res + (2 ^ i); }
            }
            ResetAll(qs);
        }
        return res;
    }

    // Test QFT
    operation test_qft(s : Int) : Int {
        mutable res = 0;
        { use qs = Qubit[4];
            X(qs[0]);
            X(qs[1]);
            q_fft(qs);
            for i in 0 .. 3 {
                if (M(qs[i]) == One) { set res = res + (2 ^ i); }
            }
            ResetAll(qs);
        }
        return res;
    }

    // Test teleportation dense coding
    operation test_qs_tele(snd : Int) : Int {
        mutable rec = q_tele_dense_coding_1(snd);
        return rec;
    }
}