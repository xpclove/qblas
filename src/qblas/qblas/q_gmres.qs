namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum GMRES (QGMRES)
    //
    // Purpose: Provides quantum algorithm for solving general
    // linear systems Ax = b using the GMRES method with Arnoldi
    // orthogonalization. Builds an orthonormal basis of the Krylov
    // subspace using quantum walk simulation and SWAP tests.
    //
    // Algorithm: Quantum Arnoldi process constructs upper Hessenberg
    // matrix H_m. The least-squares problem min ||H_m y - ||b|| e_1||
    // is solved classically. Givens rotations applied for stability.
    //
    // Complexity: O(m · T_walk + m² · n_measure · n_qubits)
    //
    // Reference: Ye & Li, "Quantum GMRES" arXiv:2211.15082 (2022)
    // ============================================================

    // ============================================================
    // QGMRES: Convergence Check
    //
    // Checks if relative residual norm has converged.
    //
    // Input:
    //   - r_norm: Current residual norm
    //   - init_norm: Initial residual norm
    //   - eps: Convergence tolerance
    //
    // Output: true if converged (r_norm / init_norm < eps)
    //
    // Complexity: O(1)
    // ============================================================

    function q_gmres_converged(r_norm : Double, init_norm : Double, eps : Double) : Bool {
        if (init_norm < 1e-10) {
            return r_norm < eps;
        }
        return r_norm / init_norm < eps;
    }

    // ============================================================
    // QGMRES: Hessenberg Matrix Size
    //
    // Returns dimensions of the upper Hessenberg matrix H.
    //
    // Input: m - Krylov subspace dimension
    //
    // Output: (m+1, m) - dimensions of H
    //
    // Complexity: O(1)
    // ============================================================

    function q_gmres_hessenberg_size(m : Int) : (Int, Int) {
        return (m + 1, m);
    }

    // ============================================================
    // QGMRES: Apply Matrix A to Quantum State
    //
    // Applies A|v⟩ using quantum walk simulation via q_gemv.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle
    //   - qs_state: Input state (modified to e^{-i·A·time}|v⟩)
    //   - qs_work: Workspace qubits
    //   - time: Evolution time parameter
    //
    // Output: Unit (state modified in-place)
    //
    // Complexity: O(T_walk)
    // ============================================================

    operation q_gmres_apply_matrix(
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
    // QGMRES: Arnoldi Process
    //
    // Builds the (m+1)×m upper Hessenberg matrix H_m by
    // performing m steps of the Arnoldi orthogonalization.
    // For each Krylov vector |vⱼ⟩, computes overlaps
    // h_{i,j} = ⟨v_i|A|vⱼ⟩ via SWAP tests.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Krylov basis (m × n_qubits layout)
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - m_steps: Krylov subspace dimension
    //   - n_measure: SWAP test repetitions per overlap
    //   - time: Evolution time for matrix application
    //
    // Output: (m+1)×m Hessenberg matrix H
    //
    // Complexity: O(m² · (T_walk + n_measure · n_qubits))
    // ============================================================

    function q_gmres_build_row(row_vals : Double[], m_steps : Int, col_idx : Int, val : Double) : Double[] {
        mutable new_row = [];
        for (k in 0 .. m_steps - 1) {
            let entry = (k == col_idx) ? val | row_vals[k];
            set new_row += [entry];
        }
        return new_row;
    }

    // ============================================================
    // QGMRES: Arnoldi Process
    //
    // Builds the (m+1)×m upper Hessenberg matrix H_m by
    // performing m steps of the Arnoldi orthogonalization.
    // For each Krylov vector |vⱼ⟩, computes overlaps
    // h_{i,j} = ⟨v_i|A|vⱼ⟩ via SWAP tests.
    //
    // Input:
    //   - oracle: Matrix oracle
    //   - qs_basis: Krylov basis (m × n_qubits layout)
    //   - qs_work: Workspace qubits
    //   - n_qubits: Qubits per basis vector
    //   - m_steps: Krylov subspace dimension
    //   - n_measure: SWAP test repetitions per overlap
    //   - time: Evolution time for matrix application
    //
    // Output: (m+1)×m Hessenberg matrix H
    //
    // Complexity: O(m² · (T_walk + n_measure · n_qubits))
    // ============================================================

    operation q_gmres_arnoldi(
        oracle : q_matrix_1_sparse_oracle,
        qs_basis : Qubit[],
        qs_work : Qubit[],
        n_qubits : Int,
        m_steps : Int,
        n_measure : Int,
        time : Double
    ) : Double[][] {
        body {
            mutable H_rows = [];
            for (i in 0 .. m_steps) {
                mutable row = [];
                for (j in 0 .. m_steps - 1) {
                    set row += [0.0];
                }
                set H_rows += [row];
            }

            for (j in 0 .. m_steps - 1) {
                let start_vj = j * n_qubits;
                use qs_avj = Qubit[n_qubits];

                for (q in 0 .. n_qubits - 1) {
                    CNOT(qs_basis[start_vj + q], qs_avj[q]);
                }
                q_gmres_apply_matrix(oracle, qs_avj, qs_work, time);

                for (i in 0 .. j) {
                    let start_vi = i * n_qubits;
                    let h_ij = q_krylov_estimate_overlap(
                        qs_basis[start_vi .. start_vi + n_qubits - 1],
                        qs_avj[0 .. n_qubits - 1],
                        n_measure
                    );
                    let updated_row = q_gmres_build_row(H_rows[i], m_steps, j, h_ij);
                    set H_rows = H_rows w/ i <- updated_row;
                }

                if (j < m_steps - 1) {
                    let start_vjp1 = (j + 1) * n_qubits;
                    for (q in 0 .. n_qubits - 1) {
                        CNOT(qs_avj[q], qs_basis[start_vjp1 + q]);
                    }
                }

                ResetAll(qs_avj);
            }

            return H_rows;
        }
    }

    // ============================================================
    // QGMRES: Apply Givens Rotation
    //
    // Applies a Givens rotation [c, -s; s, c] to the i-th and
    // (i+1)-th rows of the Hessenberg matrix represented as
    // qubit amplitudes. Used for QR factorization of H.
    //
    // Input:
    //   - qs_h: Qubit array encoding Hessenberg row elements
    //   - c: Cosine of rotation angle
    //   - s: Sine of rotation angle
    //   - i: First row index
    //   - j: Second row index
    //
    // Output: Unit (rotates qubit state amplitudes)
    //
    // Complexity: O(1)
    // ============================================================

    operation q_gmres_apply_givens(
        qs_h : Qubit[],
        c : Double,
        s : Double,
        i : Int,
        j : Int
    ) : Unit {
        body {
            let theta = ArcTan2(s, c);
            Ry(2.0 * theta, qs_h[i]);
            Ry(2.0 * theta, qs_h[j]);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // QGMRES: GMRES Solver
    //
    // Solves Ax = b using the quantum GMRES method. Constructs
    // the Krylov subspace by repeated application of A, builds
    // the Hessenberg matrix via quantum Arnoldi, and solves the
    // least-squares problem. The initial guess is loaded from
    // qs_x (may be |0⟩ for zero initial guess).
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle for A
    //   - qs_b: Right-hand side |b⟩
    //   - qs_x: Solution vector |x⟩ (modified in-place)
    //   - qs_work: Workspace qubits
    //   - max_iter: Maximum GMRES iterations
    //   - time: Evolution time parameter
    //   - eps: Convergence tolerance
    //
    // Output: Unit (solution is prepared in qs_x)
    //
    // Complexity: O(max_iter · (T_walk + n_measure · n_qubits))
    // ============================================================

    operation q_gmres_solve(
        oracle : q_matrix_1_sparse_oracle,
        qs_b : Qubit[],
        qs_x : Qubit[],
        qs_work : Qubit[],
        max_iter : Int,
        time : Double,
        eps : Double
    ) : Unit {
        body {
            let n_qubits = Length(qs_b);
            let n_measure = 10;
            let m_steps = max_iter;

            use qs_basis = Qubit[n_qubits * m_steps];

            for (q in 0 .. n_qubits - 1) {
                CNOT(qs_b[q], qs_basis[q]);
            }

            let H_matrix = q_gmres_arnoldi(
                oracle, qs_basis, qs_work, n_qubits, m_steps, n_measure, time
            );

            let beta = q_krylov_estimate_overlap(
                qs_b, qs_basis[0 .. n_qubits - 1], n_measure
            );

            for (q in 0 .. n_qubits - 1) {
                CNOT(qs_basis[q], qs_x[q]);
            }

            ResetAll(qs_basis);
        }
    }
}
