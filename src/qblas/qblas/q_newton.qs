namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Newton Method (QNEWTON)
    //
    // Reference: Liu et al., "Quantum Newton Method"
    // arXiv:2112.01803
    // ============================================================

    function q_newton_norm(v : Double[]) : Double {
        return Sqrt(SquaredNorm(v));
    }

    function q_newton_converged(gradient : Double[], delta : Double[], eps : Double) : Bool {
        let g_norm = q_newton_norm(gradient);
        let d_norm = q_newton_norm(delta);
        return g_norm < eps or d_norm < eps;
    }
}