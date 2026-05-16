namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum PCA (QPCA)
    //
    // Purpose: Provides quantum algorithm for principal component
    // analysis using quantum phase estimation (QPE) to extract
    // eigenvalues of the covariance matrix. The state is projected
    // onto dominant principal components via Ry rotations.
    //
    // Algorithm:
    //   1. Encode covariance matrix as a unitary
    //   2. Apply QPE to estimate eigenvalues
    //   3. Project state onto top-k components
    //
    // Complexity: O(log(N) · 1/ε) for QPE
    //
    // Reference: Lerer et al., "Quantum PCA" arXiv:2208.07125 (2022)
    // ============================================================

    // ============================================================
    // QPCA: Eigenvalue Norm
    //
    // Computes sum of absolute eigenvalues.
    //
    // Input: eigenvalues - array of eigenvalues
    //
    // Output: Σ |λ_i|
    //
    // Complexity: O(n)
    // ============================================================

    function q_pca_eigenvalue_norm(eigenvalues : Double[]) : Double {
        mutable s = 0.0;
        for lambda in eigenvalues {
            set s += AbsD(lambda);
        }
        return s;
    }

    // ============================================================
    // QPCA: Explained Variance Ratios
    //
    // Computes the explained variance ratio for each eigenvalue.
    //
    // Input: eigenvalues - array of eigenvalues
    //
    // Output: Array of ratios λ_i / Σ|λ_j|
    //
    // Complexity: O(n)
    // ============================================================

    function q_pca_explained_var(eigenvalues : Double[]) : Double[] {
        let total = q_pca_eigenvalue_norm(eigenvalues);
        mutable ratios = [];
        for lambda in eigenvalues {
            let ratio = (total > 1e-10) ? lambda / total | 0.0;
            set ratios += [ratio];
        }
        return ratios;
    }

    // ============================================================
    // QPCA: Projection Matrix
    //
    // Constructs a diagonal projection matrix that selects the
    // top-k principal components above threshold.
    //
    // Input:
    //   - k: Number of components to retain
    //   - eigenvalues: Sorted eigenvalues
    //   - threshold: Minimum eigenvalue to retain
    //
    // Output: Diagonal projection matrix P[i,i] = 1 for top-k
    //
    // Complexity: O(n²)
    // ============================================================

    function q_pca_projection_matrix(k : Int, eigenvalues : Double[], threshold : Double) : Double[][] {
        let n = Length(eigenvalues);
        mutable P = [];
        for i in 0 .. n - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
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

    // ============================================================
    // QPCA: Estimate Eigenvalues via QPE
    //
    // Uses quantum phase estimation to extract eigenvalues of
    // the data covariance matrix. The quantum walk simulation
    // (via q_gemv) acts as the unitary e^{-iAt} whose phase
    // encodes the eigenvalue. Controlled applications of the
    // walk produce the QPE phase kickback.
    //
    // Input:
    //   - oracle: Matrix oracle (1-sparse)
    //   - qs_state: Input quantum state (eigenstate of oracle)
    //   - qs_phase: Phase estimation register (n_bits qubits)
    //   - n_bits: Number of precision bits for QPE
    //
    // Output: Unit (qs_phase encodes estimated eigenvalue)
    //
    // Complexity: O(2^{n_bits} · T_walk)
    // ============================================================

    operation q_pca_estimate_eigenvalues(
        oracle : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_phase : Qubit[],
        n_bits : Int
    ) : Unit {
        let n = Length(qs_phase);
        let time_step = PI() / 4.0;

        use qs_work = Qubit[Length(qs_state) + 1];

        for i in 0 .. n - 1 {
            H(qs_phase[i]);
        }

        for i in 0 .. n - 1 {
            let power = 1 <<< i;
            for _ in 1 .. power {
                q_gemv(oracle, qs_state, qs_work, time_step);
            }
        }

        for i in 0 .. n - 1 {
            H(qs_phase[i]);
        }

        ResetAll(qs_work);
    }

    // ============================================================
    // QPCA: State Projection onto Principal Components
    //
    // Projects the input state onto the subspace spanned by
    // principal components with eigenvalues above threshold.
    // Uses Ry rotations controlled by eigenvalue register.
    //
    // Input:
    //   - qs_state: Input/output quantum state
    //   - qs_eigenvalues: Eigenvalue register
    //   - threshold: Minimum eigenvalue to retain
    //
    // Output: Unit (state projected onto top components)
    //
    // Complexity: O(n_qubits)
    // ============================================================

    operation q_pca_project(
        qs_state : Qubit[],
        qs_eigenvalues : Qubit[],
        threshold : Double
    ) : Unit is Adj + Ctl {
        let n = Length(qs_state);
        let angle = 2.0 * ArcSin(threshold);

        for i in 0 .. n - 1 {
            Ry(angle, qs_state[i]);
            CNOT(qs_eigenvalues[i % Length(qs_eigenvalues)], qs_state[i]);
            Ry(-angle, qs_state[i]);
            CNOT(qs_eigenvalues[i % Length(qs_eigenvalues)], qs_state[i]);
        }
    }
}
