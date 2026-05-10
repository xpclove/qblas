namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // ============================================================
    // Quantum arithmetic operations
    // Reference: Quantum Algorithms for Scientific Computing and Approximate Optimization (2018)
    // ============================================================

    // Integer reciprocal computation: computes 1/w for quantum registers
    operation q_math_reciprocal_int(w : Qubit[], x : Qubit[]) : Unit {
        body {
            let n = Length(w);
            let b = Length(x);
            CNOT(w[n - 1], x[b - 1]);
            for (i in 2 .. b) {
                X(x[b - i + 1]);
                CCNOT(w[n - 1], x[b - i + 1], x[b - i]);
                X(x[b - i + 1]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}