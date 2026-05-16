namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;
    import Std.Convert.*;

    // ============================================================
    // SWAP test and related distance/inner product estimation
    // ============================================================

    // Core SWAP test: estimates overlap between two quantum states
    // control: ancilla qubit, u/v: quantum states to compare
    operation q_swap_test_core(control : Qubit, u : Qubit[], v : Qubit[]) : Unit is Adj + Ctl {
        let nbit = Length(u);
        H(control);
        for i in 0 .. nbit - 1 {
            (Controlled SWAP)([control], (u[i], v[i]));
        }
        H(control);
    }

    // Estimate inner product <u|v> using SWAP test
    operation q_swap_test_inner_product(control : Qubit, u : Qubit[], v : Qubit[], nmeasure : Int) : Double {
        mutable sum = 0.0;
        for _ in 0 .. nmeasure - 1 {
            let m = M(control);
            if (m == Zero) {
                set sum = sum + 1.0;
            }
        }
        return sum / IntAsDouble(nmeasure) * 2.0 - 1.0;
    }

    // Estimate distance between two quantum states
    operation q_swap_test_distance(control : Qubit, u : Qubit[], v : Qubit[], nmeasure : Int) : Double {
        let overlap = q_swap_test_inner_product(control, u, v, nmeasure);
        let dist = ArcCos(overlap);
        return dist;
    }
}