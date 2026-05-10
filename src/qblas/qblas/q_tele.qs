namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;

    // ============================================================
    // Quantum teleportation and dense coding
    // ============================================================

    // Create Bell state ( maximally entangled pair )
    operation q_bell_state_creat(qs : Qubit[]) : Unit {
        body {
            H(qs[1]);
            CNOT(qs[1], qs[0]);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Teleport a single qubit from sender to receiver using Bell pairs
    operation q_tele_qubit_1(qs_snd : Qubit, qs_rec : Qubit) : Unit {
        body {
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

            // Bob's correction based on Alice's measurement results
            (Adjoint q_bell_state_creat)([qs_bob, qs_rec]);
            if (res == 0) { I(qs_rec); }
            elif (res == 1) { I(qs_rec); }
            elif (res == 2) { I(qs_rec); }
            elif (res == 3) { I(qs_rec); }
            ResetAll(qs_bell);
        }
    }

    // Dense coding: encode 2 classical bits into one quantum qubit using Bell pair
    operation q_tele_dense_coding_1(snd : Int) : Int {
        body {
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
            for (i in 0 .. 1) {
                let r = M(qs_tmp[i]);
                if (r == One) { set rec = rec + (2 ^ i); }
            }
            ResetAll(qs_tmp);
            return rec;
        }
    }
}