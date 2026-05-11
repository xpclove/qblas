namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Gradient Descent (QGD)
    //
    // Reference: Rebentrost et al., "Quantum Gradient Descent"
    // arXiv:1807.04431
    // ============================================================

    function q_gd_norm(g : Double[]) : Double {
        return Sqrt(SquaredNorm(g));
    }

    function q_gd_converged(gradient : Double[], eps : Double) : Bool {
        return q_gd_norm(gradient) < eps;
    }

    function q_gd_norm_sq(v : Double[]) : Double {
        return SquaredNorm(v);
    }
}