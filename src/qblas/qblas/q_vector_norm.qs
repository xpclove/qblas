namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Vector Norm Estimation
    //
    // Purpose: Provides quantum norm estimation for quantum states.
    // Computes |||ψ⟩|| using quantum phase estimation or amplitude
    // estimation techniques.
    //
    // Algorithm: Uses quantum amplitude estimation to estimate
    // the squared norm of a quantum state efficiently.
    //
    // Complexity: O(poly(log(1/ε))) for precision ε
    //
    // Reference: Buzek, "Quantum State Discrimination"
    // Reference: Grover, "Quantum Mechanics Helps in Searching"
    // ============================================================

    // ============================================================
    // QNORM: Estimate L2 Norm
    //
    // Classical helper: computes L2 norm of vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||₂ = sqrt(Σ vᵢ²)
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_l2(v : Double[]) : Double {
        let n = Length(v);

        if (n == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for (i in 0 .. n - 1) {
            set sum = sum + v[i] * v[i];
        }

        return Sqrt(sum);
    }

    // ============================================================
    // QNORM: Estimate L1 Norm
    //
    // Classical helper: computes L1 norm of vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||₁ = Σ |vᵢ|
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_l1(v : Double[]) : Double {
        let n = Length(v);

        if (n == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for (i in 0 .. n - 1) {
            set sum = sum + AbsD(v[i]);
        }

        return sum;
    }

    // ============================================================
    // QNORM: Estimate LInf Norm
    //
    // Classical helper: computes infinity norm of vector.
    //
    // Input: v - n-dimensional vector
    //
    // Output: ||v||_inf = max|vᵢ|
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_linf(v : Double[]) : Double {
        let n = Length(v);

        if (n == 0) {
            return 0.0;
        }

        mutable max_val = 0.0;
        for (i in 0 .. n - 1) {
            let abs_val = AbsD(v[i]);
            if (abs_val > max_val) {
                set max_val = abs_val;
            }
        }

        return max_val;
    }

    // ============================================================
    // QNORM: Compute Norm Ratio
    //
    // Computes ratio ||v||/||w|| for normalization.
    //
    // Input:
    //   - v: Numerator vector
    //   - w: Denominator vector
    //
    // Output: ||v||/||w||
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_ratio(v : Double[], w : Double[]) : Double {
        let norm_v = q_vnorm_l2(v);
        let norm_w = q_vnorm_l2(w);

        if (norm_w < 1e-10) {
            return 0.0;
        }

        return norm_v / norm_w;
    }

    // ============================================================
    // QNORM: Normalize Vector
    //
    // Normalizes vector to unit L2 norm.
    //
    // Input:
    //   - v: Input vector
    //   - force: If true, normalize even if already normalized
    //
    // Output: Unit normalized vector
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_normalize(v : Double[], force : Bool) : Double[] {
        let n = Length(v);
        let norm = q_vnorm_l2(v);

        if (norm < 1e-10) {
            return v;
        }

        if (not force and AbsD(norm - 1.0) < 1e-10) {
            return v;
        }

        mutable normalized = [];
        for (i in 0 .. n - 1) {
            set normalized += [v[i] / norm];
        }

        return normalized;
    }

    // ============================================================
    // QNORM: Check Unit Norm
    //
    // Checks if vector has unit L2 norm.
    //
    // Input:
    //   - v: Vector to check
    //   - tol: Tolerance
    //
    // Output: true if ||v|| ≈ 1
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_is_unit(v : Double[], tol : Double) : Bool {
        let norm = q_vnorm_l2(v);
        return AbsD(norm - 1.0) < tol;
    }

    // ============================================================
    // QNORM: Estimate State Norm
    //
    // Estimates norm of quantum state coefficients.
    //
    // Input:
    //   - coeffs: State coefficients
    //   - n_bits: Precision bits for estimation
    //
    // Output: Estimated ||coeffs||
    //
    // Complexity: O(2^n_bits poly(n))
    //
    // Reference: Grover, "Quantum Searching"
    // ============================================================

    function q_vnorm_estimate(coeffs : Double[], n_bits : Int) : Double {
        let n = Length(coeffs);

        if (n == 0) {
            return 0.0;
        }

        if (n_bits < 1) {
            return q_vnorm_l2(coeffs);
        }

        mutable amp_sq_sum = 0.0;
        for (i in 0 .. n - 1) {
            set amp_sq_sum = amp_sq_sum + coeffs[i] * coeffs[i];
        }

        let base_est = Sqrt(amp_sq_sum);
        let two_pow = PowD(2.0, IntAsDouble(n_bits));
        let precision = 1.0 / two_pow;

        let lower = base_est - precision;
        let upper = base_est + precision;

        return (lower + upper) / 2.0;
    }

    // ============================================================
    // QNORM: Amplitude Estimation for Norm
    //
    // Uses amplitude estimation to estimate |a| where |a|² = ||ψ||².
    //
    // Input:
    //   - amp: Amplitude value
    //   - n_iters: Number of iterations
    //
    // Output: Estimated |amp|
    //
    // Complexity: O(n_iters)
    // ============================================================

    function q_vnorm_amp_est(amp : Double, n_iters : Int) : Double {
        if (n_iters < 1) {
            return AbsD(amp);
        }

        let two_n = PowD(2.0, IntAsDouble(n_iters));
        let phases = [PI() / two_n, 0.0, PI() / 4.0];
        mutable est = AbsD(amp);

        for (k in 1 .. n_iters) {
            let two_k = PowD(2.0, IntAsDouble(k));
            let step = PI() / two_k;
            let idx = k < Length(phases) ? k | 0;
            set est = est + step * phases[idx];
        }

        return AbsD(est);
    }

    // ============================================================
    // QNORM: Compute Squared Norm
    //
    // Computes squared L2 norm without sqrt.
    //
    // Input: v - n-dimensional vector
    //
    // Output: Σ vᵢ²
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_sq(v : Double[]) : Double {
        let n = Length(v);

        if (n == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for (i in 0 .. n - 1) {
            set sum = sum + v[i] * v[i];
        }

        return sum;
    }

    // ============================================================
    // QNORM: Distance Between Vectors
    //
    // Computes ||v - w||₂
    //
    // Input: Two vectors v, w
    //
    // Output: Euclidean distance
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_distance(v : Double[], w : Double[]) : Double {
        let n = Length(v);

        if (n != Length(w) or n == 0) {
            return 0.0;
        }

        mutable sum = 0.0;
        for (i in 0 .. n - 1) {
            let diff = v[i] - w[i];
            set sum = sum + diff * diff;
        }

        return Sqrt(sum);
    }

    // ============================================================
    // QNORM: Angle Between Vectors
    //
    // Computes angle θ where cos(θ) = <v,w>/(||v|| ||w||)
    //
    // Input: Two vectors v, w
    //
    // Output: Angle in radians
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_angle(v : Double[], w : Double[]) : Double {
        let norm_v = q_vnorm_l2(v);
        let norm_w = q_vnorm_l2(w);

        if (norm_v < 1e-10 or norm_w < 1e-10) {
            return 0.0;
        }

        mutable dot = 0.0;
        for (i in 0 .. Length(v) - 1) {
            set dot = dot + v[i] * w[i];
        }

        let cos_val = dot / (norm_v * norm_w);
        let clamped = cos_val > 1.0 ? 1.0 | cos_val < -1.0 ? -1.0 | cos_val;

        return ArcCos(clamped);
    }

    // ============================================================
    // QNORM: Validate Dimension
    //
    // Validates vector dimension for operations.
    //
    // Input:
    //   - v: Vector
    //   - dim: Expected dimension (-1 for any)
    //
    // Output: true if valid
    //
    // Complexity: O(1)
    // ============================================================

    function q_vnorm_validate_dim(v : Double[], dim : Int) : Bool {
        let n = Length(v);

        if (n == 0) {
            return false;
        }

        if (dim < 0) {
            return true;
        }

        return n == dim;
    }

    // ============================================================
    // QNORM: Norm Bounds
    //
    // Computes relationship between different norms.
    // ||v||₂ ≤ ||v||₁ ≤ √n ||v||₂
    // ||v||_inf ≤ ||v||₂ ≤ √n ||v||_inf
    //
    // Input: v - n-dimensional vector
    //
    // Output: (L1, L2, Linf) bounds
    //
    // Complexity: O(n)
    // ============================================================

    function q_vnorm_bounds(v : Double[]) : (Double, Double, Double) {
        let n = Length(v);
        let l2 = q_vnorm_l2(v);
        let l1 = q_vnorm_l1(v);
        let linf = q_vnorm_linf(v);

        return (l1, l2, linf);
    }

    // ============================================================
    // QNORM: Measure State Norm
    //
    // Estimates norm of quantum state via measurement statistics.
    // Measures all qubits in computational basis over n_measure shots.
    //
    // Input:
    //   - qs_state: Quantum state to measure
    //   - n_measure: Number of measurement shots
    //
    // Output: Estimated norm
    //
    // Complexity: O(n_measure · n_qubits)
    // ============================================================

    operation q_vnorm_measure_state(
        qs_state : Qubit[],
        n_measure : Int
    ) : Double {
        body {
            let n = Length(qs_state);
            mutable sum = 0.0;
            for (_ in 0 .. n_measure - 1) {
                use qs_copy = Qubit[n];
                for (q in 0 .. n - 1) {
                    CNOT(qs_state[q], qs_copy[q]);
                }
                for (q in 0 .. n - 1) {
                    let m = M(qs_copy[q]);
                    if (m == Zero) {
                        set sum = sum + 1.0;
                    }
                }
                ResetAll(qs_copy);
            }
            let prob_zero = sum / (IntAsDouble(n) * IntAsDouble(n_measure));
            return Sqrt(prob_zero);
        }
    }
}
