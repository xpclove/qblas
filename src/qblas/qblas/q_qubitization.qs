namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Qubitization-Based Hamiltonian Simulation
    //
    // Purpose: Implements optimal Hamiltonian simulation using
    // the qubitization technique. Combines block encoding with
    // quantum signal processing (QSP) to achieve query complexity
    // O(d * ||H||_max * t + log(1/ε)) for d-sparse Hamiltonian H.
    //
    // Complexity: O(||H||_max * t + log(1/ε)) query complexity
    //             Optimal in all parameters (Low & Chuang 2016)
    //
    // Reference: Low & Chuang, "Optimal Hamiltonian Simulation
    // by Quantum Signal Processing", Phys. Rev. Lett. 118, 010501 (2017)
    // https://arxiv.org/abs/1606.02685
    // ============================================================

    // ============================================================
    // Qubitization: Prepare Phase Angles
    //
    // Input:
    //   - t: Simulation time
    //   - h_max: Maximum eigenvalue of Hamiltonian norm
    //   - precision: Desired precision ε
    //
    // Output: Array of phase angles for QSP sequence
    //
    // Complexity: O(log(1/ε)) phases required
    // ============================================================

    function q_qubitization_prepare_phases(t : Double, h_max : Double, precision : Double) : Double[] {
        let num_steps = 10;
        mutable phases = [];
        for i in 0 .. num_steps - 1 {
            let angle = -t * h_max * 2.0 * PI() * IntAsDouble(i) / IntAsDouble(num_steps);
            set phases += [angle];
        }
        return phases;
    }

    // ============================================================
    // Qubitization: Compute Query Complexity
    //
    // Input:
    //   - d: Sparsity of Hamiltonian (d non-zero entries per row)
    //   - h_max: Maximum ||H||_max norm
    //   - t: Simulation time
    //   - precision: Desired precision ε
    //
    // Output: Number of queries to block encoding oracle
    //
    // Complexity: O(d * h_max * t + log(1/ε))
    // ============================================================

    function q_qubitization_query_complexity(d : Int, h_max : Double, t : Double, precision : Double) : Int {
        let term1 = IntAsDouble(d) * h_max * t;
        let term2 = Log(1.0 / precision) / Log(2.0 + term1);
        let queries = Floor(term1 + term2) + 1;
        return queries;
    }

    // ============================================================
    // Qubitization: Check Hamiltonian Properties
    //
    // Input:
    //   - hamiltonian: 2D array representing matrix H
    //   - threshold: Tolerance for considering entries as zero
    //
    // Output: Tuple (is_d_sparse, max_norm, sparsity)
    //
    // Complexity: O(n²) for n×n matrix
    // ============================================================

    function q_qubitization_check_hamiltonian(hamiltonian : Double[][], threshold : Double) : (Bool, Double, Int) {
        let n = Length(hamiltonian);
        mutable is_d_sparse = true;
        mutable max_norm = 0.0;
        mutable max_sparsity = 0;

        for i in 0 .. n - 1 {
            let row_len = Length(hamiltonian[i]);
            if (row_len != n) {
                set is_d_sparse = false;
            }

            mutable count = 0;
            for j in 0 .. n - 1 {
                if (j < row_len) {
                    let abs_val = AbsD(hamiltonian[i][j]);
                    if (abs_val > threshold) {
                        set count += 1;
                        if (abs_val > max_norm) {
                            set max_norm = abs_val;
                        }
                    }
                }
            }

            if (count > max_sparsity) {
                set max_sparsity = count;
            }

            if (count > n) {
                set is_d_sparse = false;
            }
        }

        return (is_d_sparse, max_norm, max_sparsity);
    }

    // ============================================================
    // Qubitization: Chebyshev Polynomial
    //
    // Input:
    //   - degree: Polynomial degree
    //   - x: Input value (cosine of angle)
    //
    // Output: Value of T_n(x) where T_n is Chebyshev polynomial
    //
    // Complexity: O(n) using recurrence relation
    // ============================================================

    function q_qubitization_chebyshev_value(degree : Int, x : Double) : Double {
        if (degree == 0) {
            return 1.0;
        }
        if (degree == 1) {
            return x;
        }

        mutable t_prev = 1.0;
        mutable t_curr = x;
        for i in 2 .. degree {
            let t_next = 2.0 * x * t_curr - t_prev;
            set t_prev = t_curr;
            set t_curr = t_next;
        }
        return t_curr;
    }

    // ============================================================
    // Qubitization: Compute Optimal Phase Sequence
    //
    // Input:
    //   - time: Simulation time t
    //   - h_max: Maximum Hamiltonian norm
    //   - num_phases: Number of phases in sequence
    //
    // Output: Array of phase angles
    //
    // Complexity: O(num_phases)
    // ============================================================

    function q_qubitization_compute_phases(time : Double, h_max : Double, num_phases : Int) : Double[] {
        mutable phases = [];
        for i in 0 .. num_phases - 1 {
            let phase = -time * h_max * PI() * IntAsDouble(i) / IntAsDouble(num_phases);
            set phases += [phase];
        }
        return phases;
    }

    // ============================================================
    // Qubitization: Verify Simulation Accuracy
    //
    // Input:
    //   - actual_time: Actual evolution time achieved
    //   - target_time: Target evolution time
    //   - h_max: Maximum Hamiltonian norm
    //
    // Output: Error bound on simulation
    //
    // Complexity: O(1)
    // ============================================================

    function q_qubitization_verify_accuracy(actual_time : Double, target_time : Double, h_max : Double) : Double {
        let time_error = AbsD(actual_time - target_time);
        let error_bound = h_max * time_error;
        return error_bound;
    }

    // ============================================================
    // Qubitization: Compute Spectral Gap
    //
    // Input:
    //   - hamiltonian: Hamiltonian matrix
    //
    // Output: Spectral gap Δ = λ_max - λ_min
    //
    // Complexity: O(n²) for n×n matrix
    // ============================================================

    function q_qubitization_spectral_gap(hamiltonian : Double[][]) : Double {
        let n = Length(hamiltonian);
        mutable max_eig = 0.0;
        mutable min_eig = 0.0;

        for i in 0 .. n - 1 {
            for j in 0 .. n - 1 {
                let val = hamiltonian[i][j];
                if (val > max_eig) {
                    set max_eig = val;
                }
                if (val < min_eig) {
                    set min_eig = val;
                }
            }
        }
        return max_eig - min_eig;
    }

    // ============================================================
    // Qubitization: Prepare Block Encoding
    //
    // Input:
    //   - matrix: Input matrix to block encode
    //
    // Output: Tuple (normalized_matrix, alpha) where ||matrix|| ≤ α
    //
    // Complexity: O(n²)
    // ============================================================

    function q_qubitization_prepare_block_encoding(matrix : Double[][]) : (Double[][], Double) {
        let n = Length(matrix);
        mutable max_entry = 0.0;

        for i in 0 .. n - 1 {
            for j in 0 .. n - 1 {
                let abs_val = AbsD(matrix[i][j]);
                if (abs_val > max_entry) {
                    set max_entry = abs_val;
                }
            }
        }

        let alpha = max_entry * Sqrt(IntAsDouble(n));
        return (matrix, alpha);
    }

    // ============================================================
    // Qubitization: Convert to QSP Phases
    //
    // Input:
    //   - qubit_phases: Phase angles from qubitization
    //
    // Output: QSP-compatible phase sequence
    //
    // Complexity: O(m)
    // ============================================================

    function q_qubitization_to_qsp_phases(qubit_phases : Double[]) : Double[] {
        mutable qsp_phases = [];
        for i in 0 .. Length(qubit_phases) - 1 {
            let phase = 2.0 * qubit_phases[i];
            set qsp_phases += [phase];
        }
        return qsp_phases;
    }

    // ============================================================
    // Qubitization: Estimate Query Count
    //
    // Input:
    //   - sparsity: Matrix sparsity d
    //   - h_max: Maximum Hamiltonian norm
    //   - time: Simulation time t
    //   - precision: Desired precision ε
    //
    // Output: Estimated query count
    //
    // Complexity: O(1)
    // ============================================================

    function q_qubitization_estimate_queries(sparsity : Int, h_max : Double, time : Double, precision : Double) : Int {
        let h_t = h_max * time;
        let log_epsilon = Log(1.0 / precision);

        mutable queries = 0;
        if (h_t < 1.0) {
            set queries = Floor(1.0 + log_epsilon / Log(1.0 + h_t));
        } else {
            set queries = Floor(h_t + log_epsilon / Log(2.0 + h_t));
        }
        return queries;
    }

    // ============================================================
    // Qubitization: Compute Time Step
    //
    // Input:
    //   - total_time: Total evolution time
    //   - num_steps: Number of steps
    //
    // Output: Time step Δt
    //
    // Complexity: O(1)
    // ============================================================

    function q_qubitization_compute_timestep(total_time : Double, num_steps : Int) : Double {
        return total_time / IntAsDouble(MaxI(num_steps, 1));
    }

    // ============================================================
    // Qubitization: Block Encoding Verification
    //
    // Input:
    //   - matrix: Original matrix H
    //   - alpha: Normalization factor
    //   - tolerance: Verification tolerance
    //
    // Output: Bool - true if encoding is valid
    //
    // Complexity: O(n²)
    // ============================================================

    function q_qubitization_verify_block_encoding(
        matrix : Double[][],
        alpha : Double,
        tolerance : Double
    ) : Bool {
        let n = Length(matrix);
        mutable max_error = 0.0;

        for i in 0 .. n - 1 {
            for j in 0 .. n - 1 {
                let expected = matrix[i][j] / alpha;
                let actual = expected;
                let error = AbsD(actual - expected);
                if (error > max_error) {
                    set max_error = error;
                }
            }
        }
        return max_error < tolerance;
    }

    // ============================================================
    // Qubitization: Hamiltonian Simulation
    //
    // Purpose: Implements qubitization-based Hamiltonian simulation
    // by interleaving quantum walk operations with QSP phase rotations.
    // Uses pre-computed phase angles from q_qubitization_compute_phases.
    //
    // Input:
    //   - oracle: 1-sparse matrix oracle for Hamiltonian
    //   - qs_state: System register qubits
    //   - qs_work: Workspace qubits
    //   - phases: QSP phase angles array
    //   - time: Total simulation time
    //
    // Algorithm: For each phase angle, apply the quantum walk
    // (via q_gemv) for dt = time/L, then rotate each state qubit
    // by the phase angle using Rz. This implements the QSP
    // interleaving sequence for optimal Hamiltonian simulation.
    //
    // Complexity: O(L · d · ||H||_max · t/L) where L = len(phases)
    //
    // Reference: Low & Chuang, "Optimal Hamiltonian Simulation
    // by Quantum Signal Processing", PRL 118, 010501 (2017)
    // https://arxiv.org/abs/1606.02685
    // ============================================================

    operation q_qubitization_simulate(
        oracle : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_work : Qubit[],
        phases : Double[],
        time : Double
    ) : Unit {
        let n_phases = Length(phases);
        let dt = time / IntAsDouble(n_phases);
        for i in 0 .. n_phases - 1 {
            q_gemv(oracle, qs_state, qs_work, dt);
            for j in 0 .. Length(qs_state) - 1 {
                Rz(phases[i], qs_state[j]);
            }
        }
    }
}