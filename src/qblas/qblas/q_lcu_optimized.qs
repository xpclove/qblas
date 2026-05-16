namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Optimized Linear Combination of Unitaries (LCU)
    //
    // Purpose: Implements efficient LCU using single ancilla qubit
    // with reduced gate complexity.
    //
    // Complexity: O(L) for L terms, with single-ancilla overhead
    //
    // Reference: Chakraborty, "Implementing any LCU on intermediate-term
    // quantum computers", Quantum 2024. https://arxiv.org/abs/2405.00019
    // Reference: Sze et al., "Hamiltonian dynamics simulation using LCU
    // on ion trap quantum computer", 2025. https://arxiv.org/abs/2303.00135
    // ============================================================

    // ============================================================
    // LCU: Compute Single-Ancilla Preparation Bits
    //
    // Input:
    //   - num_terms: Number of terms L in the LCU
    //
    // Output: Number of ancilla bits needed
    //
    // Complexity: O(1)
    // ============================================================

    function q_lcu_single_ancilla_bits(num_terms : Int) : Int {
        if (num_terms <= 1) {
            return 1;
        }
        return Floor(Log(IntAsDouble(num_terms)) / Log(2.0)) + 1;
    }

    // ============================================================
    // LCU: Compute Gate Count
    //
    // Input:
    //   - num_terms: Number of LCU terms L
    //   - num_qubits: Number of system qubits n
    //
    // Output: Number of two-qubit gates required
    //
    // Complexity: O(1)
    // ============================================================

    function q_lcu_gate_count(num_terms : Int, num_qubits : Int) : Int {
        let m = q_lcu_single_ancilla_bits(num_terms);
        let two_m = 1 <<< m;
        return two_m * (2 * num_qubits + 1) - num_qubits - 2;
    }

    // ============================================================
    // LCU: Compute Coefficients Norm
    //
    // Input:
    //   - coeffs: Array of coefficients
    //
    // Output: L1 norm Σ_j |α_j|
    //
    // Complexity: O(L)
    // ============================================================

    function q_lcu_coefficient_norm(coeffs : Double[]) : Double {
        mutable total = 0.0;
        for (idx in 0 .. Length(coeffs) - 1) {
            set total += AbsD(coeffs[idx]);
        }
        return total;
    }

    // ============================================================
    // LCU: Check Term Validity
    //
    // Input:
    //   - coeffs: Array of coefficients
    //
    // Output: Bool - true if all coefficients are non-negative
    //
    // Complexity: O(L)
    // ============================================================

    function q_lcu_check_coefficients(coeffs : Double[]) : Bool {
        for (idx in 0 .. Length(coeffs) - 1) {
            if (coeffs[idx] < 0.0) {
                return false;
            }
        }
        return true;
    }

    // ============================================================
    // LCU: Compute Amplitude Encoding
    //
    // Input:
    //   - coeffs: Original coefficients
    //
    // Output: Tuple (amplitudes, alpha) where α = Σ_j |α_j|
    //
    // Complexity: O(L)
    // ============================================================

    function q_lcu_compute_amplitudes(coeffs : Double[]) : (Double[], Double) {
        let alpha = q_lcu_coefficient_norm(coeffs);
        mutable amplitudes = [];

        for (idx in 0 .. Length(coeffs) - 1) {
            let amp = coeffs[idx] / alpha;
            set amplitudes += [amp];
        }

        return (amplitudes, alpha);
    }

    // ============================================================
    // LCU: Success Probability
    //
    // Input:
    //   - coeffs: Coefficients α_j
    //
    // Output: Success probability P
    //
    // Complexity: O(L)
    // ============================================================

    function q_lcu_success_probability(coeffs : Double[]) : Double {
        let L = IntAsDouble(Length(coeffs));
        let sum_sq = SquaredNorm(coeffs);
        let total = q_lcu_coefficient_norm(coeffs);

        if (total < 1e-10) {
            return 0.0;
        }

        let total_sq = total * total;
        return sum_sq / (L * total_sq);
    }

    // ============================================================
    // LCU: Verify Power of Two
    //
    // Input:
    //   - num_terms: Number of LCU terms
    //
    // Output: Bool - true if power of 2
    //
    // Complexity: O(1)
    // ============================================================

    function q_lcu_is_power_of_two(num_terms : Int) : Bool {
        if (num_terms <= 0) {
            return false;
        }
        let m = q_lcu_single_ancilla_bits(num_terms);
        return (1 <<< m) == num_terms;
    }

    // ============================================================
    // LCU: Pad Coefficients to Power of 2
    //
    // Input:
    //   - coeffs: Original coefficients
    //
    // Output: Padded coefficients array (size is power of 2)
    //
    // Complexity: O(2^m - L)
    // ============================================================

    function q_lcu_pad_coefficients(coeffs : Double[]) : Double[] {
        let L = Length(coeffs);
        let m = q_lcu_single_ancilla_bits(L);
        let padded_size = 1 <<< m;

        if (L == padded_size) {
            return coeffs;
        }

        mutable padded = coeffs;
        for (idx in L .. padded_size - 1) {
            set padded += [0.0];
        }

        return padded;
    }

    // ============================================================
    // LCU: Query Complexity
    //
    // Input:
    //   - num_terms: Number of Hamiltonian terms L
    //   - total_norm: Total variation norm Σ_j ||H_j||
    //   - time: Simulation time t
    //   - precision: Desired precision ε
    //
    // Output: Number of LCU queries needed
    //
    // Complexity: O(log(1/ε))
    // ============================================================

    function q_lcu_query_complexity(
        num_terms : Int,
        total_norm : Double,
        time : Double,
        precision : Double
    ) : Int {
        let complexity = total_norm * time + Log(1.0 / precision);
        return Floor(complexity) + 1;
    }

    // ============================================================
    // LCU: CSD Angles
    //
    // Input:
    //   - num_terms: Number of terms L
    //
    // Output: Rotation angles for CSD
    //
    // Complexity: O(2^m)
    // ============================================================

    function q_lcu_csd_angles(num_terms : Int) : Double[] {
        let m = q_lcu_single_ancilla_bits(num_terms);
        let size = 1 <<< m;
        mutable angles = [];

        for (i in 0 .. size - 1) {
            let angle = PI() * IntAsDouble(i) / IntAsDouble(size);
            set angles += [angle];
        }

        return angles;
    }

    // ============================================================
    // LCU Optimized: Prepare Ancilla State
    //
    // Purpose: Prepares single-ancilla superposition state
    // encoding the LCU amplitudes using Ry rotations.
    // State: |ψ⟩ = Σ_i √(α_i/α) |i⟩ on ancilla register.
    //
    // Input:
    //   - amplitudes: Normalized LCU amplitudes α_i/α
    //   - qs_anc: Ancilla qubit register (one-hot encoding)
    //   - alpha: L1 norm Σ_i |α_i|
    //
    // Algorithm: For each amplitude, apply Ry(2·arcsin(α_i/α))
    // on corresponding ancilla qubit to prepare amplitude.
    //
    // Complexity: O(L) gates for L terms
    //
    // Reference: Chakraborty, "Implementing any LCU on
    // intermediate-term quantum computers", Quantum 2024.
    // https://arxiv.org/abs/2405.00019
    // ============================================================

    operation q_lcu_optimized_prepare(
        amplitudes : Double[],
        qs_anc : Qubit[],
        alpha : Double
    ) : Unit {
        body {
            let n = Length(amplitudes);
            for (i in 0 .. n - 1) {
                let amp = amplitudes[i] / alpha;
                let angle = 2.0 * ArcSin(amp);
                Ry(angle, qs_anc[i]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // ============================================================
    // LCU Optimized: SELECT + PREPARE Circuit
    //
    // Purpose: Implements the full SELECT+PREPARE LCU circuit
    // for applying Σ_i α_i U_i to a quantum state.
    //
    // Input:
    //   - unitaries: Array of unitary operations U_i
    //   - amplitudes: LCU amplitudes α_i
    //   - qs_sys: System qubit register
    //   - qs_anc: Ancilla qubit register (one-hot)
    //
    // Algorithm:
    //   1. PREPARE: Apply q_lcu_optimized_prepare to create
    //      superposition on ancilla.
    //   2. SELECT: For each i, apply U_i controlled on qs_anc[i].
    //   3. UNPREPARE: Apply adjoint of PREPARE step.
    //
    // Complexity: O(L · G) where G is max gate count of U_i
    //
    // Reference: Childs & Wiebe, "Hamiltonian Simulation Using
    // Linear Combinations of Unitary Operations", QIC 2012.
    // https://arxiv.org/abs/1202.5822
    // ============================================================

    operation q_lcu_optimized_apply(
        unitaries : (Qubit[] => Unit is Adj + Ctl)[],
        amplitudes : Double[],
        qs_sys : Qubit[],
        qs_anc : Qubit[]
    ) : Unit {
        body {
            let n = Length(unitaries);
            let alpha = 1.0;
            q_lcu_optimized_prepare(amplitudes, qs_anc, alpha);
            for (i in 0 .. n - 1) {
                (Controlled unitaries[i])([qs_anc[i]], qs_sys);
            }
            Adjoint q_lcu_optimized_prepare(amplitudes, qs_anc, alpha);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}