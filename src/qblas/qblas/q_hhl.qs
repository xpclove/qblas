namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // HHL Algorithm for solving linear systems
    // ============================================================

    // Rotation to 1/lambda eigenstate: qs_r rotates to 1/lambda |1> + (1-1/lambda) |0>
    operation q_hhl_rotation_lamda_rcp(qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            let nbit = Length(qs_phase);
            let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ nbit) - 1);
            q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Core HHL: QPE + eigenvalue rotation + inverse QPE
    operation q_hhl_core(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            q_phase_estimate_core(U_A, qs_u, qs_phase);
            q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
            (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Full HHL: runs algorithm and returns measurement result of rotation qubit
    operation q_hhl(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_r : Qubit, nbit_phase : Int) : Result {
        body {
            use qs_phase = Qubit[nbit_phase];
            q_hhl_core(U_A, qs_u, qs_phase, qs_r);
            ResetAll(qs_phase);
            return M(qs_r);
        }
    }

    // HHL with repeat-until-success: keeps running until rotation succeeds
    operation q_hhl_until_OK(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, prepare_oracle : (Qubit[] => Unit), qs_u : Qubit[], qs_r : Qubit, nbit_phase : Int) : Unit {
        body {
            use qs_phase = Qubit[nbit_phase];
            repeat {
                mutable result = Zero;
                ResetAll(qs_u);
                Reset(qs_r);
                prepare_oracle(qs_u);
                q_hhl_core(U_A, qs_u, qs_phase, qs_r);
                ResetAll(qs_phase);
                set result = M(qs_r);
            } until (result == One)
            fixup {
                ResetAll(qs_phase);
            }
        }
    }
}