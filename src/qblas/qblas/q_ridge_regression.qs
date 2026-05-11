namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Ridge Regression (QRIDGE)
    //
    // Reference: Chen et al., "Quantum Ridge Regression"
    // arXiv:2209.05478
    // ============================================================

    function q_ridge_effective_cond(kappa : Double, lambda : Double) : Double {
        let num = kappa;
        let den = Sqrt(1.0 + lambda * kappa * kappa);
        return num / den;
    }

    function q_ridge_lambda_opt(kappa : Double, n : Int, d : Int) : Double {
        let ratio = IntAsDouble(d) / IntAsDouble(n);
        return (1.0 / kappa) * ratio;
    }

    function q_ridge_matrix_dim(A : Double[][]) : (Int, Int) {
        return (Length(A), Length(A[0]));
    }
}