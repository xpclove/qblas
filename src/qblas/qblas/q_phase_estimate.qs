namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // ============================================================
    // Quantum Phase Estimation (QPE)
    // ============================================================

    // Core QPE: estimates phase of unitary U_A applied to state qs_u
    // qs_phase: LittleEndian register for phase bits
    // U_A: callable representing unitary operation
    operation q_phase_estimate_core(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[]) : Unit {
        body {
            let nbit = Length(qs_phase);
            // Hadamard on all phase qubits
            for (i in 0 .. nbit - 1) {
                H(qs_phase[i]);
            }
            // Controlled unitary applications
            for (i in 0 .. nbit - 1) {
                let n = 2 ^ i;
                (Controlled U_A)([qs_phase[i]], (n, qs_u));
            }
            // Inverse QFT to extract phase
            (Adjoint q_fft)(qs_phase);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Full QPE: runs QPE and returns phase qubits for measurement
    operation q_phase_estimate(U : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[]) : Unit {
        body {
            q_phase_estimate_core(U, qs_u, qs_phase);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}