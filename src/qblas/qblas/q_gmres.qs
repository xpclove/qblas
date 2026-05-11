namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum GMRES (QGMRES)
    //
    // Reference: Ye & Li, "Quantum GMRES" arXiv:2211.15082
    // ============================================================

    function q_gmres_norm(r : Qubit[]) : Double {
        mutable s = 0.0;
        for (idx in 0 .. Length(r) - 1) {
            set s += 1.0;
        }
        return Sqrt(s);
    }

    function q_gmres_converged(r_norm : Double, init_norm : Double, eps : Double) : Bool {
        if (init_norm < 1e-10) {
            return r_norm < eps;
        }
        return r_norm / init_norm < eps;
    }

    function q_gmres_hessenberg_size(m : Int) : (Int, Int) {
        return (m + 1, m);
    }

    function q_gmres_init_vec(r0 : Qubit[]) : Qubit[] {
        return r0;
    }
}