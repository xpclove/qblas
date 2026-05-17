// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: VQE Circuit Execution
//
// What it does:
//   Executes a HEA circuit with configurable qubits and layers,
//   measures all qubits, validates measurement statistics and
//   all VQE utility functions (count_params, ansatz_depth,
//   param_shift, gradient, gd_step, converged, adam).
//
// Input:
//   n_qubits: number of qubits (≥ 1)
//   n_layers: number of HEA layers (≥ 1)
//   Demo config:  n_qubits = 8, n_layers = 2 → 32 params, 8 qubits ≥ 8 ✓
//   Test config:  n_qubits = 4, n_layers = 1 →  8 params, 4 qubits (fast)
//
// Architecture:
//   - Qubits: n_qubits
//   - Ansatz: HEA, n_layers
//   - Parameters: n_qubits × n_layers × 2
//   - Measurement: M × n_qubits
//   - Demo: 8 qubits, 2 layers, 32 params
//   - Test: 4 qubits, 1 layer, 8 params
//
// Output:
//   Single integer encoding:
//     lower bits: population count of |1⟩ (0 to n_qubits)
//     bit 5:    HEA forward pass executed
//     bit 6:    param counting verified
//     bit 7:    ansatz depth verified
//     bit 8:    gradient functions verified
//     bit 9:    convergence functions verified
//     bit 10:   valid expectation verified
//
// Pipeline steps and module mapping:
//   Step 1: q_vqe → q_vqe_hea(n_qubits, n_layers)  → Quantum circuit execution
//   Step 2: M × n_qubits                           → Measurement
//   Step 3: q_vqe → count_params, ansatz_depth      → Architecture verification
//   Step 4: q_vqe → param_shift + gd_step + converged + adam
//
// Verification:
//   - HEA on n_qubits runs without error (quantum)
//   - Measurement pop. count in [0, n_qubits] (Fact)
//   - count_params = n_qubits × n_layers × 2 (Fact)
//   - ansatz_depth formula verified (Fact)
//   - Gradient and optimization functions produce expected values (Fact)
//
// Reference:
//   [1] Kandala et al., "Hardware-efficient variational quantum
//       eigensolver for small molecules" Nature 549, 242 (2017)
//   [2] McArdle et al., "Variational quantum eigensolver"
//       arXiv:1808.10402 (2018)
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    operation DemoVqeExecution(n_qubits : Int, n_layers : Int) : Int {
        if (n_qubits < 1 or n_layers < 1) { return -1; }

        mutable result = 0;
        let n_params = n_qubits * n_layers * 2;

        // ============================================================
        // Quantum Execution
        // ============================================================

        // Step 1: HEA forward pass on n_qubits, n_layers
        use qs = Qubit[n_qubits];
        mutable theta = [0.0, size = n_params];
        for i in 0 .. n_params - 1 {
            set theta w/= i <- IntAsDouble(i) * 0.1;
        }
        q_vqe_hea(n_qubits, theta, qs, n_layers);
        set result += 32;

        // Step 2: Measure all qubits and count |1⟩ outcomes
        mutable pop_count = 0;
        for i in 0 .. n_qubits - 1 {
            if (M(qs[i]) == One) {
                set pop_count += 1;
            }
        }
        ResetAll(qs);
        Fact(pop_count >= 0 and pop_count <= n_qubits,
             "vqe: population count must be 0-n_qubits");
        set result += pop_count;

        // ============================================================
        // Classical Verification
        // ============================================================

        // Step 3: Parameter count (n_qubits × n_layers × 2 rotations)
        let np = q_vqe_count_params(n_qubits, n_layers, "hea");
        Fact(np == n_params, "vqe: n_qubits*n_layers*2 = n_params");
        set result += 64;

        // Step 4: Ansatz depth
        let depth = q_vqe_ansatz_depth(n_qubits, n_layers, true);
        Fact(depth == n_qubits * n_layers * 2 + (n_layers - 1) * n_qubits + n_qubits,
             "vqe: ansatz depth formula verified");
        set result += 128;

        // Step 5: Parameter shift (+)
        let sp = q_vqe_param_shift_plus([0.1, 0.2], PI() / 4.0);
        Fact(AbsD(sp[0] - 0.8853981633974483) < 1e-10, "vqe: shift_plus[0]");
        set result += 256;

        // Step 6: Gradient from shifts
        let g = q_vqe_gradient_from_shifts(0.8, 0.4);
        Fact(AbsD(g - 0.2) < 1e-10, "vqe: gradient = 0.2");
        set result += 512;

        // Step 7: Gradient descent step
        let pn = q_vqe_gradient_descent_step([0.5, 0.5], [0.1, 0.1], 0.1);
        Fact(AbsD(pn[0] - 0.49) < 1e-10, "vqe: gd_step = 0.49");
        set result += 1024;

        // Step 8: Converged check
        let cv = q_vqe_converged([0.001, 0.001], 0.01) ? 1 | 0;
        Fact(cv == 1, "vqe: converged = true");
        set result += 2048;

        // Step 9: Energy converged
        let ec = q_vqe_energy_converged(0.5, 0.5, 0.001) ? 1 | 0;
        Fact(ec == 1, "vqe: energy_converged = true");
        set result += 4096;

        // Step 10: Valid expectation
        let ve = q_vqe_valid_expectation(0.5) ? 1 | 0;
        Fact(ve == 1, "vqe: valid_expectation = true");
        set result += 8192;

        // Step 11: Adam step
        let (m, v) = q_vqe_init_adam(2);
        let (pa, _, _) = q_vqe_adam_step(
            [0.5, 0.5], [0.1, 0.1], 0.1, 0.9, 0.999, 1e-8, 1, m, v
        );
        Fact(AbsD(pa[0] - 0.46837722656059355) < 1e-10, "vqe: adam_step[0]");
        set result += 16384;

        return result;
    }
}
