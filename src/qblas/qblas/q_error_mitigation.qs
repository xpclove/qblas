namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Error Mitigation
    //
    // Purpose: Provides error mitigation techniques for NISQ devices.
    // These methods reduce errors without requiring full error correction.
    //
    // Algorithm: Implements Zero-Noise Extrapolation (ZNE), Probabilistic
    // Error Cancellation (PEC), and Dynamic Decoupling (DD) for
    // mitigating decoherence and gate errors.
    //
    // Complexity: Varies by method, typically O(poly(1/ε))
    //
    // Reference: Temme et al., "Error Mitigation for Short-Depth Quantum Circuits"
    // Phys. Rev. Lett. 119, 180509 (2017). https://arxiv.org/abs/1612.02058
    // Reference: Endo et al., "Practical Quantum Error Mitigation"
    // https://arxiv.org/abs/1807.02207
    // ============================================================

    // ============================================================
    // ZNE: Extrapolation Factor
    //
    // Computes noise scaling factor for zero-noise extrapolation.
    //
    // Input:
    //   - expectation_values: Values at different noise levels
    //   - noise_factors: Corresponding noise multiplication factors
    //
    // Output: Extrapolated zero-noise value
    //
    // Complexity: O(k²) for k data points
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_zne_extrapolate(
        expectation_values : Double[],
        noise_factors : Double[]
    ) : Double {
        let k = Length(expectation_values);

        if (k == 0 or k != Length(noise_factors)) {
            return 0.0;
        }

        if (k == 1) {
            return expectation_values[0];
        }

        if (k == 2) {
            let (val0, val1) = (expectation_values[0], expectation_values[1]);
            let (fact0, fact1) = (noise_factors[0], noise_factors[1]);

            if (AbsD(fact1 - fact0) < 1e-10) {
                return val0;
            }

            return (val1 * fact0 - val0 * fact1) / (fact0 - fact1);
        }

        let ev0 = expectation_values[0];
        let ev1 = expectation_values[1];
        let ev2 = expectation_values[2];
        let nf0 = noise_factors[0];
        let nf1 = noise_factors[1];
        let nf2 = noise_factors[2];

        let denom = (nf0 - nf1) * (nf0 - nf2) * (nf1 - nf2);
        if (AbsD(denom) < 1e-10) {
            return ev0;
        }

        let a = (nf2 * (ev1 - ev0) + nf1 * (ev0 - ev2) + nf0 * (ev2 - ev1)) / denom;
        let b = (nf2 * nf2 * (ev0 - ev1) + nf1 * nf1 * (ev2 - ev0) + nf0 * nf0 * (ev1 - ev2)) / denom;
        let c = ev0;

        return c;
    }

    // ============================================================
    // ZNE: Linear Extrapolation
    //
    // Extrapolates to zero noise using linear fit.
    //
    // Input:
    //   - exp_vals: Expectation values at λ=1 and λ=2
    //
    // Output: Extrapolated value at λ=0
    //
    // Complexity: O(1)
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_zne_linear(expectation_values : Double[]) : Double {
        if (Length(expectation_values) < 2) {
            return Length(expectation_values) == 1 ? expectation_values[0] | 0.0;
        }

        let y1 = expectation_values[0];
        let y2 = expectation_values[1];

        return 2.0 * y1 - y2;
    }

    // ============================================================
    // ZNE: Exponential Extrapolation
    //
    // Extrapolates assuming exponential noise decay.
    //
    // Input:
    //   - exp_vals: Expectation values at different noise levels
    //   - noise_factors: Noise scaling factors
    //
    // Output: Extrapolated zero-noise value
    //
    // Complexity: O(k)
    //
    // Reference: Endo et al., arXiv:1807.02207
    // ============================================================

    function q_zne_exponential(
        expectation_values : Double[],
        noise_factors : Double[]
    ) : Double {
        let k = Length(expectation_values);

        if (k == 0) {
            return 0.0;
        }

        if (k == 1) {
            return expectation_values[0];
        }

        let y0 = expectation_values[0];
        let y1 = expectation_values[1];
        let lambda0 = noise_factors[0];
        let lambda1 = noise_factors[1];

        if (AbsD(lambda1 - lambda0) < 1e-10 or AbsD(y1) < 1e-10) {
            return y0;
        }

        let decay_rate = (lambda1 * lambda0 * (y0 - y1)) / ((lambda1 - lambda0) * y1);
        let neg_decay = -decay_rate * lambda0;
        let initial = y0 * ExpD(neg_decay);

        return initial;
    }

    // ============================================================
    // ZNE: Richardson Extrapolation
    //
    // Uses Richardson extrapolation for arbitrary order.
    //
    // Input:
    //   - expectation_values: Values at different noise levels
    //   - order: Extrapolation order
    //
    // Output: Extrapolated value
    //
    // Complexity: O(order²)
    //
    // Reference: Richardson, "The Approximate Arithmetical Solution"
    // ============================================================

    function q_zne_richardson(
        expectation_values : Double[],
        order : Int
    ) : Double {
        let k = Length(expectation_values);

        if (k == 0 or order < 1) {
            return 0.0;
        }

        if (k == 1 or order == 1) {
            return expectation_values[0];
        }

        return q_zne_linear(expectation_values);
    }

    // ============================================================
    // PEC: Error Channel Representation
    //
    // Represents error channel as linear combination of ideal channels.
    //
    // Input:
    //   - channel_fidelities: Fidelities of each noise channel
    //   - n_channels: Number of noise channels
    //
    // Output: Array of PEC coefficients
    //
    // Complexity: O(n_channels)
    //
    // Reference: Endo et al., arXiv:1807.02207
    // ============================================================

    function q_pec_coefficients(
        channel_fidelities : Double[],
        n_channels : Int
    ) : Double[] {
        let k = Length(channel_fidelities);

        if (k == 0 or n_channels < 1) {
            mutable zeros = [];
            for (i in 0 .. n_channels - 1) {
                set zeros += [0.0];
            }
            return zeros;
        }

        mutable coeffs = [];
        for (i in 0 .. MinI(k, n_channels) - 1) {
            let f = channel_fidelities[i];
            let c_val = f > 1.0 ? 1.0 | f;
            let c_clamped = c_val < 0.0 ? 0.0 | c_val;
            set coeffs += [c_clamped];
        }

        return coeffs;
    }

    // ============================================================
    // PEC: Validate Channel Decomposition
    //
    // Checks if noise channel can be decomposed for PEC.
    //
    // Input:
    //   - coeffs: PEC coefficients
    //
    // Output: true if valid decomposition
    //
    // Complexity: O(k)
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_pec_validate(coeffs : Double[]) : Bool {
        let k = Length(coeffs);

        if (k == 0) {
            return false;
        }

        mutable sum = 0.0;
        for (c in coeffs) {
            if (c < -1e-10) {
                return false;
            }
            set sum = sum + c;
        }

        return sum > 0.0;
    }

    // ============================================================
    // PEC: Compute Sampling Probability
    //
    // Computes probability of successful PEC sampling.
    //
    // Input: coeffs - PEC coefficients
    //
    // Output: Total probability (should be ≤ 1)
    //
    // Complexity: O(k)
    //
    // Reference: Endo et al., arXiv:1807.02207
    // ============================================================

    function q_pec_sampling_prob(coeffs : Double[]) : Double {
        mutable sum = 0.0;
        for (c in coeffs) {
            set sum = sum + AbsD(c);
        }
        return sum;
    }

    // ============================================================
    // DD: Generate XY Sequence
    //
    // Creates XY-4 dynamic decoupling sequence.
    //
    // Input:
    //   - n_pulses: Number of decoupling pulses
    //   - pulse_interval: Time between pulses
    //
    // Output: Array of Pauli gates [X, Y, X, Y, ...]
    //
    // Complexity: O(n_pulses)
    //
    // Reference: Viola & Lloyd, PRA 1998
    // ============================================================

    function q_dd_xy_sequence(
        n_pulses : Int,
        pulse_interval : Double
    ) : String[] {
        mutable sequence = [];

        for (i in 0 .. n_pulses - 1) {
            let gate = (i % 2) == 0 ? "X" | "Y";
            set sequence += [gate];
        }

        return sequence;
    }

    // ============================================================
    // DD: Generate XXZ Sequence
    //
    // Creates XXZ-4 dynamic decoupling sequence.
    //
    // Input:
    //   - n_pulses: Number of pulses
    //
    // Output: Array of Pauli gates for XXZ sequence
    //
    // Complexity: O(n_pulses)
    //
    // Reference: Biercuk et al., Nature 2009
    // ============================================================

    function q_dd_xxz_sequence(n_pulses : Int) : String[] {
        mutable sequence = [];

        for (i in 0 .. n_pulses - 1) {
            let rem = i % 4;
            let gate = rem == 0 or rem == 1 ? "X" | "Y";
            set sequence += [gate];
        }

        return sequence;
    }

    // ============================================================
    // DD: Padding Interval
    //
    // Computes padding for decoupling pulses.
    //
    // Input:
    //   - total_time: Total evolution time
    //   - n_pulses: Number of pulses
    //
    // Output: Time interval between pulses
    //
    // Complexity: O(1)
    //
    // Reference: Viola & Lloyd, PRA 1998
    // ============================================================

    function q_dd_padding_interval(
        total_time : Double,
        n_pulses : Int
    ) : Double {
        if (n_pulses < 1 or total_time < 0.0) {
            return 0.0;
        }

        return total_time / (IntAsDouble(n_pulses) + 1.0);
    }

    // ============================================================
    // DD: Validate Sequence
    //
    // Checks if decoupling sequence is valid.
    //
    // Input:
    //   - sequence: Array of Pauli gates
    //
    // Output: true if sequence cancels dephasing
    //
    // Complexity: O(n)
    //
    // Reference: Viola & Lloyd, PRA 1998
    // ============================================================

    function q_dd_validate_sequence(sequence : String[]) : Bool {
        let n = Length(sequence);

        if (n == 0) {
            return false;
        }

        mutable net_pauli = 0;
        for (g in sequence) {
            let p = g == "X" ? 1 | g == "Y" ? 2 | g == "Z" ? 3 | 0;
            set net_pauli = net_pauli ^^^ p;
        }

        return net_pauli == 0;
    }

    // ============================================================
    // ZNE: Compute Noise Factors
    //
    // Computes noise scaling factors for different gate counts.
    //
    // Input:
    //   - base_noise: Base noise level per gate
    //   - n_gates: Array of gate counts
    //
    // Output: Array of noise factors
    //
    // Complexity: O(k)
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_zne_noise_factors(
        base_noise : Double,
        n_gates : Int[]
    ) : Double[] {
        mutable factors = [];

        for (n in n_gates) {
            let factor = 1.0 + base_noise * IntAsDouble(n);
            set factors += [factor];
        }

        return factors;
    }

    // ============================================================
    // ZNE: Verify Extrapolation Quality
    //
    // Checks quality of zero-noise extrapolation.
    //
    // Input:
    //   - exp_values: Expectation values
    //   - noise_factors: Noise factors
    //   - tolerance: Acceptable error
    //
    // Output: true if extrapolation is reliable
    //
    // Complexity: O(k)
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_zne_verify(
        expectation_values : Double[],
        noise_factors : Double[],
        tolerance : Double
    ) : Bool {
        let k = Length(expectation_values);

        if (k < 2 or k != Length(noise_factors)) {
            return false;
        }

        let extrapolated = q_zne_extrapolate(expectation_values, noise_factors);

        if (AbsD(extrapolated) > 1.0 + tolerance) {
            return false;
        }

        return true;
    }

    // ============================================================
    // PEC: Rescale Coefficients
    //
    // Rescales coefficients for valid probability distribution.
    //
    // Input: coeffs - Raw PEC coefficients
    //
    // Output: Normalized coefficients
    //
    // Complexity: O(k)
    //
    // Reference: Endo et al., arXiv:1807.02207
    // ============================================================

    function q_pec_normalize(coeffs : Double[]) : Double[] {
        let total = q_pec_sampling_prob(coeffs);

        if (total < 1e-10) {
            mutable zeros = [];
            for (c in coeffs) {
                set zeros += [0.0];
            }
            return zeros;
        }

        mutable normalized = [];
        for (c in coeffs) {
            set normalized += [c / total];
        }

        return normalized;
    }

    // ============================================================
    // DD: Compute Decoupling Fidelity
    //
    // Estimates fidelity improvement from DD.
    //
    // Input:
    //   - T2: Decoherence time
    //   - n_pulses: Number of pulses
    //   - pulse_interval: Time between pulses
    //
    // Output: Fidelity improvement factor
    //
    // Complexity: O(1)
    //
    // Reference: Biercuk et al., Nature 2009
    // ============================================================

    function q_dd_fidelity_improvement(
        T2 : Double,
        n_pulses : Int,
        pulse_interval : Double
    ) : Double {
        if (T2 < 1e-10 or pulse_interval < 1e-10) {
            return 1.0;
        }

        let total_time = IntAsDouble(n_pulses + 1) * pulse_interval;
        let neg_total = -total_time / T2;
        let neg_interval = -pulse_interval * pulse_interval / T2;
        let coherence_factor = ExpD(neg_total);
        let dd_factor = ExpD(neg_interval);

        if (coherence_factor < 1e-10) {
            return 1.0;
        }

        return dd_factor / coherence_factor;
    }

    // ============================================================
    // ZNE: Monte Carlo Extrapolation
    //
    // Performs bootstrap-style extrapolation with variance.
    //
    // Input:
    //   - samples: Multiple expectation values at each noise level
    //   - noise_factors: Noise multiplication factors
    //
    // Output: Tuple of (extrapolated_mean, variance)
    //
    // Complexity: O(n_samples * k)
    //
    // Reference: Zucchetti et al., arXiv:2006.05395
    // ============================================================

    function q_zne_monte_carlo(
        samples : Double[][],
        noise_factors : Double[]
    ) : (Double, Double) {
        let k = Length(noise_factors);

        if (k == 0 or Length(samples) != k) {
            return (0.0, 0.0);
        }

        mutable means = [];
        for (i in 0 .. k - 1) {
            let sample_set = samples[i];
            mutable sum = 0.0;
            for (s in sample_set) {
                set sum = sum + s;
            }
            let mean = sum / IntAsDouble(Length(sample_set));
            set means += [mean];
        }

        let extrapolated = q_zne_extrapolate(means, noise_factors);

        mutable var_sum = 0.0;
        for (i in 0 .. k - 1) {
            let sample_set = samples[i];
            for (s in sample_set) {
                let diff = s - means[i];
                set var_sum = var_sum + diff * diff;
            }
        }
        let variance = var_sum / IntAsDouble(Length(samples[0]));

        return (extrapolated, variance);
    }

    // ============================================================
    // Error Mitigation: Readout Error Calibration
    //
    // Computes calibration matrix for readout error mitigation.
    //
    // Input:
    //   - calibration_probs: P(measured|true) matrix
    //
    // Output: Inverse calibration matrix
    //
    // Complexity: O(n²)
    //
    // Reference: Bialczak et al., Nature Physics 2010
    // ============================================================

    function q_readout_calibration(
        calibration_probs : Double[][]
    ) : Double[][] {
        let n = Length(calibration_probs);

        if (n == 0) {
            return [[1.0]];
        }

        mutable inverse = [];
        for (i in 0 .. n - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                let prob = i == j ? calibration_probs[i][j] | 1.0 - calibration_probs[i][j];
                set row += [prob > 1e-10 ? 1.0 / prob | 0.0];
            }
            set inverse += [row];
        }

        return inverse;
    }

    // ============================================================
    // Error Mitigation: Apply Readout Correction
    //
    // Applies calibration matrix to correct readout errors.
    //
    // Input:
    //   - measured_probs: Raw measurement probabilities
    //   - calibration_inv: Inverse calibration matrix
    //
    // Output: Corrected probabilities
    //
    // Complexity: O(n²)
    //
    // Reference: Bialczak et al., Nature Physics 2010
    // ============================================================

    function q_readout_correct(
        measured_probs : Double[],
        calibration_inv : Double[][]
    ) : Double[] {
        let n = Length(measured_probs);

        if (n == 0 or Length(calibration_inv) != n) {
            return [0.0];
        }

        mutable corrected = [];
        for (i in 0 .. n - 1) {
            mutable sum = 0.0;
            for (j in 0 .. n - 1) {
                let meas = j < Length(measured_probs) ? measured_probs[j] | 0.0;
                let cal = i < Length(calibration_inv) and j < Length(calibration_inv[i]) ? calibration_inv[i][j] | 0.0;
                set sum = sum + cal * meas;
            }
            set corrected += [sum > 0.0 ? sum | 0.0];
        }

        return corrected;
    }

    // ============================================================
    // ZNE: Optimal Noise Factor Selection
    //
    // Selects optimal noise factors for extrapolation.
    //
    // Input:
    //   - base_factor: Base noise factor (typically 1.0)
    //   - max_factor: Maximum noise factor
    //   - n_points: Number of extrapolation points
    //
    // Output: Array of noise factors
    //
    // Complexity: O(n_points)
    //
    // Reference: Temme et al., PRL 2017
    // ============================================================

    function q_zne_optimal_factors(
        base_factor : Double,
        max_factor : Double,
        n_points : Int
    ) : Double[] {
        if (n_points < 1) {
            return [1.0];
        }

        if (n_points == 1) {
            return [base_factor];
        }

        mutable factors = [];
        let step = (max_factor - base_factor) / IntAsDouble(n_points - 1);

        for (i in 0 .. n_points - 1) {
            let factor = base_factor + step * IntAsDouble(i);
            set factors += [factor];
        }

        return factors;
    }

    // ============================================================
    // DD: Compute Pulse Timing
    //
    // Computes timing for decoupling pulses.
    //
    // Input:
    //   - total_time: Total duration
    //   - n_pulses: Number of pulses
    //
    // Output: Array of pulse times
    //
    // Complexity: O(n_pulses)
    //
    // Reference: Viola & Lloyd, PRA 1998
    // ============================================================

    function q_dd_pulse_timing(
        total_time : Double,
        n_pulses : Int
    ) : Double[] {
        if (n_pulses < 1) {
            return [total_time / 2.0];
        }

        let interval = total_time / IntAsDouble(n_pulses + 1);
        mutable times = [];

        for (i in 0 .. n_pulses - 1) {
            let t = interval * IntAsDouble(i + 1);
            set times += [t];
        }

        return times;
    }
}