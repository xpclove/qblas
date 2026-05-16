namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;

    // ============================================================
    // Quantum Fourier Transform (QFT)
    // ============================================================

    // Core QFT: performs Fourier transform on qubit register
    // Input qubits are in LittleEndian format
    operation q_fft_core(qs : Qubit[]) : Unit is Adj + Ctl {
        let nbit = Length(qs);
        for i in nbit - 1 .. -1 .. 0 {
            H(qs[i]);
            for j in i - 1 .. -1 .. 0 {
                let n = i - j + 1;
                let k = 2;
                (Controlled R1Frac)([qs[j]], (k, n, qs[i]));
            }
        }
        q_com_swap_all(qs);
    }

    // Full QFT operation
    operation q_fft(qs : Qubit[]) : Unit is Adj + Ctl {
        q_fft_core(qs);
    }

    // Inverse QFT
    operation q_fft_adjoint(qs : Qubit[]) : Unit is Adj + Ctl {
        Adjoint q_fft_core(qs);
    }
}