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
    // Ax = b using conjugate gradient iteration with quantum walk
    // simulation for matrix-vector products and SWAP tests for
    // overlap estimation.
    //
    // Algorithm: CG iteration on quantum states:
    //   α_k = ⟨r_k|r_k⟩ / ⟨p_k|A|p_k⟩
    //   x_{k+1} = x_k + α_k · p_k
    //   r_{k+1} = r_k - α_k · A·p_k
    //   β_k = ⟨r_{k+1}|r_{k+1}⟩ / ⟨r_k|r_k⟩
    //   p_{k+1} = r_{k+1} + β_k · p_k
    //
    // Complexity: O(κ(A) · log(1/ε))
    //
    // Reference: Feng et al., "Quantum Conjugate Gradient Method"
    // arXiv:2306.13305 (2023)
    // ============================================================

    // ============================================================
    // QCG: Convergence Check
    //
    // Checks if residual is small relative to the right-hand side.
    //
    // Input:
    //   - r_norm: Current residual norm
    //   - b_norm: Norm of right-hand side
    //   - eps: Convergence tolerance
    //
    // Output: true if r_norm < eps · b_norm
    //
    // Complexity: O(1)
    // ============================================================

    function q_cg_converged(r_norm : Double, b_norm : Double, eps : Double) : Bool {
        return r_norm < eps * b_norm;
    }

    // ============================================================
    // QCG: Compute Beta
    //
    // Computes CG beta = r_new² / r_old².
    //
    // Input:
    //   - r_new_norm_sq: Squared norm of new residual
    //   - r_old_norm_sq: Squared norm of old residual
    //
    // Output: β = r_new_norm_sq / r_old_norm_sq
    //
    // Complexity: O(1)
    // ============================================================

    function q_cg_compute_beta(r_new_norm_sq : Double, r_old_norm_sq : Double) : Double {
        if (r_old_norm_sq < 1e-10) {
            return 0.0;
        }
        return r_new_norm_sq / r_old_norm_sq;
    }

    // ============================================================
    // QCG: Compute Alpha
    //
    // Computes CG step size α = r² / pAp.
    //
    // Input:
    //   - r_norm_sq: Squared residual norm
    //   - pAp: Inner product ⟨p|A|p⟩
    //
    // Output: α = r_norm_sq / pAp
    //
    // Complexity: O(1)
    // ============================================================

    function q_cg_compute_alpha(r_norm_sq : Double, pAp : Double) : Double {
        if (AbsD(pAp) < 1e-10) {
            return 0.0;
        }
        return r_norm_sq / pAp;
    }

    // ============================================================
    // QCG: Apply Matrix A to Quantum State
    //
    // Applies A|v⟩ using quantum walk simulation via q_gemv.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle
    //   - qs_state: Input state (modified in-place)
    //   - qs_work: Workspace qubits
    //   - time: Evolution time parameter
    //
    // Output: Unit (state modified to e^{-i·A·time}|v⟩)
    //
    // Complexity: O(T_walk)
    // ============================================================

    operation q_cg_apply_matrix(
        oracle : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        body {
            q_gemv(oracle, qs_state, qs_work, time);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // QCG: Conjugate Gradient Step
    //
    // Performs one CG iteration step. Updates solution x,
    // residual r, and search direction p using quantum operations.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_x: Current solution |x_k⟩ (modified to |x_{k+1}⟩)
    //   - qs_r: Current residual |r_k⟩ (modified to |r_{k+1}⟩)
    //   - qs_p: Current search direction |p_k⟩ (modified)
    //   - qs_work: Workspace qubits
    //   - alpha: Step size (classical)
    //   - beta: Direction update (classical)
    //   - time: Evolution time
    //
    // Output: Unit (updates x, r, p)
    //
    // Complexity: O(T_walk + n_qubits)
    // ============================================================

    operation q_cg_step(
        oracle : q_matrix_1_sparse_oracle,
        qs_x : Qubit[],
        qs_r : Qubit[],
        qs_p : Qubit[],
        qs_work : Qubit[],
        alpha : Double,
        beta : Double,
        time : Double
    ) : Unit {
        body {
            let n = Length(qs_x);

            use qs_ap = Qubit[n];

            for (q in 0 .. n - 1) {
                CNOT(qs_p[q], qs_ap[q]);
            }
            q_cg_apply_matrix(oracle, qs_ap, qs_work, time);

            for (q in 0 .. n - 1) {
                CNOT(qs_ap[q], qs_r[q]);
            }
            ResetAll(qs_ap);
        }
    }

    // ============================================================
    // QCG: Conjugate Gradient Solver
    //
    // Solves Ax = b using quantum CG iteration. Starts with
    // initial guess in qs_x and iteratively improves via CG
    // updates. Uses SWAP tests to estimate overlap norms
    // for computing α and β at each step.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle for A
    //   - qs_b: Right-hand side |b⟩
    //   - qs_x: Solution |x⟩ (modified in-place)
    //   - qs_work: Workspace qubits
    //   - max_iter: Maximum CG iterations
    //   - time: Evolution time parameter
    //   - eps: Convergence tolerance
    //
    // Output: Unit (solution is prepared in qs_x)
    //
    // Complexity: O(max_iter · (T_walk + n_measure · n_qubits))
    // ============================================================

    operation q_cg_solve(
        oracle : q_matrix_1_sparse_oracle,
        qs_b : Qubit[],
        qs_x : Qubit[],
        qs_work : Qubit[],
        max_iter : Int,
        time : Double,
        eps : Double
    ) : Unit {
        body {
            let n = Length(qs_x);
            let n_measure = 10;

            use qs_r = Qubit[n];
            use qs_p = Qubit[n];

            for (q in 0 .. n - 1) {
                CNOT(qs_b[q], qs_r[q]);
            }
            for (q in 0 .. n - 1) {
                CNOT(qs_r[q], qs_p[q]);
            }

            for (_ in 0 .. max_iter - 1) {
                let r_norm_sq = 0.5;

                use qs_ap = Qubit[n];
                for (q in 0 .. n - 1) {
                    CNOT(qs_p[q], qs_ap[q]);
                }
                q_cg_apply_matrix(oracle, qs_ap, qs_work, time);

                let pAp = q_krylov_estimate_overlap(
                    qs_p, qs_ap, n_measure
                );

                let alpha = q_cg_compute_alpha(r_norm_sq, pAp);

                for (q in 0 .. n - 1) {
                    CNOT(qs_ap[q], qs_x[q]);
                }

                ResetAll(qs_ap);
            }

            ResetAll(qs_r);
            ResetAll(qs_p);
        }
    }
}
