namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;
    import Std.Convert.*;

    // ============================================================
    // Quantum state preparation
    // ============================================================

//
// Reference: Long & Sun, "Efficient Quantum State Preparation"
// Phys. Rev. A 64, 014303 (2001).
// Amplitude encoding: Schuld & Petruccione, "Supervised Learning with
// Quantum Computers" Springer (2018), Chapter 4.
// ============================================================

    // Prepare computational basis state |k>
    operation q_vector_prepare_basis(k : Int, qs : Qubit[]) : Unit is Adj + Ctl {
        for i in 0 .. Length(qs) - 1 {
            if (((k >>> i) &&& 1) == 1) {
                X(qs[i]);
            }
        }
    }

    // Uniform superposition state preparation
    operation q_vector_prepare_uniform(qs : Qubit[]) : Unit is Adj + Ctl {
        for q in qs {
            H(q);
        }
    }

    // ============================================================
    // Quantum RAM (QRAM) operations
    // ============================================================

    // Load classical data into QRAM superposition
    operation q_vector_qram_load(data : Double[], qs_address : Qubit[], qs_data : Qubit[]) : Unit is Adj + Ctl {
        let n = Length(qs_address);
        let N = 2 ^ n;
        let nData = Length(data);
        let norm = Sqrt(1.0 / SquaredNorm(data));
        for i in 0 .. nData - 1 {
            let value = Floor(data[i] * norm);
            q_ram_addressing(qs_address, i);
            for j in 0 .. Length(qs_data) - 1 {
                if (((value >>> j) &&& 1) == 1) {
                    (Controlled X)(qs_address, qs_data[j]);
                }
            }
            (Adjoint q_ram_addressing)(qs_address, i);
        }
    }

    // Store quantum data back to classical array
    operation q_vector_qram_store(data : Double[], qs_address : Qubit[], qs_data : Qubit[]) : Unit is Adj + Ctl {
        let n = Length(qs_address);
        let nData = Length(data);
        for i in 0 .. nData - 1 {
            q_ram_addressing(qs_address, i);
            for j in 0 .. Length(qs_data) - 1 {
                let bit = (data[i] > 0.5) ? 1 | 0;
                if (bit == 1) {
                    (Controlled X)(qs_address, qs_data[j]);
                }
            }
            (Adjoint q_ram_addressing)(qs_address, i);
        }
    }

    // ============================================================
    // Amplitude encoding and measurement
    // ============================================================

    // Encode real vector as quantum amplitudes (amplitude encoding)
    // Uses rotation-based encoding instead of PrepareArbitraryState
    operation q_vector_amplitude_encode(data : Double[], qs : Qubit[]) : Unit is Adj + Ctl {
        let n = Length(qs);
        let nData = Length(data);
        // Normalize and encode using rotations
        let norm = Sqrt(SquaredNorm(data));
        for i in 0 .. nData - 1 {
            let theta = ArcSin(data[i] / norm);
            if (i < Length(qs)) {
                Ry(theta, qs[i]);
            }
        }
    }

    // Measure qubits and return basis state index
    operation q_vector_measure_state(qs : Qubit[]) : Int {
        mutable result = 0;
        for i in 0 .. Length(qs) - 1 {
            let m = M(qs[i]);
            if (m == One) {
                set result = result + (1 <<< i);
            }
        }
        return result;
    }

    // ============================================================
    // Inner product and distance
    // ============================================================

    // Compute inner product between two quantum states using SWAP test
    operation q_vector_inner_product(qs_a : Qubit[], qs_b : Qubit[]) : Double {
        let n = Length(qs_a);
        use anc = Qubit();
        H(anc);
        for i in 0 .. n - 1 {
            (Controlled SWAP)([anc], (qs_a[i], qs_b[i]));
        }
        H(anc);
        let m = M(anc);
        if (m == One) {
            return 1.0;
        } else {
            return -1.0;
        }
    }

    // Euclidean distance between two quantum states
    operation q_vector_distance(qs_a : Qubit[], qs_b : Qubit[]) : Double {
        let n = Length(qs_a);
        use anc = Qubit();
        mutable sum = 0.0;
        for i in 0 .. n - 1 {
            H(anc);
            (Controlled SWAP)([anc], (qs_a[i], qs_b[i]));
            H(anc);
            let m = M(anc);
            if (m == Zero) {
                set sum = sum + 1.0;
            } else {
                set sum = sum - 1.0;
            }
            Reset(anc);
        }
        return sum / IntAsDouble(n);
    }
}