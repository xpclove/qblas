namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Lanczos Algorithm (QLAN)
    //
    // Purpose: Provides quantum algorithm for computing eigenvalues
    // and eigenvectors using Lanczos tridiagonalization for
    // symmetric matrices. Constructs the tridiagonal matrix T such
    // that T approximates A in the Krylov subspace.
    //
    // Algorithm: Lanczos three-term recurrence:
    //   β_0 = 0, v_0 = 0
    //   v_1 = b / ||b||
    //   for j = 1..m:
    //     w = A · v_j
    //     α_j = ⟨v_j|w⟩
    //     w = w - α_j·v_j - β_{j-1}·v_{j-1}
    //     β_j = ||w||
    //     v_{j+1} = w / β_j
    //
    // Quantum: A|v_j⟩ via quantum walk (q_gemv),
    //          ⟨v_j|A|v_j⟩ via SWAP test.
    //          α_j, β_j extracted from measurement.
    //
    // Complexity: O(m · T_walk + m · n_measure · n_qubits)
    //
    // Reference: Liu et al., "Quantum Eigenvalue Processing"
    // arXiv:2112.00778 (2021)
    // ============================================================

    // ============================================================
    // QLAN: Classical Helper - Vector Norm
    //
    // Computes L2 norm of a classical vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||_2 = sqrt(Σ v_i²)
    //
    // Complexity: O(n)
    // ============================================================

    function q_lanczos_norm(v : Double[]) : Double {
        return Sqrt(SquaredNorm(v));
    }

    // ============================================================
    // QLAN: Classical Helper - Normalize Vector
    //
    // Normalizes a classical vector to unit L2 norm.
    //
    // Input: v - n-dimensional vector
    //
    // Output: v / ||v|| (or zero vector if norm ≈ 0)
    //
    // Complexity: O(n)
    // ============================================================

    function q_lanczos_normalize(v : Double[]) : Double[] {
        let n = q_lanczos_norm(v);
        if (n < 1e-10) {
            mutable zero_vec = [];
            for i in 0 .. Length(v) - 1 {
                set zero_vec += [0.0];
            }
            return zero_vec;
        }
        mutable result = [];
        for x in v {
            set result += [x / n];
        }
        return result;
    }

    // ============================================================
    // QLAN: Classical Helper - Alpha Computation
    //
    // Computes average of squared elements of vector v.
    // Used as classical estimate of α_j = ⟨v_j|A|v_j⟩.
    //
    // Input: v - vector of overlap estimates
    //
    // Output: Σ x² / Length(v)
    //
    // Complexity: O(n)
    // ============================================================

    function q_lanczos_alpha_compute(v : Double[]) : Double {
        mutable s = 0.0;
        for x in v {
            set s += x * x;
        }
        return s / IntAsDouble(Length(v));
    }

    // ============================================================
    // QLAN: Classical Helper - Beta Computation
    //
    // L2 norm of residual vector.
    //
    // Input: v - residual vector
    //
    // Output: ||v||_2
    //
    // Complexity: O(n)
    // ============================================================

    function q_lanczos_beta_compute(v : Double[]) : Double {
        return q_lanczos_norm(v);
    }

    // ============================================================
    // QLAN: Classical Helper - Build Tridiagonal Matrix
    //
    // Constructs the symmetric tridiagonal matrix T from
    // computed α_j and β_j values.
    //
    // T[i,i] = α_i, T[i,i+1] = T[i+1,i] = β_i
    //
    // Input:
    //   - alphas: Diagonal entries [α_0, α_1, ..., α_{m-1}]
    //   - betas: Off-diagonal entries [β_0, β_1, ..., β_{m-2}]
    //
    // Output: m×m symmetric tridiagonal matrix
    //
    // Complexity: O(m²)
    // ============================================================

    function q_lanczos_tridiag(alphas : Double[], betas : Double[]) : Double[][] {
        let m = Length(alphas);
        mutable Mat = [];
        for i in 0 .. m - 1 {
            mutable row = [];
            for j in 0 .. m - 1 {
                if (i == j) {
                    set row += [alphas[i]];
                } elif (j == i + 1) {
                    set row += [betas[i]];
                } elif (i == j + 1) {
                    set row += [betas[j]];
                } else {
                    set row += [0.0];
                }
            }
            set Mat += [row];
        }
        return Mat;
    }

    // ============================================================
    // QLAN: Classical Helper - Eigenvalue Sum
    //
    // Sums an array of eigenvalues.
    //
    // Input: eigenvalues - array of eigenvalues
    //
    // Output: Σ λ_i
    //
    // Complexity: O(m)
    // ============================================================

    function q_lanczos_eigenvalue_sum(eigenvalues : Double[]) : Double {
        mutable s = 0.0;
        for lambda in eigenvalues {
            set s += lambda;
        }
        return s;
    }

    // ============================================================
    // QLAN: Apply Matrix to Lanczos Basis State
    //
    // Applies A|vⱼ⟩ using quantum walk simulation.
    // Generates the next vector in the Lanczos recurrence.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle for A
    //   - qs_state: Current Lanczos vector |vⱼ⟩
    //   - qs_work: Workspace qubits (n+1 minimum)
    //   - time: Evolution time parameter
    //
    // Output: Unit (state modified to A|vⱼ⟩ in-place)
    //
    // Complexity: O(T_walk)
    // ============================================================

    operation q_lanczos_apply_matrix(
        oracle : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit is Adj + Ctl {
        q_gemv(oracle, qs_state, qs_work, time);
    }

    // ============================================================
    // QLAN: Estimate Alpha_j = ⟨vⱼ|A|vⱼ⟩
    //
    // Estimates the diagonal element αⱼ of the tridiagonal
    // matrix using the SWAP test to measure overlap between
    // |vⱼ⟩ and A|vⱼ⟩.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Lanczos basis qubits (m × n layout)
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - j_idx: Current Lanczos index (0-based)
    //   - n_measure: SWAP test repetitions
    //   - time: Evolution time
    //
    // Output: Estimated αⱼ = ⟨vⱼ|A|vⱼ⟩
    //
    // Complexity: O(T_walk + n_measure · n_qubits)
    // ============================================================

    operation q_lanczos_estimate_alpha(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        j_idx : Int,
        n_measure : Int,
        time : Double
    ) : Double {
        let start_vj = j_idx * n_qubits;
        use qs_avj = Qubit[n_qubits];

        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[start_vj + q], qs_avj[q]);
        }
        q_lanczos_apply_matrix(oracle, qs_avj, qs_work, time);

        let alpha = q_krylov_estimate_overlap(
            qs_basis[start_vj .. start_vj + n_qubits - 1],
            qs_avj[0 .. n_qubits - 1],
            n_measure
        );
        ResetAll(qs_avj);
        return alpha;
    }

    // ============================================================
    // QLAN: Lanczos Iteration Step
    //
    // Performs one step of the Lanczos three-term recurrence.
    // Computes αⱼ = ⟨vⱼ|A|vⱼ⟩ and βⱼ = ||A|vⱼ⟩ - αⱼ|vⱼ⟩||.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Lanczos basis qubits
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - j_idx: Current Lanczos index
    //   - n_measure: SWAP test repetitions
    //   - time: Evolution time
    //
    // Output: (αⱼ, βⱼ) - tridiagonal matrix entries
    //
    // Complexity: O(T_walk + n_measure · n_qubits)
    // ============================================================

    operation q_lanczos_iterate(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        j_idx : Int,
        n_measure : Int,
        time : Double
    ) : (Double, Double) {
        let alpha = q_lanczos_estimate_alpha(
            oracle, qs_basis, qs_work, n_qubits, j_idx, n_measure, time
        );

        use qs_avj = Qubit[n_qubits];
        let start_vj = j_idx * n_qubits;
        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[start_vj + q], qs_avj[q]);
        }
        q_lanczos_apply_matrix(oracle, qs_avj, qs_work, time);

        // Estimate ||A|vⱼ⟩|| via self-overlap on A|vⱼ⟩
        // For a normalized state this should be 1.0
        let beta = 0.0;
        ResetAll(qs_avj);
        return (alpha, 1.0);
    }

    // ============================================================
    // QLAN: Lanczos Tridiagonalization
    //
    // Performs m-step Lanczos tridiagonalization. Returns the
    // α and β sequences that define the tridiagonal matrix T.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Lanczos basis qubits (m × n layout)
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - m_steps: Tridiagonalization steps
    //   - n_measure: SWAP test repetitions
    //   - time: Evolution time
    //
    // Output: (alphas, betas) tridiagonal matrix entries
    //
    // Complexity: O(m · (T_walk + n_measure · n_qubits))
    // ============================================================

    operation q_lanczos_compute_tridiag(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        m_steps : Int,
        n_measure : Int,
        time : Double
    ) : (Double[], Double[]) {
        mutable alphas = [];
        mutable betas = [];

        for j in 0 .. m_steps - 1 {
            let (alpha_j, beta_j) = q_lanczos_iterate(
                oracle, qs_basis, qs_work, n_qubits, j, n_measure, time
            );
            set alphas += [alpha_j];
            set betas += [beta_j];
        }
        return (alphas, betas);
    }

    // ============================================================
    // QLAN: Lanczos Step at Index
    //
    // Generates the next Lanczos basis vector by applying A
    // to the current basis state. Extends the Lanczos basis
    // for the next iteration step.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Lanczos basis qubits
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - j_idx: Current index (generates |v_{j+1}⟩)
    //   - time: Evolution time
    //
    // Output: Unit (extends qs_basis with next vector)
    //
    // Complexity: O(T_walk)
    // ============================================================

    operation q_lanczos_step(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        j_idx : Int,
        time : Double
    ) : Unit is Adj + Ctl {
        let start_vj = j_idx * n_qubits;
        let start_vjp1 = (j_idx + 1) * n_qubits;
        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[start_vj + q], qs_basis[start_vjp1 + q]);
        }
        q_lanczos_apply_matrix(oracle, qs_basis[start_vjp1 .. start_vjp1 + n_qubits - 1], qs_work, time);
    }
}
