namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;

    // ============================================================
    // Quantum teleportation and dense coding
    // ============================================================

//
// Reference: Bennett et al., "Teleporting an Unknown Quantum State via Dual
// Classical and Einstein-Podolsky-Rosen Channels"
// Phys. Rev. Lett. 70, 1895 (1993).
// https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.70.1895
// ============================================================

    // Create Bell state ( maximally entangled pair )
    operation q_bell_state_creat(qs : Qubit[]) : Unit is Adj + Ctl {
        H(qs[1]);
        CNOT(qs[1], qs[0]);
    }

    // Teleport a single qubit from sender to receiver using Bell pairs
    operation q_tele_qubit_1(qs_snd : Qubit, qs_rec : Qubit) : Unit {
        use qs_bell = Qubit[2];
        ResetAll(qs_bell);
        // Initialize Bell pair
        X(qs_bell[0]);
        X(qs_bell[1]);
        q_bell_state_creat(qs_bell);
        let qs_alice = qs_bell[1];
        let qs_bob = qs_bell[0];

        // Alice's Bell measurement
        (Adjoint q_bell_state_creat)([qs_alice, qs_snd]);
        let a_0 = M(qs_alice);
        let a_1 = M(qs_snd);
        mutable res = 0;
        if (a_0 == One) { set res = res + 1; }
        if (a_1 == One) { set res = res + 2; }

        // Bob's Pauli correction based on Alice's measurement results.
        // For |Ψ⁻⟩ Bell state (|01⟩ - |10⟩)/√2, the correction mapping is:
        //   a_0 a_1 = 00 (res=0): I    - state already correct
        //   a_0 a_1 = 10 (res=1): Z    - phase flip
        //   a_0 a_1 = 01 (res=2): X    - bit flip
        //   a_0 a_1 = 11 (res=3): Z*X  - both flips
        (Adjoint q_bell_state_creat)([qs_bob, qs_rec]);
        if (res == 0) { I(qs_rec); }
        elif (res == 1) { Z(qs_rec); }
        elif (res == 2) { X(qs_rec); }
        elif (res == 3) { Z(qs_rec); X(qs_rec); }
        ResetAll(qs_bell);
    }

    // Dense coding: encode 2 classical bits into one quantum qubit using Bell pair
    operation q_tele_dense_coding_1(snd : Int) : Int {
        mutable rec = 0;
        use qs_tmp = Qubit[2];
        ResetAll(qs_tmp);
        q_bell_state_creat(qs_tmp);
        let qs_alice = qs_tmp[1];
        let qs_bob = qs_tmp[0];

        // Alice encodes 2 bits into her half of Bell pair
        if (snd == 0) { I(qs_alice); }
        elif (snd == 1) { X(qs_alice); }
        elif (snd == 2) { Z(qs_alice); }
        elif (snd == 3) { Z(qs_alice); X(qs_alice); }

        // Bob decodes by Bell measurement
        (Adjoint q_bell_state_creat)(qs_tmp);
        for i in 0 .. 1 {
            let r = M(qs_tmp[i]);
            if (r == One) { set rec = rec + (2 ^ i); }
        }
        ResetAll(qs_tmp);
        return rec;
    }
}