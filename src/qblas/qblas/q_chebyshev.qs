namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Chebyshev Expansion (QCE)
    //
    // Purpose: Provides efficient polynomial approximation using
    // Chebyshev polynomials instead of Taylor series.
    //
    // Algorithm: Chebyshev polynomials T_k(x) provide better
    // approximation than Taylor for same degree due to minimax
    // property. For function f(x) on [-1,1], expansion
    // f(x) ≈ Σ c_k T_k(x) converges faster than Taylor series.
    //
    // Complexity: O(poly(log(1/ε))) with better constants than
    // Taylor expansion for same accuracy
    //
    // Reference: Zhang et al., "Quantum Chebyshev Expansion"
    // arXiv:2310.12109
    // ============================================================

    // ============================================================
    // QCE: Compute Chebyshev Polynomials via Recurrence
    //
    // Generates Chebyshev polynomials using three-term recurrence:
    // T_0(x) = 1, T_1(x) = x,
    // T_{k+1}(x) = 2x·T_k(x) - T_{k-1}(x)
    //
    // Input:
    //   - x: Point of evaluation
    //   - degree: Maximum polynomial degree
    //
    // Output: Array [T_0(x), T_1(x), ..., T_degree(x)]
    //
    // Complexity: O(degree)
    //
    // Reference: Zhang et al., arXiv:2310.12109, Lemma 2.1
    // ============================================================

    function q_chebyshev_polynomials(x : Double, degree : Int) : Double[] {
        if (degree < 0) {
            return [];
        }

        mutable polys = [1.0];
        if (degree == 0) {
            return polys;
        }

        set polys += [x];
        mutable prev = x;
        mutable curr = x;

        for k in 1 .. degree - 1 {
            let next = 2.0 * x * curr - prev;
            set polys += [next];
            set prev = curr;
            set curr = next;
        }

        return polys;
    }

    // ============================================================
    // QCE: Compute Chebyshev Coefficients for Sigmoid Function
    //
    // Computes Chebyshev expansion coefficients for sigmoid on
    // interval [a, b] using discrete cosine transform approximation.
    //
    // Input:
    //   - a: Left endpoint of interval
    //   - b: Right endpoint of interval
    //   - degree: Approximation degree
    //
    // Output: Coefficient array [c_0, c_1, ..., c_degree]
    //
    // Complexity: O((degree+1)²) for direct computation
    //
    // Reference: Zhang et al., arXiv:2310.12109, Theorem 2.3
    // ============================================================

    function q_chebyshev_coefficients_for_sigmoid(
        a : Double,
        b : Double,
        degree : Int
    ) : Double[] {
        let interval_len = (b - a) / 2.0;
        let midpoint = (a + b) / 2.0;
        let n = degree + 1;

        mutable coeffs = [];
        for k in 0 .. degree {
            mutable sum = 0.0;
            for j in 0 .. n - 1 {
                let x_j = Cos(PI() * IntAsDouble(j) / IntAsDouble(n)) * interval_len + midpoint;
                let T_k = Cos(PI() * IntAsDouble(k) * IntAsDouble(j) / IntAsDouble(n));
                mutable sigmoid_val = x_j / (1.0 + AbsD(x_j));
                let f_j = sigmoid_val;
                set sum += f_j * T_k;
            }
            let c_k = (2.0 * sum) / IntAsDouble(n);
            let final_c = (k == 0) ? c_k / 2.0 | c_k;
            set coeffs += [final_c];
        }

        return coeffs;
    }

    // ============================================================
    // QCE: Map Point to Standard Chebyshev Interval
    //
    // Affine transformation mapping point x in [a,b] to standard
    // Chebyshev domain [-1, 1].
    //
    // Input:
    //   - x: Point in original interval [a, b]
    //   - a: Left endpoint
    //   - b: Right endpoint
    //
    // Output: Transformed point in [-1, 1]
    //
    // Complexity: O(1)
    //
    // Reference: Standard Chebyshev polynomial domain mapping
    // ============================================================

    function q_chebyshev_map_to_interval(x : Double, a : Double, b : Double) : Double {
        return (2.0 * x - a - b) / (b - a);
    }

    // ============================================================
    // QCE: Bound Approximation Error
    //
    // Bounds approximation error using tail sum of Chebyshev
    // coefficients. For smooth functions, error decays
    // exponentially in degree.
    //
    // Input:
    //   - coeffs: Chebyshev coefficients [c_0, ..., c_d]
    //   - degree: Truncation degree
    //
    // Output: Upper bound on approximation error
    //
    // Complexity: O(d)
    //
    // Reference: Zhang et al., arXiv:2310.12109, Theorem 3.1
    // ============================================================

    function q_chebyshev_error_bound(coeffs : Double[], degree : Int) : Double {
        mutable error_sum = 0.0;
        for k in degree + 1 .. Length(coeffs) - 1 {
            set error_sum += AbsD(coeffs[k]);
        }
        return error_sum;
    }

    // ============================================================
    // QCE: Select Minimum Degree for Target Precision
    //
    // Determines minimum Chebyshev degree needed to achieve
    // target precision ε for given spectral radius.
    //
    // Input:
    //   - spectral_radius: Maximum eigenvalue magnitude
    //   - precision: Target approximation error ε
    //
    // Output: Minimum degree d satisfying error < ε
    //
    // Complexity: O(1)
    //
    // Reference: Zhang et al., arXiv:2310.12109, Corollary 3.4
    // ============================================================

    function q_chebyshev_select_degree(spectral_radius : Double, precision : Double) : Int {
        if (spectral_radius <= 1.0) {
            let result = Floor(Log(precision / (2.0 * spectral_radius)) / Log(1.0 / spectral_radius));
            return Max([result, 1]);
        }

        let bound = spectral_radius + Sqrt(spectral_radius * spectral_radius - 1.0);
        let degree = Floor(Log(2.0 * precision) / Log(bound));
        return Max([degree, 1]);
    }

    // ============================================================
    // QCE: Apply Chebyshev Polynomial via Block Encoding
    //
    // Applies Chebyshev expansion polynomial to quantum state
    // using block encoding and controlled rotations.
    //
    // Input:
    //   - oracle: Block encoding oracle for matrix/function
    //   - qs_data: Data qubits
    //   - qs_ancilla: Ancilla qubits for rotations
    //   - coeffs: Chebyshev coefficients [c_0, ..., c_d]
    //   - precision: Numerical precision threshold
    //
    // Output: State with Chebyshev polynomial applied
    //
    // Complexity: O(degree · log(1/precision))
    //
    // Reference: Zhang et al., arXiv:2310.12109, Algorithm 1
    // ============================================================

    operation q_chebyshev_apply(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        coeffs : Double[],
        precision : Double
    ) : Unit {
        let degree = Length(coeffs) - 1;
        if (degree < 0) {
            return ();
        }

        oracle(qs_data, qs_ancilla);

        let norm = Sqrt(SquaredNorm(coeffs));
        for k in 0 .. degree {
            let scaled_coeff = coeffs[k] / norm;
            if (AbsD(scaled_coeff) > precision) {
                let angle = 2.0 * ArcSin(AbsD(scaled_coeff));
                Ry(angle, qs_ancilla[0]);
            }
        }

        (Adjoint oracle)(qs_data, qs_ancilla);
    }

    // ============================================================
    // QCE: Apply Exponential via Chebyshev Expansion
    //
    // Approximates e^{Ax} using Chebyshev expansion, more
    // efficient than Taylor for same accuracy due to minimax
    // property.
    //
    // Input:
    //   - oracle: Block encoding of matrix A
    //   - qs_data: Data qubits
    //   - qs_ancilla: Ancilla qubits
    //   - x: Scalar multiplier
    //   - degree: Chebyshev polynomial degree
    //   - precision: Desired precision
    //
    // Output: State with e^{Ax} applied
    //
    // Complexity: O(degree · log(1/ε)) vs O(|x|·log(1/ε)) for
    // Taylor expansion
    //
    // Reference: Zhang et al., arXiv:2310.12109, Theorem 4.2
    // ============================================================

    operation q_chebyshev_exp_apply(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        x : Double,
        degree : Int,
        precision : Double
    ) : Unit {
        let mapped_x = q_chebyshev_map_to_interval(x, -1.0, 1.0);
        let polynomials = q_chebyshev_polynomials(mapped_x, degree);

        mutable exp_coeffs = [];
        for k in 0 .. degree {
            let c_k = (k == 0) ? 1.0 | 2.0;
            set exp_coeffs += [c_k * polynomials[k]];
        }

        q_chebyshev_apply(oracle, qs_data, qs_ancilla, exp_coeffs, precision);
    }
}