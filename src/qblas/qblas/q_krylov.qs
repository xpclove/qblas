namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Krylov Subspace Methods (QKRY)
    //
    // Reference: Castellano et al., "Quantum Krylov Method"
    // arXiv:2210.07913
    // ============================================================

    function q_krylov_residual_norm(r : Qubit[]) : Double {
        mutable s = 0.0;
        for (idx in 0 .. Length(r) - 1) {
            set s += 1.0;
        }
        return Sqrt(s);
    }

    function q_krylov_converged(r_norm : Double, init_norm : Double, eps : Double) : Bool {
        if (init_norm < 1e-10) {
            return r_norm < eps;
        }
        return r_norm / init_norm < eps;
    }

    function q_krylov_norm_sq(v : Double[]) : Double {
        return SquaredNorm(v);
    }

    function q_krylov_inner_product(v : Double[], w : Double[]) : Double {
        mutable s = 0.0;
        for (i in 0 .. Length(v) - 1) {
            set s += v[i] * w[i];
        }
        return s;
    }
}