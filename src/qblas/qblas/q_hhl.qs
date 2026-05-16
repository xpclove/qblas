namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // HHL Algorithm for solving linear systems
    // ============================================================

//
// Reference: Harrow, Hassidim & Lloyd, "Quantum Algorithm for Linear Systems
// of Equations" Phys. Rev. Lett. 103, 150502 (2009).
// https://arxiv.org/abs/0811.3171
// ============================================================

    // Rotation to 1/lambda eigenstate: qs_r rotates to 1/lambda |1> + (1-1/lambda) |0>
    // ============================================================
    // HHL Algorithm for Linear Systems of Equations
    //
    // Solves Ax = b for Hermitian matrix A using quantum phase estimation
    // followed by eigenvalue-dependent rotation and inverse QPE.
    //
    // Operations:
    //   q_hhl_rotation_lamda_rcp: Rotation angle 1/lambda for controlled rotation
    //   q_hhl_core: Core HHL: QPE + eigenvalue rotation + inverse QPE
    //   q_hhl: Full HHL algorithm returning measurement result
    //   q_hhl_until_OK: Repeat-until-success variant
    //
    // Complexity: O(kappa^2 log(N) / epsilon) for condition number kappa
    //
    // Reference: Harrow, Hassidim & Lloyd, Phys. Rev. Lett. 103, 150502 (2009)

    operation q_hhl_rotation_lamda_rcp(qs_phase : Qubit[], qs_r : Qubit) : Unit is Adj + Ctl {
        let nbit = Length(qs_phase);
        let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ nbit) - 1);
        q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div);
    }

    // Core HHL: QPE + eigenvalue rotation + inverse QPE
    operation q_hhl_core(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        q_phase_estimate_core(U_A, qs_u, qs_phase);
        q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
        (Adjoint q_phase_estimate_core)(U_A, qs_u, qs_phase);
    }

    // Full HHL: runs algorithm and returns measurement result of rotation qubit
    operation q_hhl(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_r : Qubit, nbit_phase : Int) : Result {
        use qs_phase = Qubit[nbit_phase];
        q_hhl_core(U_A, qs_u, qs_phase, qs_r);
        ResetAll(qs_phase);
        return M(qs_r);
    }

    // HHL with repeat-until-success: keeps running until rotation succeeds
    operation q_hhl_until_OK(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, prepare_oracle : (Qubit[] => Unit), qs_u : Qubit[], qs_r : Qubit, nbit_phase : Int) : Unit {
        use qs_phase = Qubit[nbit_phase];
        mutable result = Zero;
        repeat {
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