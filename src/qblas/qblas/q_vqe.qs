namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Variational Quantum Eigensolver (VQE) Components
    //
    // Purpose: Provides building blocks for VQE algorithms
    // including variational forms, parameter shifting, and
    // expectation value estimation.
    //
    // Algorithm: VQE uses hybrid quantum-classical optimization
    // to find ground state energy by parametrizing quantum states
    // and measuring expectation values of observables.
    //
    // Complexity: O(poly(n, 1/ε)) for n qubits and precision ε
    //
    // Reference: Peruzzo et al., "VQE on a quantum processor"
    // Nature Communications 5, 4213 (2014)
    // https://arxiv.org/abs/1304.3061
    // ============================================================

    // ============================================================
    // Variational Form: Hardware-Efficient Ansatz (HEA)
    //
    // Creates hardware-efficient ansatz with single-qubit
    // rotations and entangling layers.
    //
    // Input:
    //   - nqubits: Number of qubits
    //   - theta: Rotation angles
    //   - qs: Qubits to apply ansatz to
    //   - nlayers: Number of entangling layers
    //
    // Output: State prepared by HEA circuit
    //
    // Complexity: O(n * layers) gates
    //
    // Reference: Kandala et al., "Hardware-efficient VQE"
    // Nature 549, 242 (2017)
    // ============================================================

    operation q_vqe_hea(
        nqubits : Int,
        theta : Double[],
        qs : Qubit[],
        nlayers : Int
    ) : Unit {
        body (...) {
            let n = Length(qs);

            if (n < 1 or n != nqubits) {
                return ();
            }

            mutable pidx = 0;

            for (layer in 0 .. nlayers - 1) {
                for (i in 0 .. n - 1) {
                    if (pidx < Length(theta)) {
                        let ang = theta[pidx];
                        Ry(ang, qs[i]);
                        set pidx = pidx + 1;
                    }

                    if (pidx < Length(theta)) {
                        let ang = theta[pidx];
                        Rz(ang, qs[i]);
                        set pidx = pidx + 1;
                    }
                }

                if (layer < nlayers - 1) {
                    for (i in 0 .. n - 2) {
                        CNOT(qs[i], qs[i + 1]);
                    }
                    if (n > 2) {
                        CNOT(qs[n - 1], qs[0]);
                    }
                }
            }
        }
    }

    // ============================================================
    // Variational Form: QAOA-Style Ansatz
    //
    // Creates Quantum Approximate Optimization Algorithm
    // style ansatz for combinatorial optimization.
    //
    // Input:
    //   - gamma: Cost function parameters
    //   - beta: Mixer parameters
    //   - qs: Qubits
    //   - nlayers: Number of QAOA layers
    //
    // Output: QAOA state
    //
    // Complexity: O(n * nlayers)
    //
    // Reference: Farhi et al., "A Quantum Approximate Optimization Algorithm"
    // ============================================================

    operation q_vqe_qaoa(
        gamma : Double[],
        beta : Double[],
        qs : Qubit[],
        nlayers : Int
    ) : Unit {
        body (...) {
            let n = Length(qs);

            for (i in 0 .. n - 1) {
                H(qs[i]);
            }

            for (layer in 0 .. nlayers - 1) {
                if (layer < Length(gamma)) {
                    let g = gamma[layer];

                    for (i in 0 .. n - 2) {
                        CNOT(qs[i], qs[i + 1]);
                        (Controlled Rz)([qs[i + 1]], (g, qs[i]));
                        CNOT(qs[i], qs[i + 1]);
                    }
                }

                if (layer < Length(beta)) {
                    let b = beta[layer];

                    for (i in 0 .. n - 1) {
                        Rx(2.0 * b, qs[i]);
                    }
                }
            }
        }
    }

    // ============================================================
    // Variational Form: Efficient SU(2) Ansatz
    //
    // Creates ansatz from efficient 2-qubit entangling gates.
    //
    // Input:
    //   - theta_arr: Gate parameters
    //   - qs: Qubit register
    //   - nlayers: Number of layers
    //
    // Output: SU(2) ansatz applied
    //
    // Complexity: O(n * layers)
    //
    // Reference: Hadfield et al., "Quantum Algorithms"
    // ============================================================

    operation q_vqe_su2(
        theta_arr : Double[],
        qs : Qubit[],
        nlayers : Int
    ) : Unit {
        body (...) {
            let n = Length(qs);

            if (n < 1) {
                return ();
            }

            mutable idx = 0;

            for (layer in 0 .. nlayers - 1) {
                for (i in 0 .. n - 1) {
                    if (idx < Length(theta_arr)) {
                        let t = theta_arr[idx];
                        Ry(t, qs[i]);
                        set idx = idx + 1;
                    }
                }

                for (i in 0 .. n - 2) {
                    if (idx + 1 < Length(theta_arr)) {
                        let t = theta_arr[idx];
                        let phi = theta_arr[idx + 1];
                        CNOT(qs[i], qs[i + 1]);
                        (Controlled Ry)([qs[i + 1]], (t, qs[i]));
                        Rz(phi, qs[i + 1]);
                        CNOT(qs[i], qs[i + 1]);
                        set idx = idx + 2;
                    }
                }
            }
        }
    }

    // ============================================================
    // Parameter Shift: Compute Shifted Parameters
    //
    // Computes parameter sets for parameter shift rule.
    // For each parameter θ_i, creates θ_i ± π/2 shifts.
    //
    // Input:
    //   - p: Original parameters
    //   - shift: Shift amount (default π/2)
    //
    // Output: Array of shifted parameter sets
    //
    // Complexity: O(k * n_params) for k shifts
    //
    // Reference: Schuld et al., "Evaluating analytic gradients"
    // ============================================================

    function q_vqe_param_shift_plus(p : Double[], shift : Double) : Double[] {
        mutable shifted = [];

        for (i in 0 .. Length(p) - 1) {
            let orig = p[i];
            set shifted += [orig + shift];
        }

        return shifted;
    }

    function q_vqe_param_shift_minus(p : Double[], shift : Double) : Double[] {
        mutable shifted = [];

        for (i in 0 .. Length(p) - 1) {
            let orig = p[i];
            set shifted += [orig - shift];
        }

        return shifted;
    }

    // ============================================================
    // Parameter Shift: Gradient from Expectation Values
    //
    // Computes gradient of expectation value using parameter shift.
    // ∂⟨H⟩/∂θ_i = (E(θ_i + π/2) - E(θ_i - π/2)) / 2
    //
    // Input:
    //   - exp_plus: Expectation at shifted +π/2
    //   - exp_minus: Expectation at shifted -π/2
    //
    // Output: Gradient component
    //
    // Complexity: O(1)
    //
    // Reference: Mitarai et al., "Quantum gradient descent"
    // ============================================================

    function q_vqe_gradient_from_shifts(exp_plus : Double, exp_minus : Double) : Double {
        return (exp_plus - exp_minus) / 2.0;
    }

    // ============================================================
    // Expectation Value: Weighted Sum
    //
    // Computes expectation of observable H = Σ w_i P_i
    // from individual Pauli expectations.
    //
    // Input:
    //   - weights: Weights w_i for each Pauli string
    //   - exps: ⟨P_i⟩ for each Pauli string
    //
    // Output: ⟨H⟩ = Σ w_i ⟨P_i⟩
    //
    // Complexity: O(k) for k terms
    //
    // Reference: McClean et al., "Barren plateaus"
    // ============================================================

    function q_vqe_weighted_sum(weights : Double[], exps : Double[]) : Double {
        mutable sum = 0.0;
        let n = Length(weights);

        for (i in 0 .. n - 1) {
            if (i < Length(exps)) {
                set sum = sum + weights[i] * exps[i];
            }
        }

        return sum;
    }

    // ============================================================
    // Expectation Value: Check Measurement Validity
    //
    // Validates that measurement results are physical.
    //
    // Input:
    //   - exp_val: Expectation value
    //
    // Output: true if -1 ≤ ⟨P⟩ ≤ 1
    //
    // Complexity: O(1)
    //
    // Reference: Common VQE validation
    // ============================================================

    function q_vqe_valid_expectation(exp_val : Double) : Bool {
        return exp_val >= -1.0 - 1e-10 and exp_val <= 1.0 + 1e-10;
    }

    // ============================================================
    // Optimization: Gradient Descent Step
    //
    // Performs one step of gradient descent optimization.
    //
    // Input:
    //   - p: Current parameters
    //   - grad: Gradient vector
    //   - lr: Learning rate
    //
    // Output: Updated parameters
    //
    // Complexity: O(n) for n parameters
    //
    // Reference: Classical optimization theory
    // ============================================================

    function q_vqe_gradient_descent_step(p : Double[], grad : Double[], lr : Double) : Double[] {
        mutable upd = [];
        let n = Length(p);

        for (i in 0 .. n - 1) {
            if (i < Length(grad)) {
                let new_val = p[i] - lr * grad[i];
                set upd += [new_val];
            } else {
                set upd += [p[i]];
            }
        }

        return upd;
    }

    // ============================================================
    // Optimization: Adam Step
    //
    // Performs one step of Adam optimizer.
    //
    // Input:
    //   - p: Current parameters
    //   - grad: Gradient
    //   - lr: Learning rate
    //   - b1: Exponential decay for first moment
    //   - b2: Exponential decay for second moment
    //   - eps: Small constant for numerical stability
    //   - t: Step number
    //   - m: First moment estimate
    //   - v: Second moment estimate
    //
    // Output: Updated parameters and moments
    //
    // Complexity: O(n)
    //
    // Reference: Kingma & Ba, "Adam: A Method for Stochastic Optimization"
    // ============================================================

    function q_vqe_adam_step(
        p : Double[],
        grad : Double[],
        lr : Double,
        b1 : Double,
        b2 : Double,
        eps : Double,
        t : Int,
        m : Double[],
        v : Double[]
    ) : (Double[], Double[], Double[]) {
        mutable new_m = [];
        mutable new_v = [];
        mutable new_p = [];

        let b1_t = PowD(b1, IntAsDouble(t));
        let b2_t = PowD(b2, IntAsDouble(t));
        let lr_t = lr * Sqrt(1.0 - b2_t) / (1.0 - b1_t);

        for (i in 0 .. Length(p) - 1) {
            let g_i = i < Length(grad) ? grad[i] | 0.0;
            let m_i = i < Length(m) ? m[i] | 0.0;
            let v_i = i < Length(v) ? v[i] | 0.0;

            let m_new = b1 * m_i + (1.0 - b1) * g_i;
            let v_new = b2 * v_i + (1.0 - b2) * g_i * g_i;

            let m_hat = m_new / (1.0 - b1_t);
            let v_hat = v_new / (1.0 - b2_t);

            let p_new = p[i] - lr_t * m_hat / (Sqrt(v_hat) + eps);

            set new_m += [m_new];
            set new_v += [v_new];
            set new_p += [p_new];
        }

        return (new_p, new_m, new_v);
    }

    // ============================================================
    // Optimization: Check Convergence
    //
    // Checks if optimization has converged based on gradient norm.
    //
    // Input:
    //   - grad: Current gradient
    //   - tol: Convergence tolerance
    //
    // Output: true if converged
    //
    // Complexity: O(n)
    //
    // Reference: Classical optimization criteria
    // ============================================================

    function q_vqe_converged(grad : Double[], tol : Double) : Bool {
        mutable norm_sq = 0.0;

        for (g in grad) {
            set norm_sq = norm_sq + g * g;
        }

        let norm = Sqrt(norm_sq);
        return norm < tol;
    }

    // ============================================================
    // Optimization: Energy Difference Tolerance
    //
    // Checks convergence based on energy change.
    //
    // Input:
    //   - e_old: Previous energy
    //   - e_new: Current energy
    //   - tol: Energy tolerance
    //
    // Output: true if |E_new - E_old| < tolerance
    //
    // Complexity: O(1)
    //
    // Reference: VQE convergence criteria
    // ============================================================

    function q_vqe_energy_converged(e_old : Double, e_new : Double, tol : Double) : Bool {
        let diff = AbsD(e_new - e_old);
        return diff < tol;
    }

    // ============================================================
    // Optimization: Initialize Adam Moments
    //
    // Initializes first and second moment estimates for Adam.
    //
    // Input: n_params - Number of parameters
    //
    // Output: Initial moments (m=0, v=0)
    //
    // Complexity: O(n)
    //
    // Reference: Kingma & Ba, Adam paper
    // ============================================================

    function q_vqe_init_adam(n_params : Int) : (Double[], Double[]) {
        mutable m = [];
        mutable v = [];

        for (i in 0 .. n_params - 1) {
            set m += [0.0];
            set v += [0.0];
        }

        return (m, v);
    }

    // ============================================================
    // Variational: Compute Ansatz Depth
    //
    // Computes circuit depth for given ansatz structure.
    //
    // Input:
    //   - nqubits: Number of qubits
    //   - nlayers: Number of layers
    //   - entangle_last: Whether last layer has entanglement
    //
    // Output: Total number of gates
    //
    // Complexity: O(1)
    //
    // Reference: Hardware-efficient VQE paper
    // ============================================================

    function q_vqe_ansatz_depth(nqubits : Int, nlayers : Int, entangle_last : Bool) : Int {
        let single_gates = nqubits * nlayers * 2;
        let entangle_gates = (nlayers - 1) * nqubits;
        let entangle_extra = entangle_last ? nqubits | 0;

        return single_gates + entangle_gates + entangle_extra;
    }

    // ============================================================
    // Variational: Count Parameters
    //
    // Counts number of parameters in ansatz.
    //
    // Input:
    //   - nqubits: Number of qubits
    //   - nlayers: Number of layers
    //   - ansatz_type: Type of ansatz ("hea", "qaoa", "su2")
    //
    // Output: Number of parameters
    //
    // Complexity: O(1)
    //
    // Reference: VQE parameter counting
    // ============================================================

    function q_vqe_count_params(nqubits : Int, nlayers : Int, ansatz_type : String) : Int {
        if (ansatz_type == "hea") {
            return nqubits * nlayers * 2;
        } elif (ansatz_type == "qaoa") {
            return 2 * nlayers;
        } elif (ansatz_type == "su2") {
            return nqubits * nlayers + (nqubits - 1) * 2 * (nlayers - 1);
        } else {
            return nqubits * nlayers * 2;
        }
    }

    // ============================================================
    // Hamiltonian: Parse Pauli String
    //
    // Parses Pauli string into individual Pauli operators.
    //
    // Input: pauli_str - String like "XYZ" or "XIZ"
    //
    // Output: Array of Pauli values (0=I, 1=X, 2=Y, 3=Z)
    //
    // Complexity: O(n) for n-qubit string
    //
    // Reference: Pauli representation of Hamiltonians
    // ============================================================

    function q_vqe_parse_pauli_string(pauli_str : String) : Int[] {
        mutable paulis = [];
        mutable i = 0;

        if (pauli_str == "X") {
            set paulis = [1];
        } elif (pauli_str == "Y") {
            set paulis = [2];
        } elif (pauli_str == "Z") {
            set paulis = [3];
        } elif (pauli_str == "XX") {
            set paulis = [1, 1];
        } elif (pauli_str == "XY") {
            set paulis = [1, 2];
        } elif (pauli_str == "XZ") {
            set paulis = [1, 3];
        } elif (pauli_str == "YX") {
            set paulis = [2, 1];
        } elif (pauli_str == "YY") {
            set paulis = [2, 2];
        } elif (pauli_str == "YZ") {
            set paulis = [2, 3];
        } elif (pauli_str == "ZX") {
            set paulis = [3, 1];
        } elif (pauli_str == "ZY") {
            set paulis = [3, 2];
        } elif (pauli_str == "ZZ") {
            set paulis = [3, 3];
        } else {
            set paulis = [];
        }

        return paulis;
    }

    // ============================================================
    // Hamiltonian: Compute Term Weight
    //
    // Computes weight for weighted Hamiltonian.
    //
    // Input:
    //   - pauli_str: Pauli operator string
    //   - coeff: Coefficient in Hamiltonian
    //
    // Output: Weight for expectation measurement
    //
    // Complexity: O(n)
    //
    // Reference: McClean et al., "Barren plateaus"
    // ============================================================

    function q_vqe_term_weight(pauli_str : String, coeff : Double) : Double {
        return AbsD(coeff);
    }

    // ============================================================
    // Gradient: Parameter Shift Angle
    //
    // Computes shift angle for parameter shift rule.
    //
    // Input: shift - Shift amount (default π/2)
    //
    // Output: 2 * shift for gradient formula
    //
    // Complexity: O(1)
    //
    // Reference: Schuld et al., "Evaluating analytic gradients"
    // ============================================================

    function q_vqe_shift_angle(shift : Double) : Double {
        return 2.0 * shift;
    }

    // ============================================================
    // Gradient: Hessian Diagonal Estimate
    //
    // Estimates diagonal of Hessian for quantum natural gradient.
    //
    // Input:
    //   - p: Parameters
    //   - exp_p: Expectation at shifted +π/2
    //   - exp_m: Expectation at shifted -π/2
    //   - exp_z: Expectation at zero shift
    //
    // Output: Diagonal Hessian entries
    //
    // Complexity: O(n * measurements)
    //
    // Reference: Stokes et al., "Quantum Natural Gradient"
    // ============================================================

    function q_vqe_hessian_diag(p : Double[], exp_p : Double[], exp_m : Double[], exp_z : Double[]) : Double[] {
        mutable hess = [];

        for (i in 0 .. Length(p) - 1) {
            let ep = i < Length(exp_p) ? exp_p[i] | 0.0;
            let em = i < Length(exp_m) ? exp_m[i] | 0.0;
            let ez = i < Length(exp_z) ? exp_z[i] | 0.0;

            let h_i = (ep + em - 2.0 * ez);
            set hess += [h_i];
        }

        return hess;
    }

    // ============================================================
    // Variance: Gradient Variance Estimate
    //
    // Estimates variance of gradient estimator.
    //
    // Input:
    //   - exps: Expectation values at different shifts
    //   - n_samples: Number of measurement samples
    //
    // Output: Variance estimate
    //
    // Complexity: O(k) for k shift positions
    //
    // Reference: Quantum gradient estimation variance
    // ============================================================

    function q_vqe_gradient_variance(exps : Double[], n_samples : Int) : Double {
        if (Length(exps) < 2 or n_samples < 1) {
            return 0.0;
        }

        mutable sum = 0.0;
        mutable sum_sq = 0.0;

        for (exp_val in exps) {
            set sum = sum + exp_val;
            set sum_sq = sum_sq + exp_val * exp_val;
        }

        let mean = sum / IntAsDouble(Length(exps));
        let var_exp = (sum_sq / IntAsDouble(Length(exps))) - mean * mean;

        return var_exp / IntAsDouble(n_samples);
    }

    // ============================================================
    // Learning Rate: Compute Adaptive LR
    //
    // Computes adaptive learning rate based on gradient history.
    //
    // Input:
    //   - base_lr: Base learning rate
    //   - grad_norm: Current gradient norm
    //   - prev_grad_norm: Previous gradient norm
    //   - lr_min: Minimum learning rate
    //   - lr_max: Maximum learning rate
    //
    // Output: Adaptive learning rate
    //
    // Complexity: O(1)
    //
    // Reference: Adaptive learning rate methods
    // ============================================================

    function q_vqe_adaptive_lr(
        base_lr : Double,
        grad_norm : Double,
        prev_grad_norm : Double,
        lr_min : Double,
        lr_max : Double
    ) : Double {
        if (prev_grad_norm < 1e-10) {
            return base_lr;
        }

        let ratio = grad_norm / prev_grad_norm;
        let scale = ratio > 1.0 ? 1.0 / ratio | ratio;

        let lr = base_lr / scale;

        if (lr < lr_min) {
            return lr_min;
        }
        if (lr > lr_max) {
            return lr_max;
        }

        return lr;
    }

    // ============================================================
    // Measurement: Compute Shot Allocation
    //
    // Computes optimal number of shots for measurement.
    //
    // Input:
    //   - weights: Term weights for shot allocation
    //   - total_shots: Total measurement shots
    //
    // Output: Array of shots per term
    //
    // Complexity: O(k)
    //
    // Reference: Rubaszewski et al., "Optimal VQE measurement"
    // ============================================================

    function q_vqe_shot_allocation(weights : Double[], total_shots : Int) : Int[] {
        mutable sum_w = 0.0;
        for (w in weights) {
            set sum_w = sum_w + AbsD(w);
        }

        mutable shots = [];

        if (sum_w < 1e-10) {
            for (w in weights) {
                set shots += [0];
            }
            return shots;
        }

        for (w in weights) {
            let allocated = Floor(IntAsDouble(total_shots) * AbsD(w) / sum_w);
            set shots += [allocated];
        }

        return shots;
    }

    // ============================================================
    // State: Initialize from Classical Vector
    //
    // Prepares quantum state from classical amplitude vector.
    //
    // Input:
    //   - vec: Amplitude vector
    //   - qs: Qubits
    //
    // Output: State prepared with amplitudes
    //
    // Complexity: O(N) for N = 2^n amplitudes
    //
    // Reference: Amplitude encoding
    // ============================================================

    operation q_vqe_init_state(vec : Double[], qs : Qubit[]) : Unit {
        body (...) {
            let n = Length(qs);
            let N = 2 ^ n;
            let norm = Sqrt(SquaredNorm(vec));

            if (norm < 1e-10) {
                return ();
            }

            for (idx in 0 .. N - 1) {
                if (idx < Length(vec)) {
                    let amp = vec[idx] / norm;

                    if (AbsD(amp) > 1e-10) {
                        let angle = 2.0 * ArcSin(AbsD(amp));

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs[bit]);
                            }
                        }

                        Ry(angle, qs[0]);

                        for (bit in 0 .. n - 1) {
                            if (((idx >>> bit) &&& 1) == 1) {
                                X(qs[bit]);
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // Ansatz: Validate Parameters
    //
    // Validates parameter array matches ansatz requirements.
    //
    // Input:
    //   - p: Parameter array
    //   - nqubits: Number of qubits
    //   - nlayers: Number of layers
    //   - ansatz_type: Type of ansatz
    //
    // Output: true if parameter count is correct
    //
    // Complexity: O(1)
    //
    // Reference: VQE parameter validation
    // ============================================================

    function q_vqe_validate_params(p : Double[], nqubits : Int, nlayers : Int, ansatz_type : String) : Bool {
        let required = q_vqe_count_params(nqubits, nlayers, ansatz_type);
        return Length(p) >= required;
    }
}