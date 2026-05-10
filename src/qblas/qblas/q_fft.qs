namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;

    // ============================================================
    // Quantum Fourier Transform (QFT)
    // ============================================================

    // Core QFT: performs Fourier transform on qubit register
    // Input qubits are in LittleEndian format
    operation q_fft_core(qs : Qubit[]) : Unit {
        body {
            let nbit = Length(qs);
            for (i in nbit - 1 .. -1 .. 0) {
                H(qs[i]);
                for (j in i - 1 .. -1 .. 0) {
                    let n = i - j + 1;
                    let k = 2;
                    (Controlled R1Frac)([qs[j]], (k, n, qs[i]));
                }
            }
            q_com_swap_all(qs);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Full QFT operation
    operation q_fft(qs : Qubit[]) : Unit {
        body {
            q_fft_core(qs);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Inverse QFT
    operation q_fft_adjoint(qs : Qubit[]) : Unit {
        body {
            Adjoint q_fft_core(qs);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}