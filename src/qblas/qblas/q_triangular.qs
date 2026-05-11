namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Triangular System Solver (QTRISOL)
    //
    // Reference: Gilyén et al., "Quantum Algebraic Coding"
    // arXiv:2208.07911
    // ============================================================

    function q_trisol_is_triangular(A : Double[][], is_lower : Bool) : Bool {
        let n = Length(A);
        for (i in 0 .. n - 1) {
            for (j in 0 .. n - 1) {
                let valid = is_lower ? (j <= i) | (j >= i);
                if (not valid and AbsD(A[i][j]) > 1e-10) {
                    return false;
                }
            }
        }
        return true;
    }

    function q_trisol_diagonal_nonzero(A : Double[][]) : Bool {
        let n = Length(A);
        for (i in 0 .. n - 1) {
            if (AbsD(A[i][i]) < 1e-10) {
                return false;
            }
        }
        return true;
    }

    function q_trisol_norm(x : Qubit[]) : Double {
        mutable s = 0.0;
        for (idx in 0 .. Length(x) - 1) {
            set s += 1.0;
        }
        return Sqrt(s);
    }
}