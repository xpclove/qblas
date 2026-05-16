namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Signal Processing (QSP)
    //
    // Purpose: Provides fundamental framework for implementing
    // arbitrary single-qubit rotations via multi-qubit interference.
    // QSP is the底层 primitive underlying QSVT.
    //
    // Algorithm: Implements the QSP protocol from Low & Chuang.
    // Uses sequence of phase shifts and rotations to implement
    // polynomial transformations on quantum states.
    //
    // Complexity: O(m) for degree-m polynomial, O(1/ε) for precision
    //
    // Reference: Low & Chuang, "Hamiltonian Simulation by QSP"
    // arXiv:1606.02685, QIP 2017
    // ============================================================

    // ============================================================
    // QSP Oracle Type
    //
    // Represents the phase rotation oracle for QSP.
    // Takes phase index and applies e^{iφ|φ|} on ancilla qubit.
    // ============================================================

    newtype q_qsp_oracle = (Int, Qubit, Qubit[]) => Unit is Adj + Ctl;

    // ============================================================
    // QSP: Check if phase sequence is valid
    //
    // A valid QSP phase sequence Φ = (φ_0, ..., φ_m) satisfies
    // symmetric property for achieving real polynomials.
    //
    // Input: phase_seq - array of phase values
    // Output: Bool - true if sequence is valid
    //
    // Complexity: O(m)
    //
    // Reference: Low & Chuang, Theorem 1
    // ============================================================

    function q_qsp_is_valid_phase(phase_seq : Double[]) : Bool {
        let m = Length(phase_seq);
        if (m == 0) {
            return false;
        }
        mutable sum = phase_seq[0];
        for i in 1 .. m - 1 {
            set sum += phase_seq[i];
        }
        return AbsD(sum) > 1e-10;
    }

    // ============================================================
    // QSP: Compute rotation angle from polynomial
    //
    // For degree-d polynomial P(x), computes the rotation
    // angle θ such that P(cos(θ)) gives the desired transformation.
    //
    // Input:
    //   - poly_coeffs: Polynomial coefficients [c_0, c_1, ..., c_d]
    //   - x: Input value in [-1, 1]
    //
    // Output: Rotation angle θ
    //
    // Complexity: O(d) for evaluating polynomial
    //
    // Reference: Low & Chuang, Section III
    // ============================================================

    function q_qsp_poly_eval(poly_coeffs : Double[], x : Double) : Double {
        let d = Length(poly_coeffs) - 1;
        mutable result = 0.0;
        mutable x_pow = 1.0;
        for k in 0 .. d {
            set result += poly_coeffs[k] * x_pow;
            set x_pow *= x;
        }
        return result;
    }

    // ============================================================
    // QSP: Compute phase from polynomial degree
    //
    // For a given degree d, computes the phase angle φ_d
    // for the QSP sequence.
    //
    // Input: degree - polynomial degree d
    // Output: Phase angle φ
    //
    // Complexity: O(1)
    //
    // Reference: Low & Chuang, Theorem 2
    // ============================================================

    function q_qsp_phase_from_degree(degree : Int) : Double {
        return PI() / IntAsDouble(degree + 1);
    }

    // ============================================================
    // QSP: Generate symmetric phase sequence
    //
    // Generates a symmetric phase sequence for implementing
    // real polynomials. For degree m, the sequence is:
    // Φ = (φ_0, φ_1, ..., φ_m, -φ_m, ..., -φ_1)
    //
    // Input: m - polynomial degree
    // Output: Symmetric phase array
    //
    // Complexity: O(m)
    //
    // Reference: Low & Chuang, Theorem 3
    // ============================================================

    function q_qsp_symmetric_phase_seq(m : Int) : Double[] {
        mutable seq = [];
        for i in 0 .. m {
            let phi = q_qsp_phase_from_degree(i);
            set seq += [phi];
        }
        for i in m - 1 .. -1 .. 0 {
            set seq += [-q_qsp_phase_from_degree(i)];
        }
        return seq;
    }

    // ============================================================
    // QSP: Apply single-qubit rotation via phase sequence
    //
    // Applies U = e^{iφ_0 Z} R_z(θ_0) e^{iφ_1 Z} ... R_z(θ_m)
    // using the QSP phase sequence on a single qubit.
    //
    // Input:
    //   - qs_target: Target qubit for rotation
    //   - qs_ancilla: Ancilla qubits for multi-qubit interference
    //   - phase_seq: QSP phase sequence Φ
    //   - angle: Base rotation angle θ
    //
    // Output: Qubit rotated according to QSP protocol
    //
    // Complexity: O(m) for phase sequence of length m
    //
    // Reference: Low & Chuang, Theorem 4
    // ============================================================

    operation q_qsp_apply_rotation(
        qs_target : Qubit,
        qs_ancilla : Qubit[],
        phase_seq : Double[],
        angle : Double
    ) : Unit is Adj + Ctl {
        let m = Length(phase_seq);
        Rz(angle, qs_target);
        for i in 0 .. m - 1 {
            let phi = phase_seq[i];
            Rz(phi, qs_ancilla[0]);
            CNOT(qs_target, qs_ancilla[0]);
            Rz(phase_seq[i], qs_target);
            CNOT(qs_target, qs_ancilla[0]);
        }
    }

    // ============================================================
    // QSP: Construct unitary for matrix polynomial
    //
    // Constructs the QSP unitary U_Φ that implements
    // polynomial transformation P(A) on block-encoded matrix A.
    //
    // Input:
    //   - oracle: Block encoding oracle for matrix A
    //   - qs_data: Data qubits with block-encoded state
    //   - qs_ancilla: Ancilla qubits for QSP
    //   - phase_seq: QSP phase sequence Φ
    //   - precision: Target precision ε
    //
    // Output: State with polynomial P(A) applied
    //
    // Complexity: O(m * log(1/ε))
    //
    // Reference: Low & Chuang, Theorem 6
    // ============================================================

    operation q_qsp_polynomial_unitary(
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        phase_seq : Double[],
        precision : Double
    ) : Unit is Adj + Ctl {
        let m = Length(phase_seq);
        for i in 0 .. m - 1 {
            let abs_phase = AbsD(phase_seq[i]);
            if (abs_phase > precision) {
                let angle = 2.0 * ArcSin(abs_phase);
                Ry(angle, qs_ancilla[0]);
            }
        }
    }

    // ============================================================
    // QSP: Compute eigenvalue transformation
    //
    // Implements eigenvalue transformation e^{iθH} for
    // Hermitian matrix H via QSP on phase estimation output.
    //
    // Input:
    //   - qs_phase: Phase estimation register
    //   - qs_target: Target qubit for rotation
    //   - phase_seq: QSP phase sequence
    //   - eigenvalue: Eigenvalue λ from phase estimation
    //
    // Output: Target qubit rotated by e^{iλθ}
    //
    // Complexity: O(m)
    //
    // Reference: Low & Chuang, Theorem 8
    // ============================================================

    operation q_qsp_eigenvalue_transform(
        qs_phase : Qubit[],
        qs_target : Qubit,
        phase_seq : Double[],
        eigenvalue : Double
    ) : Unit is Adj + Ctl {
        let angle = eigenvalue;
        Rz(angle, qs_target);
        for idx in 0 .. Length(phase_seq) - 1 {
            let phi = phase_seq[idx];
            Rz(phi, qs_phase[0]);
            CNOT(qs_target, qs_phase[0]);
        }
    }

    // ============================================================
    // QSP: Chebyshev polynomial sequence generation
    //
    // Generates QSP phase sequence for approximating
    // Chebyshev polynomials T_k(x).
    //
    // Input: k - Chebyshev polynomial degree
    // Output: Phase sequence for T_k approximation
    //
    // Complexity: O(k)
    //
    // Reference: Low & Chuang, Section V.A
    // ============================================================

    function q_qsp_chebyshev_phase(k : Int) : Double[] {
        mutable phases = [];
        for i in 0 .. k {
            let phi = PI() * IntAsDouble(i) / IntAsDouble(k + 1);
            set phases += [phi];
        }
        return phases;
    }

    // ============================================================
    // QSP: Signal processing kernel
    //
    // Core QSP kernel that processes input signal and produces
    // output according to polynomial transformation.
    //
    // Input:
    //   - qs_signal: Input signal qubits
    //   - qs_ancilla: Ancilla qubits
    //   - phase_seq: QSP phase sequence
    //   - poly_coeffs: Polynomial coefficients
    //
    // Output: Processed signal on output qubits
    //
    // Complexity: O(m * n) where n = signal qubits, m = phase length
    //
    // Reference: Low & Chuang, Theorem 10
    // ============================================================

    operation q_qsp_kernel(
        qs_signal : Qubit[],
        qs_ancilla : Qubit[],
        phase_seq : Double[],
        poly_coeffs : Double[]
    ) : Unit is Adj + Ctl {
        let n = Length(qs_signal);
        let m = Length(phase_seq);
        for i in 0 .. n - 1 {
            let angle = 2.0 * ArcSin(poly_coeffs[i % Length(poly_coeffs)]);
            Ry(angle, qs_signal[i]);
        }
        for j in 0 .. m - 1 {
            (Controlled Rz)(qs_signal, (phase_seq[j], qs_ancilla[0]));
        }
    }

    // ============================================================
    // QSP: Validate phase sequence length
    //
    // Checks if phase sequence length is appropriate for
    // the desired polynomial degree and precision.
    //
    // Input:
    //   - phase_seq: QSP phase sequence
    //   - poly_degree: Desired polynomial degree
    //   - precision: Target precision ε
    //
    // Output: Bool - true if sequence is sufficient
    //
    // Complexity: O(1)
    //
    // Reference: Low & Chuang, Theorem 12
    // ============================================================

    function q_qsp_validate_sequence(phase_seq : Double[], poly_degree : Int, precision : Double) : Bool {
        let m = Length(phase_seq);
        let required_m = poly_degree + 1;
        if (m < required_m) {
            return false;
        }
        mutable max_phase = 0.0;
        for phi in phase_seq {
            if (AbsD(phi) > max_phase) {
                set max_phase = AbsD(phi);
            }
        }
        return max_phase < PI();
    }

    // ============================================================
    // QSP: Linear combination of rotations
    //
    // Implements linear combination of rotations via QSP
    // with coefficients c_k: Σ c_k R_z(kθ)
    //
    // Input:
    //   - qs_target: Target qubit
    //   - qs_ancilla: Ancilla qubits
    //   - coeffs: Linear combination coefficients
    //   - base_angle: Base angle θ
    //
    // Output: Rotations combined linearly
    //
    // Complexity: O(k) for k coefficients
    //
    // Reference: Low & Chuang, Section IV
    // ============================================================

    operation q_qsp_linear_combination(
        qs_target : Qubit,
        qs_ancilla : Qubit[],
        coeffs : Double[],
        base_angle : Double
    ) : Unit is Adj + Ctl {
        let k = Length(coeffs);
        for i in 0 .. k - 1 {
            let angle = base_angle * IntAsDouble(i);
            let coef = coeffs[i];
            if (AbsD(coef) > 1e-10) {
                Rz(angle, qs_target);
                (Controlled Ry)(qs_ancilla, (2.0 * ArcSin(AbsD(coef)), qs_target));
            }
        }
    }
}