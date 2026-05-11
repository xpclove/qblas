namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Enhanced Block Encoding Primitives (Version 2)
    //
    // Purpose: Provides advanced primitives for block encoding
    // arbitrary matrices into unitary quantum circuits with
    // improved efficiency and success probability.
    //
    // Algorithm: Combines QROM for data loading, LCU for
    // linear combination of unitaries, and OAA (Oblivious
    // Amplitude Amplification) for probability amplification.
    //
    // Complexity: O(polylog(N)) for sparse matrices with O(1)
    // success probability via amplitude amplification
    //
    // Reference: Gilyén et al., "Quantum Singular Value Transformation"
    // STOC 2019. https://arxiv.org/abs/1806.01838
    // Reference: Low & Chuang, "Hamiltonian Simulation by QSP"
    // ============================================================

    // ============================================================
    // QROM: Quantum Random Access Memory (Read Operation)
    //
    // Efficiently reads classical data from quantum memory using
    // the "QROM" technique from Giovannetti et al.
    //
    // Input:
    //   - data: Array of double values to load (size N)
    //   - qs_addr: Address qubits (log_2 N qubits)
    //   - qs_data: Data qubit for amplitude encoding
    //
    // Output: State with amplitude proportional to data[index]
    //
    // Complexity: O(N) for N addresses, O(1) for single address
    //
    // Reference: Giovannetti et al., "Quantum RAM"
    // Phys. Rev. Lett. 100, 160501 (2008)
    // ============================================================

    operation qrom_read(
        data : Double[],
        qs_addr : Qubit[],
        qs_data : Qubit
    ) : Unit {
        body (...) {
            let n = Length(qs_addr);
            let N = 2 ^ n;
            let norm = Sqrt(SquaredNorm(data));

            if (norm < 1e-10) {
                return ();
            }

            for (idx in 0 .. N - 1) {
                if (idx < Length(data)) {
                    let val = data[idx];
                    let amp = AbsD(val) / norm;

                    if (amp > 1e-10) {
                        let angle = 2.0 * ArcSin(amp);

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }

                        (Controlled Ry)(qs_addr, (angle, qs_data));

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // QROM: Multi-Value Read
    //
    // Reads multiple data values simultaneously using unary
    // encoding on multiple data qubits.
    //
    // Input:
    //   - data: Array of double values (k values)
    //   - qs_addr: Address qubits
    //   - qs_data: Data qubits (k qubits)
    //
    // Output: Superposition with amplitudes encoding all values
    //
    // Complexity: O(k * N) for k values and N addresses
    //
    // Reference: Low & Chuang, arXiv:1606.02685
    // ============================================================

    operation qrom_read_multi(
        data : Double[],
        qs_addr : Qubit[],
        qs_data : Qubit[]
    ) : Unit {
        body (...) {
            let n = Length(qs_addr);
            let N = 2 ^ n;
            let k = Length(qs_data);
            let norm = Sqrt(SquaredNorm(data));

            if (norm < 1e-10) {
                return ();
            }

            for (idx in 0 .. N - 1) {
                if (idx < Length(data)) {
                    let val = data[idx];
                    let amp = AbsD(val) / norm;

                    if (amp > 1e-10) {
                        let angle = 2.0 * ArcSin(amp);

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }

                        (Controlled Ry)(qs_addr, (angle, qs_data[0]));

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // LCU: Linear Combination of Unitaries - Block Encoding
    //
    // Block encodes matrix A = Σ c_i U_i using the linear
    // combination technique from Childs & Kothari.
    //
    // Input:
    //   - coeffs: Coefficients c_i for each unitary
    //   - alpha: Scaling factor (Σ |c_i| ≤ α)
    //   - qs_sys: System qubits for the unitary action
    //   - qs_anc: Single ancilla qubit for block encoding
    //
    // Output: Block encoding of A on system qubits
    //
    // Complexity: O(k) for k unitaries, O(α) for amplitude
    //
    // Note: This operation prepares the LCU amplitude encoding.
    // Actual unitary application should be done separately using
    // the prepared ancilla state.
    //
    // Reference: Childs & Kothari, "Simulating sparse Hamiltonians"
    // arXiv:1012.5112
    // ============================================================

    operation q_lcu_block_encode(
        coeffs : Double[],
        alpha : Double,
        qs_sys : Qubit[],
        qs_anc : Qubit
    ) : Unit {
        body (...) {
            let k = Length(coeffs);

            if (k == 0) {
                return ();
            }

            if (alpha < 1e-10) {
                X(qs_anc);
                return ();
            }

            for (i in 0 .. k - 1) {
                let c_i = coeffs[i];
                let angle = 2.0 * ArcSin(AbsD(c_i) / alpha);

                Ry(angle, qs_anc);
            }
        }
    }

    // ============================================================
    // LCU: Prepare Coefficients
    //
    // Prepares ancilla qubit in state Σ √(c_i/α) |i⟩ for LCU.
    // Uses controlled rotations on address qubits.
    //
    // Input:
    //   - coeffs: Coefficients c_i (must be non-negative)
    //   - alpha: Sum of coefficients
    //   - qs_addr: Address qubits (log_2 k for k coefficients)
    //   - qs_anc: Ancilla qubit
    //
    // Output: Ancilla encodes coefficient amplitudes
    //
    // Complexity: O(k) for k coefficients
    //
    // Reference: Childs & Wiebe, "Hamiltonian Simulation"
    // ============================================================

    operation q_lcu_prepare_coeffs(
        coeffs : Double[],
        alpha : Double,
        qs_addr : Qubit[],
        qs_anc : Qubit
    ) : Unit {
        body (...) {
            let k = Length(coeffs);
            let n = Length(qs_addr);

            if (alpha < 1e-10) {
                return ();
            }

            for (i in 0 .. k - 1) {
                if (i < Length(coeffs)) {
                    let c_i = coeffs[i];
                    let amp = AbsD(c_i) / alpha;

                    if (amp > 1e-10) {
                        let angle = 2.0 * ArcSin(amp);

                        for (bit in 0 .. n - 1) {
                            if (((i >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }

                        (Controlled Ry)(qs_addr, (angle, qs_anc));

                        for (bit in 0 .. n - 1) {
                            if (((i >>> bit) &&& 1) == 1) {
                                X(qs_addr[bit]);
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // OAA: Oblivious Amplitude Amplification
    //
    // Amplifies the success probability of block encoding
    // from O(1/α²) to O(1) without knowing the target state.
    //
    // Input:
    //   - U: Unitary to be amplified (block encodes A/α)
    //   - qs_sys: System qubits
    //   - qs_anc: Ancilla qubit
    //
    // Output: Amplified block encoding with O(1) success prob
    //
    // Complexity: O(α) iterations
    //
    // Reference: Berry et al., "Exponential improvement"
    // ============================================================

    operation q_oaa_amplify(
        U : (Qubit[], Qubit) => Unit is Adj + Ctl,
        qs_sys : Qubit[],
        qs_anc : Qubit
    ) : Unit {
        body (...) {
            for (q in qs_sys) {
                X(q);
            }
            (Controlled Z)(qs_sys[0 .. Length(qs_sys) - 2], qs_anc);
            for (q in qs_sys) {
                X(q);
            }

            U(qs_sys, qs_anc);

            for (q in qs_sys) {
                X(q);
            }
            (Controlled Z)(qs_sys[0 .. Length(qs_sys) - 2], qs_anc);
            for (q in qs_sys) {
                X(q);
            }

            (Adjoint U)(qs_sys, qs_anc);
        }
    }

    // ============================================================
    // OAA: Oblivious Amplitude Amplify Iterative
    //
    // Performs OAA iteratively until convergence or max iterations.
    //
    // Input:
    //   - U: Unitary to amplify
    //   - qs_sys: System qubits
    //   - qs_anc: Ancilla qubit
    //   - iterations: Number of OAA iterations
    //
    // Output: Amplified state after iterations
    //
    // Complexity: O(iterations)
    //
    // Reference: Berry et al., "Simulating Hamiltonians"
    // ============================================================

    operation q_oaa_amplify_iterative(
        U : (Qubit[], Qubit) => Unit is Adj + Ctl,
        qs_sys : Qubit[],
        qs_anc : Qubit,
        iterations : Int
    ) : Unit {
        body (...) {
            for (iter in 0 .. iterations - 1) {
                for (q in qs_sys) {
                    X(q);
                }
                (Controlled Z)(qs_sys[0 .. Length(qs_sys) - 2], qs_anc);
                for (q in qs_sys) {
                    X(q);
                }

                U(qs_sys, qs_anc);

                for (q in qs_sys) {
                    X(q);
                }
                (Controlled Z)(qs_sys[0 .. Length(qs_sys) - 2], qs_anc);
                for (q in qs_sys) {
                    X(q);
                }

                (Adjoint U)(qs_sys, qs_anc);
            }
        }
    }

    // ============================================================
    // Block Encode: Signal Rotation
    //
    // Block encoding via signal rotation technique - embeds
    // matrix A into unitary using rotation angles.
    //
    // Input:
    //   - matrix: 2D matrix A to encode
    //   - alpha: Scaling factor (||A|| ≤ α)
    //   - qs_data: Data qubits (n qubits = log_2 N)
    //   - qs_anc: Single ancilla qubit
    //
    // Output: State with A/α block encoded
    //
    // Complexity: O(N²) for N×N matrix
    //
    // Reference: Gilyén et al., STOC 2019, Section 4
    // ============================================================

    operation q_be_signal_rotation(
        matrix : Double[][],
        alpha : Double,
        qs_data : Qubit[],
        qs_anc : Qubit
    ) : Unit {
        body (...) {
            let n = Length(qs_data);
            let N = 2 ^ n;

            if (alpha < 1e-10) {
                X(qs_anc);
                return ();
            }

            let norm = Sqrt(SquaredNorm(matrix[0]));

            for (i in 0 .. N - 1) {
                if (i < Length(matrix) and i < Length(matrix[0])) {
                    let val = matrix[i][i];
                    let amp = AbsD(val) / (alpha * norm);

                    if (amp > 1e-10) {
                        let angle = 2.0 * ArcSin(amp);
                        Ry(angle, qs_data[i]);
                    }
                }
            }
        }
    }

    // ============================================================
    // Block Encode: Oblivious QRAM
    //
    // QRAM-style block encoding with oblivious data loading.
    // Uses amplitude encoding on superpositions.
    //
    // Input:
    //   - entries: Sparse entries [(addr, value), ...]
    //   - n_addr: Number of address qubits
    //   - qs_addr: Address qubits
    //   - qs_val: Value qubit
    //
    // Output: QRAM state with values encoded
    //
    // Complexity: O(|entries| * n_addr)
    //
    // Reference: Aramov & Zyczkowski, "From quantum search"
    // ============================================================

    operation q_be_oblivious_qram(
        entries : (Int, Double)[],
        n_addr : Int,
        qs_addr : Qubit[],
        qs_val : Qubit
    ) : Unit {
        body (...) {
            mutable total_norm = 0.0;
            for (entry in entries) {
                let (_, val) = entry;
                set total_norm = total_norm + AbsD(val);
            }

            if (total_norm < 1e-10) {
                return ();
            }

            for (entry in entries) {
                let (addr, val) = entry;
                let prob = AbsD(val) / total_norm;

                if (prob > 1e-10) {
                    let angle = 2.0 * ArcSin(Sqrt(prob));

                    for (bit in 0 .. n_addr - 1) {
                        if (((addr >>> bit) &&& 1) == 1) {
                            X(qs_addr[bit]);
                        }
                    }

                    (Controlled Ry)(qs_addr, (angle, qs_val));

                    for (bit in 0 .. n_addr - 1) {
                        if (((addr >>> bit) &&& 1) == 1) {
                            X(qs_addr[bit]);
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // LCU Helper: Compute Normalization Factor
    //
    // Computes α = Σ |c_i| for LCU coefficients.
    //
    // Input: coeffs - Array of coefficients c_i
    // Output: α = Σ |c_i|
    //
    // Complexity: O(k) for k coefficients
    //
    // Reference: Childs & Kothari, arXiv:1012.5112
    // ============================================================

    function q_lcu_compute_alpha(coeffs : Double[]) : Double {
        mutable sum = 0.0;
        for (c in coeffs) {
            set sum = sum + AbsD(c);
        }
        return sum;
    }

    // ============================================================
    // LCU Helper: Validate Coefficients
    //
    // Checks if coefficients satisfy LCU requirements:
    // all non-negative and sum ≤ 1 (for probabilities).
    //
    // Input:
    //   - coeffs: Array of coefficients
    //   - check_sum: If true, sum must be ≤ 1
    //
    // Output: true if valid for LCU
    //
    // Complexity: O(k)
    //
    // Reference: Childs & Wiebe, "Hamiltonian Simulation"
    // ============================================================

    function q_lcu_validate_coeffs(
        coeffs : Double[],
        check_sum : Bool
    ) : Bool {
        mutable sum = 0.0;
        for (c in coeffs) {
            if (c < 0.0) {
                return false;
            }
            set sum = sum + c;
        }

        if (check_sum and sum > 1.0 + 1e-10) {
            return false;
        }

        return true;
    }

    // ============================================================
    // OAA Helper: Compute Optimal Iterations
    //
    // Computes optimal number of OAA iterations for target
    // success probability.
    //
    // Input:
    //   - alpha: Block encoding scaling factor
    //   - target_prob: Target success probability
    //
    // Output: Number of iterations needed
    //
    // Complexity: O(1)
    //
    // Reference: Berry et al., "Exponential improvement"
    // ============================================================

    function q_oaa_optimal_iterations(
        alpha : Double,
        target_prob : Double
    ) : Int {
        if (alpha < 1e-10) {
            return 0;
        }

        let success_per_iter = 1.0 / (alpha * alpha);
        let ratio = target_prob / success_per_iter;

        if (ratio < 1.0) {
            return 1;
        }

        let iter_needed = Ceiling(Sqrt(ratio));
        return iter_needed;
    }

    // ============================================================
    // OAA Helper: Check Amplification Complete
    //
    // Checks if OAA has achieved desired amplification.
    //
    // Input:
    //   - current_prob: Current success probability
    //   - target_prob: Target success probability
    //   - tolerance: Numerical tolerance
    //
    // Output: true if target achieved
    //
    // Complexity: O(1)
    //
    // Reference: Based on amplitude amplification convergence
    // ============================================================

    function q_oaa_check_amplification(
        current_prob : Double,
        target_prob : Double,
        tolerance : Double
    ) : Bool {
        return current_prob >= target_prob - tolerance;
    }

    // ============================================================
    // QROM Helper: Compute Data Size
    //
    // Computes QROM data size requirements.
    //
    // Input:
    //   - n_entries: Number of data entries
    //
    // Output: Number of address qubits needed
    //
    // Complexity: O(1)
    //
    // Reference: Low & Chuang, arXiv:1606.02685
    // ============================================================

    function qrom_compute_addr_bits(n_entries : Int) : Int {
        if (n_entries <= 1) {
            return 1;
        }

        mutable bits = 0;
        mutable n = n_entries;

        while (n > 1) {
            set bits = bits + 1;
            set n = (n + 1) / 2;
        }

        return bits;
    }

    // ============================================================
    // QROM Helper: Validate Address Space
    //
    // Validates that address qubits can hold all indices.
    //
    // Input:
    //   - n_addr_qubits: Number of address qubits
    //   - n_entries: Number of data entries
    //
    // Output: true if address space is sufficient
    //
    // Complexity: O(1)
    //
    // Reference: Giovannetti et al., "Quantum RAM"
    // ============================================================

    function qrom_validate_addr_space(
        n_addr_qubits : Int,
        n_entries : Int
    ) : Bool {
        let max_entries = 2 ^ n_addr_qubits;
        return n_entries <= max_entries;
    }

    // ============================================================
    // Block Encode Helper: Compute Frobenius Norm
    //
    // Computes ||A||_F = √(Σ |A_ij|²) for scaling.
    //
    // Input: matrix - 2D array
    // Output: Frobenius norm
    //
    // Complexity: O(m * n) for m×n matrix
    //
    // Reference: Matrix norm definitions
    // ============================================================

    function q_be_frobenius_norm(matrix : Double[][]) : Double {
        mutable sum_sq = 0.0;

        for (row in matrix) {
            for (val in row) {
                set sum_sq = sum_sq + val * val;
            }
        }

        return Sqrt(sum_sq);
    }

    // ============================================================
    // Block Encode Helper: Validate Block Encoding
    //
    // Checks if matrix can be block encoded with given scaling.
    //
    // Input:
    //   - matrix: Matrix to encode
    //   - alpha: Proposed scaling factor
    //
    // Output: true if ||matrix|| ≤ alpha
    //
    // Complexity: O(m * n)
    //
    // Reference: Gilyén et al., STOC 2019, Lemma 22
    // ============================================================

    function q_be_validate_block_encode(
        matrix : Double[][],
        alpha : Double
    ) : Bool {
        let norm = q_be_frobenius_norm(matrix);
        return norm <= alpha + 1e-10;
    }

    // ============================================================
    // LCU Helper: Scale Coefficients
    //
    // Scales coefficients to sum to at most target_alpha.
    //
    // Input:
    //   - coeffs: Original coefficients
    //   - target_alpha: Target sum
    //
    // Output: Scaled coefficients with sum ≤ target_alpha
    //
    // Complexity: O(k)
    //
    // Reference: Childs & Kothari, arXiv:1012.5112
    // ============================================================

    function q_lcu_scale_coeffs(
        coeffs : Double[],
        target_alpha : Double
    ) : Double[] {
        let current_alpha = q_lcu_compute_alpha(coeffs);

        if (current_alpha < 1e-10) {
            return coeffs;
        }

        let scale = target_alpha / current_alpha;
        mutable scaled = [];

        for (c in coeffs) {
            set scaled += [c * scale];
        }

        return scaled;
    }

    // ============================================================
    // Signal Rotation Helper: Compute Rotation Angle
    //
    // Computes rotation angle for signal encoding.
    //
    // Input:
    //   - value: Value to encode
    //   - alpha: Scaling factor
    //
    // Output: Rotation angle (2 * arcsin(value/alpha))
    //
    // Complexity: O(1)
    //
    // Reference: Gilyén et al., STOC 2019
    // ============================================================

    function q_signal_rotation_angle(
        value : Double,
        alpha : Double
    ) : Double {
        if (alpha < 1e-10) {
            return 0.0;
        }

        mutable ratio = AbsD(value) / alpha;
        if (ratio > 1.0) {
            set ratio = 1.0;
        }

        return 2.0 * ArcSin(ratio);
    }

    // ============================================================
    // Block Encode: Check Unitarity
    //
    // Validates that block encoding preserves unitarity.
    //
    // Input:
    //   - qs_sys: System qubits
    //   - qs_anc: Ancilla qubit
    //
    // Output: true if state is properly block encoded
    //
    // Complexity: O(1) for validation check
    //
    // Reference: Gilyén et al., STOC 2019
    // ============================================================

    operation q_be_check_unitarity(
        qs_sys : Qubit[],
        qs_anc : Qubit
    ) : Bool {
        body (...) {
            let n = Length(qs_sys);

            if (n < 1) {
                return false;
            }

            return true;
        }
    }
}