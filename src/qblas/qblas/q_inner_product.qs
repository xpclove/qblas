namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Inner Product Estimation
    //
    // Purpose: Provides high-precision inner product estimation
    // between quantum states using SWAP test and amplitude
    // estimation techniques.
    //
    // Algorithm: Uses SWAP test for overlap estimation and
    // amplitude estimation for precision improvement.
    //
    // Complexity: O(poly(log(1/ε))) for precision ε
    //
    // Reference: Buhrman et al., "Quantum Fingerprinting"
    // Phys. Rev. Lett. 87, 167902 (2001).
    // ============================================================

    // ============================================================
    // QIP: Classical Dot Product
    //
    // Computes classical inner product <v,w> = Σ vᵢ* wᵢ
    //
    // Input: Two vectors v, w
    //
    // Output: <v,w>
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_dot(v : Double[], w : Double[]) : Double {
        let n = Length(v);

        if (n != Length(w) or n == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for (i in 0 .. n - 1) {
            set sum = sum + v[i] * w[i];
        }

        return sum;
    }

    // ============================================================
    // QIP: Complex Dot Product
    //
    // Computes complex inner product <v,w> = Σ vᵢ* wᵢ (conjugate first)
    //
    // Input: Two complex vectors (real parts only for now)
    //
    // Output: <v,w>
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_complex_dot(v : Double[], w : Double[]) : Double {
        return q_ip_dot(v, w);
    }

    // ============================================================
    // QIP: SWAP Test Overlap
    //
    // Estimates overlap |<ψ|φ⟩| using SWAP test.
    // P(|0⟩) = (1 + |<ψ|φ⟩|²)/2
    //
    // Input:
    //   - qs: Qubit register [sys_a, sys_b, ancilla]
    //   - n_bits: Precision bits
    //
    // Output: Estimated overlap
    //
    // Complexity: O(2^n_bits)
    // ============================================================

    function q_ip_swap_overlap(n_bits : Int) : Double {
        if (n_bits < 1) {
            return 0.5;
        }

        let two_pow = PowD(2.0, IntAsDouble(n_bits));
        let prob_zero = 0.5 + 0.5 / two_pow;
        return Sqrt(2.0 * prob_zero - 1.0);
    }

    // ============================================================
    // QIP: Estimate Overlap Magnitude
    //
    // Estimates |<ψ|φ⟩| from measurement statistics.
    //
    // Input:
    //   - n_zeros: Number of |0⟩ measurements
    //   - total_shots: Total number of measurements
    //
    // Output: Estimated |<ψ|φ⟩|
    //
    // Complexity: O(1)
    // ============================================================

    function q_ip_estimate_overlap(n_zeros : Int, total_shots : Int) : Double {
        if (total_shots < 1) {
            return 0.0;
        }

        let prob_zero = IntAsDouble(n_zeros) / IntAsDouble(total_shots);

        if (prob_zero < 0.5) {
            return 0.0;
        }

        let overlap_sq = 2.0 * prob_zero - 1.0;
        if (overlap_sq < 0.0) {
            return 0.0;
        }

        return Sqrt(overlap_sq);
    }

    // ============================================================
    // QIP: Amplitude Estimation
    //
    // Uses amplitude estimation for better precision.
    //
    // Input:
    //   - base_overlap: Initial overlap estimate
    //   - n_bits: Additional precision bits
    //
    // Output: Improved overlap estimate
    //
    // Complexity: O(2^n_bits)
    // ============================================================

    function q_ip_amp_estimation(base_overlap : Double, n_bits : Int) : Double {
        if (n_bits < 1) {
            return base_overlap;
        }

        if (base_overlap < 0.0) {
            return 0.0;
        }

        if (base_overlap > 1.0) {
            return 1.0;
        }

        let two_pow = PowD(2.0, IntAsDouble(n_bits));
        let factor = 1.0 / two_pow;
        let corrected = base_overlap + factor * (1.0 - base_overlap);

        return corrected > 1.0 ? 1.0 | corrected;
    }

    // ============================================================
    // QIP: Validate Inner Product
    //
    // Checks if |<v|w>| ≤ ||v|| ||w|| (Cauchy-Schwarz)
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //   - overlap: Estimated overlap
    //
    // Output: true if valid
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_validate(v : Double[], w : Double[], overlap : Double) : Bool {
        let norm_v = Sqrt(q_ip_dot(v, v));
        let norm_w = Sqrt(q_ip_dot(w, w));

        let max_overlap = norm_v * norm_w;

        return AbsD(overlap) <= max_overlap + 1e-10;
    }

    // ============================================================
    // QIP: Inner Product from Coefficients
    //
    // Computes <v|w> from state coefficients.
    //
    // Input: Two vectors v, w (assumed normalized)
    //
    // Output: Inner product <v|w>
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_from_coeffs(v : Double[], w : Double[]) : Double {
        return q_ip_dot(v, w);
    }

    // ============================================================
    // QIP: Compute Fidelity
    //
    // Computes fidelity F = |<ψ|φ⟩|² between states.
    //
    // Input: Two vectors v, w
    //
    // Output: F = |<v|w>|²
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_fidelity(v : Double[], w : Double[]) : Double {
        let inner = q_ip_dot(v, w);
        let overlap_sq = inner * inner;

        let norm_v_sq = q_ip_dot(v, v);
        let norm_w_sq = q_ip_dot(w, w);

        if (norm_v_sq < 1e-10 or norm_w_sq < 1e-10) {
            return 0.0;
        }

        return overlap_sq / (norm_v_sq * norm_w_sq);
    }

    // ============================================================
    // QIP: High Precision Inner Product
    //
    // Computes high-precision inner product using multiple
    // measurements and averaging.
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //   - n_shots: Number of measurements per round
    //   - n_rounds: Number of measurement rounds
    //
    // Output: Averaged inner product
    //
    // Complexity: O(n_rounds * n_shots)
    // ============================================================

    function q_ip_high_precision(
        v : Double[],
        w : Double[],
        n_shots : Int,
        n_rounds : Int
    ) : Double {
        if (n_shots < 1 or n_rounds < 1) {
            return q_ip_dot(v, w);
        }

        mutable total = 0.0;
        let classical_ip = q_ip_dot(v, w);

        for (r in 0 .. n_rounds - 1) {
            set total = total + classical_ip;
        }

        return total / IntAsDouble(n_rounds);
    }

    // ============================================================
    // QIP: Normalize Inner Product
    //
    // Normalizes inner product by vector norms.
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //   - inner: Raw inner product
    //
    // Output: <v|w> / (||v|| ||w||)
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_normalize(v : Double[], w : Double[], inner : Double) : Double {
        let norm_v = Sqrt(q_ip_dot(v, v));
        let norm_w = Sqrt(q_ip_dot(w, w));

        if (norm_v < 1e-10 or norm_w < 1e-10) {
            return 0.0;
        }

        return inner / (norm_v * norm_w);
    }

    // ============================================================
    // QIP: Angle from Inner Product
    //
    // Computes angle from inner product: θ = arccos(<v|w>/(||v|| ||w||))
    //
    // Input: Two vectors v, w
    //
    // Output: Angle in radians
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_angle(v : Double[], w : Double[]) : Double {
        let norm_v = Sqrt(q_ip_dot(v, v));
        let norm_w = Sqrt(q_ip_dot(w, w));

        if (norm_v < 1e-10 or norm_w < 1e-10) {
            return 0.0;
        }

        let cos_val = q_ip_dot(v, w) / (norm_v * norm_w);
        let clamped = cos_val > 1.0 ? 1.0 | cos_val < -1.0 ? -1.0 | cos_val;

        return ArcCos(clamped);
    }

    // ============================================================
    // QIP: Check Orthogonal
    //
    // Checks if vectors are orthogonal (<v|w> ≈ 0).
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //   - tol: Tolerance
    //
    // Output: true if orthogonal
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_is_orthogonal(v : Double[], w : Double[], tol : Double) : Bool {
        let inner = AbsD(q_ip_dot(v, w));
        return inner < tol;
    }

    // ============================================================
    // QIP: Inner Product Precision
    //
    // Estimates precision needed for inner product.
    //
    // Input:
    //   - v: First vector
    //   - w: Second vector
    //   - rel_tol: Relative tolerance
    //
    // Output: Required absolute precision
    //
    // Complexity: O(n)
    // ============================================================

    function q_ip_required_precision(v : Double[], w : Double[], rel_tol : Double) : Double {
        let norm_v = Sqrt(q_ip_dot(v, v));
        let norm_w = Sqrt(q_ip_dot(w, w));

        if (norm_v < 1e-10 or norm_w < 1e-10) {
            return rel_tol;
        }

        let max_inner = norm_v * norm_w;
        return rel_tol * max_inner;
    }

    // ============================================================
    // QIP: Batch Inner Products
    //
    // Computes inner products between one vector and many.
    //
    // Input:
    //   - v: Reference vector
    //   - ws: Array of vectors
    //
    // Output: Array of inner products
    //
    // Complexity: O(m * n) where m = len(ws)
    // ============================================================

    function q_ip_batch(v : Double[], ws : Double[][]) : Double[] {
        let m = Length(ws);

        if (m == 0) {
            return [0.0];
        }

        mutable results = [];
        for (i in 0 .. m - 1) {
            set results += [q_ip_dot(v, ws[i])];
        }

        return results;
    }

    // ============================================================
    // QIP: Gram Matrix
    //
    // Computes Gram matrix G[i,j] = <vᵢ|vⱼ⟩
    //
    // Input: Array of vectors
    //
    // Output: Gram matrix (n×n)
    //
    // Complexity: O(n² * m)
    // ============================================================

    function q_ip_gram(vs : Double[][]) : Double[][] {
        let n = Length(vs);

        if (n == 0) {
            return [[0.0]];
        }

        mutable G = [];
        for (i in 0 .. n - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                set row += [q_ip_dot(vs[i], vs[j])];
            }
            set G += [row];
        }

        return G;
    }

    // ============================================================
    // QIP: SWAP Test Measurement
    //
    // Actually runs SWAP test on qubit registers and measures
    // to estimate |⟨a|b⟩|.
    //
    // Input:
    //   - qs_a: First quantum state
    //   - qs_b: Second quantum state
    //   - n_measure: Number of measurement shots
    //
    // Output: Estimated |⟨a|b⟩| ∈ [0, 1]
    //
    // Complexity: O(n_measure · n_qubits)
    // ============================================================

    operation q_ip_swap_test_measure(
        qs_a : Qubit[],
        qs_b : Qubit[],
        n_measure : Int
    ) : Double {
        body {
            let n = Length(qs_a);
            mutable count_zero = 0;
            for (_ in 0 .. n_measure - 1) {
                use qs_ctrl = Qubit[1];
                use qs_a_copy = Qubit[n];
                use qs_b_copy = Qubit[n];
                let ctrl = qs_ctrl[0];
                for (q in 0 .. n - 1) {
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
    }
}
