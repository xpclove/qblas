namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Krylov Subspace Methods (QKRY)
    //
    // Purpose: Provides quantum Krylov subspace operations for
    // eigenvalue estimation and linear system solving. The Krylov
    // subspace K_m(A, b) = span{b, Ab, A^2b, ..., A^{m-1}b} is
    // constructed using quantum walk simulation and SWAP test.
    //
    // Algorithm: Hybrid quantum-classical approach:
    //   1. q_gemv (quantum walk) applies A|v⟩
    //   2. SWAP test estimates overlaps ⟨v_i|v_j⟩
    //   3. Classical orthogonalization from measured overlaps
    //
    // Complexity: O(m · T_walk + m² · T_swap)
    //
    // Reference: Castellano et al., "Quantum Krylov Subspace
    // Methods for Ground State Energy Estimation"
    // arXiv:2210.07913 (2022)
    // ============================================================

    // ============================================================
    // QKRY: Convergence Check
    //
    // Checks if relative residual norm has converged.
    //
    // Input:
    //   - r_norm: Current residual norm
    //   - init_norm: Initial residual norm
    //   - eps: Convergence tolerance
    //
    // Output: true if r_norm / init_norm < eps
    //
    // Complexity: O(1)
    // ============================================================

    function q_krylov_converged(r_norm : Double, init_norm : Double, eps : Double) : Bool {
        if (init_norm < 1e-10) {
            return r_norm < eps;
        }
        return r_norm / init_norm < eps;
    }

    // ============================================================
    // QKRY: Squared Norm
    //
    // Computes squared L2 norm of a classical vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||² = Σ v_i²
    //
    // Complexity: O(n)
    // ============================================================

    function q_krylov_norm_sq(v : Double[]) : Double {
        return SquaredNorm(v);
    }

    // ============================================================
    // QKRY: Inner Product
    //
    // Computes classical inner product ⟨v, w⟩.
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //
    // Output: Σ v_i · w_i
    //
    // Complexity: O(n)
    // ============================================================

    function q_krylov_inner_product(v : Double[], w : Double[]) : Double {
        mutable s = 0.0;
        for i in 0 .. Length(v) - 1 {
            set s += v[i] * w[i];
        }
        return s;
    }

    // ============================================================
    // QKRY: Single-Shot SWAP Test
    //
    // Runs the SWAP test circuit once and measures the control
    // qubit. Returns Zero with probability (1 + |⟨ψ|φ⟩|²)/2.
    //
    // Input:
    //   - ctrl: Control qubit (measured after circuit)
    //   - qs_a: First quantum state |ψ⟩
    //   - qs_b: Second quantum state |φ⟩
    //
    // Output: Measurement result (Zero or One)
    //
    // Complexity: O(n_qubits)
    // ============================================================

    operation q_krylov_swap_test_one_shot(
        ctrl : Qubit,
        qs_a : Qubit[],
        qs_b : Qubit[]
    ) : Result {
        q_swap_test_core(ctrl, qs_a, qs_b);
        return M(ctrl);
    }

    // ============================================================
    // QKRY: Multi-Shot Overlap Estimation
    //
    // Estimates |⟨ψ|φ⟩| between two quantum states using
    // multiple SWAP test repetitions. Each shot copies the
    // input states to fresh qubits to ensure correct statistics.
    //
    // P(|0⟩) = (1 + |⟨ψ|φ⟩|²) / 2
    //
    // Input:
    //   - qs_a: First quantum state |ψ⟩
    //   - qs_b: Second quantum state |φ⟩
    //   - n_measure: Number of SWAP test repetitions
    //
    // Output: Estimated |⟨ψ|φ⟩| ∈ [0, 1]
    //
    // Complexity: O(n_measure · n_qubits)
    // ============================================================

    operation q_krylov_estimate_overlap(
        qs_a : Qubit[],
        qs_b : Qubit[],
        n_measure : Int
    ) : Double {
        let n = Length(qs_a);
        mutable count_zero = 0;
        for _ in 0 .. n_measure - 1 {
            use qs_ctrl = Qubit[1];
            use qs_a_copy = Qubit[n];
            use qs_b_copy = Qubit[n];
            let ctrl = qs_ctrl[0];
            for q in 0 .. n - 1 {
                CNOT(qs_a[q], qs_a_copy[q]);
                CNOT(qs_b[q], qs_b_copy[q]);
            }
            q_swap_test_core(ctrl, qs_a_copy, qs_b_copy);
            let m = M(ctrl);
            if (m == Zero) {
                set count_zero += 1;
            }
            ResetAll(qs_a_copy);
            ResetAll(qs_b_copy);
            Reset(ctrl);
        }
        let prob_zero = IntAsDouble(count_zero) / IntAsDouble(n_measure);
        let overlap_sq = 2.0 * prob_zero - 1.0;
        return overlap_sq < 0.0 ? 0.0 | Sqrt(overlap_sq);
    }

    // ============================================================
    // QKRY: Apply Matrix A to Quantum State
    //
    // Applies A|v⟩ using quantum walk simulation via q_gemv.
    // Implements exp(-i·A·time) which generates A|v⟩ for
    // the Krylov subspace when applied repeatedly.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle
    //   - qs_state: Input state (modified to e^{-i·A·time}|v⟩)
    //   - qs_work: Workspace (at least n+1 qubits)
    //   - time: Evolution time parameter
    //
    // Output: Unit (state modified in-place)
    //
    // Complexity: O(d · ||H||_max · time)
    // ============================================================

    operation q_krylov_apply_matrix(
        oracle : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        q_gemv(oracle, qs_state, qs_work, time);
    }

    // ============================================================
    // QKRY: Krylov Subspace via Repeated Application
    //
    // Generates the Krylov subspace by applying A repeatedly
    // to build the sequence {|v⟩, A|v⟩, A²|v⟩, ..., A^{m-1}|v⟩}.
    // Each basis state occupies n_qubits in the qs_basis register.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Output register (m × n_qubits layout)
    //   - qs_work: Workspace for q_gemv
    //   - n_qubits: Qubits per basis vector
    //   - m_steps: Krylov subspace dimension
    //   - time: Evolution time for each application
    //
    // Output: Unit (fills qs_basis with Krylov basis)
    //
    // Complexity: O(m · T_walk)
    // ============================================================

    operation q_krylov_generate_subspace(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        m_steps : Int,
        time : Double
    ) : Unit {
        let total_qs = Length(qs_basis);
        if (total_qs < n_qubits * m_steps) {
            fail $"Insufficient qubits for Krylov basis. Need {n_qubits * m_steps}.";
        }
        for k in 1 .. m_steps - 1 {
            let src = (k - 1) * n_qubits;
            let tgt = k * n_qubits;
            for q in 0 .. n_qubits - 1 {
                CNOT(qs_basis[src + q], qs_basis[tgt + q]);
            }
            q_krylov_apply_matrix(
                oracle,
                qs_basis[tgt .. tgt + n_qubits - 1],
                qs_work,
                time
            );
        }
    }

    // ============================================================
    // QKRY: Arnoldi Overlap Computation
    //
    // For the current Krylov vector |v_j⟩, computes the overlaps
    // h_{i,j} = ⟨v_i|A|v_j⟩ for all i = 0..j-1. These form one
    // column of the upper Hessenberg matrix H in the Arnoldi
    // process.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Krylov basis qubits (m × n layout)
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - j_idx: Current Krylov index (0 ≤ j_idx < m)
    //   - n_measure: SWAP test repetitions per overlap
    //   - time: Evolution time for matrix application
    //
    // Output: Array [h_{0,j}, h_{1,j}, ..., h_{j-1,j}]
    //
    // Complexity: O(j · (T_walk + n_measure · n_qubits))
    // ============================================================

    operation q_krylov_arnoldi_overlaps(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        j_idx : Int,
        n_measure : Int,
        time : Double
    ) : Double[] {
        let start_vj = j_idx * n_qubits;
        use qs_avj = Qubit[n_qubits];

        for q in 0 .. n_qubits - 1 {
            CNOT(qs_basis[start_vj + q], qs_avj[q]);
        }
        q_krylov_apply_matrix(oracle, qs_avj, qs_work, time);

        mutable overlaps = [];
        for i_idx in 0 .. j_idx - 1 {
            let start_vi = i_idx * n_qubits;
            let h_ij = q_krylov_estimate_overlap(
                qs_basis[start_vi .. start_vi + n_qubits - 1],
                qs_avj[0 .. n_qubits - 1],
                n_measure
            );
            set overlaps += [h_ij];
        }
        ResetAll(qs_avj);
        return overlaps;
    }

    // ============================================================
    // QKRY: Krylov Basis Gram Matrix
    //
    // Computes the Gram matrix G[i,j] = |⟨v_i|v_j⟩| for all
    // basis vectors. Used to verify orthogonality of the
    // Krylov basis generated by q_krylov_generate_subspace.
    //
    // Input:
    //   - qs_basis: Krylov basis qubits
    //   - n_qubits: Qubits per basis vector
    //   - m_steps: Subspace dimension
    //   - n_measure: SWAP test repetitions
    //
    // Output: m×m Gram matrix of overlaps
    //
    // Complexity: O(m² · n_measure · n_qubits)
    // ============================================================

    operation q_krylov_gram_matrix(
        qs_basis : Qubit[],
        n_qubits : Int,
        m_steps : Int,
        n_measure : Int
    ) : Double[][] {
        mutable G = [];
        for i in 0 .. m_steps - 1 {
            mutable row = [];
            let si = i * n_qubits;
            for j in 0 .. m_steps - 1 {
                let sj = j * n_qubits;
                let gij = q_krylov_estimate_overlap(
                    qs_basis[si .. si + n_qubits - 1],
                    qs_basis[sj .. sj + n_qubits - 1],
                    n_measure
                );
                set row += [gij];
            }
            set G += [row];
        }
        return G;
    }
}
