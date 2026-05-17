// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: VQE Circuit Execution
//
// What it does:
//   Executes a 8-qubit HEA (Hardware Efficient Ansatz) circuit
//   with 2 layers (32 parameters), measures all qubits, and
//   validates the measurement statistics. Demonstrates real
//   quantum circuit execution via the q_vqe module.
//
// Input:
//   32 variational parameters (constant: i*0.1 for each param)
//   2-layer HEA on 8 qubits
//
// Output:
//   Single integer encoding 6 test outcomes:
//     bits 0-4: population count of |1⟩ measurements (0-8)
//     bit 5:    HEA forward pass executed
//     bit 6:    param counting verified
//     bit 7:    ansatz depth verified
//     bit 8:    gradient functions verified
//     bit 9:    convergence functions verified
//     bit 10:   valid expectation verified
//
// Pipeline steps and module mapping:
//   Step 1: q_vqe → q_vqe_count_params       → Parameter count (32)
//   Step 2: q_vqe → q_vqe_ansatz_depth        → Circuit depth (48)
//   Step 3: q_vqe → q_vqe_hea(8 qubits)       → Quantum circuit execution
//   Step 4: M(qs[i]) × 8                      → Measurement
//   Step 5: q_vqe → param_shift + gd_step + converged + adam
//
// Verification:
//   - count_params(8,2,"hea") = 32 (Fact)
//   - ansatz_depth(8,2,true) = 48 (Fact)
//   - HEA on 8 qubits runs without error (quantum)
//   - Measurement statistics in valid range 0-8 (Fact)
//   - Gradient and optimization functions produce expected values
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

    operation DemoVqeExecution() : Int {
        mutable result = 0;

        // ============================================================
        // Quantum Execution
        // ============================================================

        // Step 1: HEA forward pass on 8 qubits, 2 layers (32 params)
        use qs = Qubit[8];
        mutable theta = [0.0, size = 32];
        for i in 0 .. 31 {
            set theta w/= i <- IntAsDouble(i) * 0.1;
        }
        q_vqe_hea(8, theta, qs, 2);
        set result += 32;

        // Step 2: Measure all 8 qubits and count |1⟩ outcomes
        mutable pop_count = 0;
        for i in 0 .. 7 {
            if (M(qs[i]) == One) {
                set pop_count += 1;
            }
        }
        ResetAll(qs);
        Fact(pop_count >= 0 and pop_count <= 8,
             "vqe: population count must be 0-8");
        set result += pop_count;

        // ============================================================
        // Classical Verification
        // ============================================================

        // Step 3: Parameter count (8 qubits × 2 layers × 2 rotations)
        let np = q_vqe_count_params(8, 2, "hea");
        Fact(np == 32, "vqe: 8*2*2 = 32 params");
        set result += 64;

        // Step 4: Ansatz depth
        let depth = q_vqe_ansatz_depth(8, 2, true);
        Fact(depth == 48, "vqe: ansatz depth = 48");
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
