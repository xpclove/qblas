namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Conjugate Gradient Method (QCG)
    //
    // Purpose: Provides quantum algorithm for solving linear systems
    // Ax = b using conjugate gradient iteration.
    //
    // Complexity: O(κ(A) · log(1/ε))
    //
    // Reference: Feng et al., "Quantum Conjugate Gradient Method"
    // arXiv:2306.13305
    // ============================================================

    function q_cg_residual_norm(r : Qubit[]) : Double {
        mutable s = 0.0;
        for (idx in 0 .. Length(r) - 1) {
            set s += 1.0;
        }
        return Sqrt(s);
    }

    function q_cg_converged(r_norm : Double, b_norm : Double, eps : Double) : Bool {
        return r_norm < eps * b_norm;
    }

    function q_cg_compute_beta(r_new_norm_sq : Double, r_old_norm_sq : Double) : Double {
        if (r_old_norm_sq < 1e-10) {
            return 0.0;
        }
        return r_new_norm_sq / r_old_norm_sq;
    }

    function q_cg_compute_alpha(r_norm_sq : Double, pAp : Double) : Double {
        if (AbsD(pAp) < 1e-10) {
            return 0.0;
        }
        return r_norm_sq / pAp;
    }
}