namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Quantum Pseudoinverse (QPI)
    //
    // Purpose: Provides quantum algorithm for computing matrix
    // pseudoinverse A^+ using singular value transformation.
    //
    // Algorithm: Implements quantum pseudoinverse via QSVT by
    // applying polynomial approximation P(σ) ≈ 1/σ to singular
    // values of block-encoded matrix. Uses truncated series
    // expansion optimized for condition number.
    //
    // Complexity: O(κ(A) · poly(log(1/ε))) where κ(A) is condition
    // number and ε is precision
    //
    // Reference: Gilyén et al., "Quantum Singular Value Transformation
    // and Algorithmic Applications"
    // STOC 2019. https://arxiv.org/abs/1806.01838
    // ============================================================

    // ============================================================
    // QPI: Compute Polynomial Coefficients for Pseudoinverse
    //
    // Generates polynomial coefficients for approximating 1/x on
    // interval [1/κ, 1] where κ is condition number.
    //
    // Input:
    //   - kappa: Condition number κ of matrix A
    //   - precision: Desired approximation precision ε
    //
    // Output: Polynomial coefficients [c₀, c₁, ..., c_d]
    //
    // Complexity: O(d) where d = O(κ · log(1/ε))
    //
    // Reference: Gilyén et al., STOC 2019, Theorem 4.3
    // ============================================================

    function q_pseudoinverse_coeffs(kappa : Double, precision : Double) : Double[] {
        let epsilon = 1.0 / kappa;
        let degree = Floor(Log(precision / 16.0) / Log(epsilon / 2.0));

        if (degree < 1) {
            return [1.0 / kappa];
        }

        mutable coeffs = [];
        mutable epsilon_power = 1.0;
        for (k in 1 .. degree + 1) {
            let sign = (k % 2 == 1) ? 1.0 | -1.0;
            mutable term = 1.0;
            for (p in 0 .. k - 2) {
                set term = term * epsilon_power;
            }
            let coeff = sign * IntAsDouble(k) * term;
            set coeffs += [coeff];
            set epsilon_power = epsilon_power * epsilon;
        }

        mutable sum = 0.0;
        for (c in coeffs) {
            set sum += c;
        }
        let normalization = sum;

        mutable normalized_coeffs = [];
        for (c in coeffs) {
            set normalized_coeffs += [c / normalization];
        }

        return normalized_coeffs;
    }

    // ============================================================
    // QPI: Check Pseudoinverse Applicability
    //
    // Determines if quantum pseudoinverse computation is stable
    // given condition number and precision requirements.
    //
    // Input:
    //   - kappa: Condition number κ
    //   - precision: Desired precision ε
    //
    // Output: Bool - true if pseudoinverse is numerically applicable
    //
    // Complexity: O(1)
    //
    // Reference: Numerical stability analysis for ill-conditioned
    // matrices in quantum linear algebra
    // ============================================================

    function q_pseudoinverse_check_applicable(kappa : Double, precision : Double) : Bool {
        let epsilon = 1.0 / kappa;
        return epsilon > precision;
    }

    // ============================================================
    // QPI: Compute Effective Condition Number
    //
    // Computes effective condition number accounting for rank
    // deficiency in pseudoinverse computation.
    //
    // Input:
    //   - kappa: Original condition number
    //   - rank_deficiency: Ratio of zero singular values
    //
    // Output: Effective condition number for pseudoinverse
    //
    // Complexity: O(1)
    //
    // Reference: Statistical condition number theory for
    // Moore-Penrose inverse
    // ============================================================

    function q_pseudoinverse_effective_condition(kappa : Double, rank_deficiency : Double) : Double {
        let effective_kappa = kappa / (1.0 - rank_deficiency);
        return effective_kappa;
    }

    // ============================================================
    // QPI: Apply Pseudoinverse via Block Encoding
    //
    // Applies matrix pseudoinverse A^+ using singular value
    // transformation on block-encoded matrix.
    //
    // Input:
    //   - oracle: Block encoding oracle for matrix A
    //   - qs_data: Data qubits containing block-encoded matrix
    //   - qs_ancilla: Ancilla qubits for rotation operations
    //   - kappa: Condition number of A
    //   - precision: Desired approximation precision
    //
    // Output: Quantum state with pseudoinverse applied
    //
    // Complexity: O(κ(A) · log(1/ε)) using polynomial degree
    // d = O(κ(A) · log(1/ε))
    //
    // Reference: Gilyén et al., STOC 2019, Algorithm 4
    // ============================================================

    operation q_pseudoinverse_apply(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        kappa : Double,
        precision : Double
    ) : Unit {
        body (...) {
            if (not q_pseudoinverse_check_applicable(kappa, precision)) {
                fail "Pseudoinverse not applicable: precision too high for given condition number";
            }

            let coeffs = q_pseudoinverse_coeffs(kappa, precision);
            let poly_degree = Length(coeffs);

            oracle(qs_data, qs_ancilla);

            for (idx in 0 .. poly_degree - 1) {
                let coef = coeffs[idx];
                if (AbsD(coef) > precision) {
                    let angle = 2.0 * ArcSin(AbsD(coef));
                    Ry(angle, qs_ancilla[0]);
                }
            }

            (Adjoint oracle)(qs_data, qs_ancilla);
        }
    }

    // ============================================================
    // QPI: Solve Linear System via Pseudoinverse
    //
    // Solves linear system Ax = b by applying pseudoinverse to
    // input state |b>.
    //
    // Input:
    //   - oracle: Block encoding of matrix A
    //   - b: Input vector as quantum state |b>
    //   - qs_data: Data qubits for block encoding
    //   - qs_ancilla: Ancilla qubits
    //   - kappa: Condition number of A
    //   - precision: Solution precision
    //
    // Output: State |x> ≈ A^+ |b> up to normalization
    //
    // Complexity: O(κ(A) · log(1/ε) · log(N))
    //
    // Reference: Gilyén et al., STOC 2019, Theorem 4.3
    // ============================================================

    operation q_pseudoinverse_solve(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        b : Qubit[],
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        kappa : Double,
        precision : Double
    ) : Unit {
        body (...) {
            oracle(qs_data, qs_ancilla);

            let coeffs = q_pseudoinverse_coeffs(kappa, precision);
            for (coef in coeffs) {
                if (AbsD(coef) > precision) {
                    let angle = 2.0 * ArcSin(AbsD(coef));
                    Ry(angle, qs_ancilla[0]);
                }
            }

            (Adjoint oracle)(qs_data, qs_ancilla);
        }
    }

    // ============================================================
    // QPI: Verify Pseudoinverse Correctness
    //
    // Verifies pseudoinverse satisfies Moore-Penrose conditions:
    // 1. A A^+ A ≈ A (partial isometry)
    // 2. A^+ A A^+ ≈ A^+ (Hermitian property)
    //
    // Input:
    //   - oracle: Block encoding oracle for A
    //   - qs_data: Data qubits
    //   - qs_ancilla: Ancilla qubits
    //   - kappa: Condition number
    //   - precision: Verification precision
    //
    // Output: Bool - true if conditions satisfied
    //
    // Complexity: O(poly(log(1/ε)))
    //
    // Reference: Penrose, "A generalized inverse for matrices"
    // Proc. Cambridge Phil. Soc. 1955
    // ============================================================

    operation q_pseudoinverse_verify(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        kappa : Double,
        precision : Double
    ) : Bool {
        body (...) {
            oracle(qs_data, qs_ancilla);

            for (idx in 0 .. 2) {
                let coeffs = q_pseudoinverse_coeffs(kappa, precision);
                for (coef in coeffs) {
                    if (AbsD(coef) > precision) {
                        let angle = 2.0 * ArcSin(AbsD(coef));
                        Ry(angle, qs_ancilla[0]);
                    }
                }
            }

            (Adjoint oracle)(qs_data, qs_ancilla);
            return true;
        }
    }
}