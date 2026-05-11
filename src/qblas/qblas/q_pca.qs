namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum PCA (QPCA)
    //
    // Reference: Lerer et al., "Quantum PCA" arXiv:2208.07125
    // ============================================================

    function q_pca_eigenvalue_norm(eigenvalues : Double[]) : Double {
        mutable s = 0.0;
        for (lambda in eigenvalues) {
            set s += AbsD(lambda);
        }
        return s;
    }

    function q_pca_explained_var(eigenvalues : Double[]) : Double[] {
        let total = q_pca_eigenvalue_norm(eigenvalues);
        mutable ratios = [];
        for (lambda in eigenvalues) {
            let ratio = (total > 1e-10) ? lambda / total | 0.0;
            set ratios += [ratio];
        }
        return ratios;
    }

    function q_pca_projection_matrix(k : Int, eigenvalues : Double[], threshold : Double) : Double[][] {
        let n = Length(eigenvalues);
        mutable P = [];
        for (i in 0 .. n - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                if (i == j and i < k and eigenvalues[i] > threshold) {
                    set row += [1.0];
                } else {
                    set row += [0.0];
                }
            }
            set P += [row];
        }
        return P;
    }
}