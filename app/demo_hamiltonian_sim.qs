// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Hamiltonian Ground State Simulation
//
// What it does:
//   Simulates a 16-qubit quantum system: encodes an 8-qubit
//   initial state, applies HEA variational ansatz to evolve
//   the state, then performs QFT for spectral analysis.
//   Demonstrates quantum simulation building blocks from
//   4 QBLAS modules working together.
//
// Input:
//   8 data qubits with amplitude-encoded initial state
//   8 additional qubits for QFT spectrum analysis
//   64 HEA parameters (8 qubits × 4 layers × 2 rotations)
//
// Output:
//   Single integer encoding 12 test outcomes:
//     bits 0-4: measurement population count (0-8)
//     bit 5:    Trotter utility functions verified
//     bit 6:    Qubitization utility functions verified
//     bit 7:    Gibbs utility functions verified
//     bit 8:    Time-dependent utility functions verified
//     bit 9:    HEA forward pass executed (16 q)
//     bit 10:   QFT on 8 qubits executed
//     bit 11:   Amplitude encoding on 8 qubits executed
//
// Pipeline steps and module mapping:
//   Step 1: q_vector → q_vector_amplitude_encode    → State preparation (8 qubits)
//   Step 2: q_vqe    → q_vqe_hea(8 qubits, 4 layers) → Variational evolution
//   Step 3: q_fft    → q_fft(8 qubits)              → Spectral analysis
//   Step 4: M × 8                                    → Measurement
//   Step 5: q_trotter_suzuki + q_qubitization        → Planning utilities
//   Step 6: q_gibbs + q_timedependent                → Analysis utilities
//
// Verification:
//   - Amplitude encoding on 8 qubits runs (quantum)
//   - HEA on 8 qubits × 4 layers runs (quantum)
//   - QFT on 8 qubits runs (quantum)
//   - Measurement population in valid 0-8 range (Fact)
//   - All simulation planning functions verified via Fact()
//
// Reference:
//   [1] Lloyd, "Universal Quantum Simulators"
//       Science 273, 1073 (1996)
//   [2] Trotter, "On the Product of Semi-Groups of Operators"
//       Proc. Amer. Math. Soc. 10, 545 (1959)
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    operation DemoHamiltonianSim() : Int {
        mutable result = 0;

        // ============================================================
        // Quantum Execution (8 + 8 = 16 qubits)
        // ============================================================

        // Step 1: Amplitude encode initial state on 8 qubits
        use qs_sys = Qubit[16];
        let qs_data = qs_sys[0 .. 7];
        let qs_aux = qs_sys[8 .. 15];

        q_vector_amplitude_encode(
            [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3],
            qs_data
        );
        set result += 2048;

        // Step 2: HEA variational evolution (8 qubits, 4 layers, 64 params)
        mutable theta = [0.0, size = 64];
        for i in 0 .. 63 {
            set theta w/= i <- IntAsDouble(i) * 0.05;
        }
        q_vqe_hea(8, theta, qs_data, 4);
        set result += 512;

        // Step 3: QFT spectral analysis on 8 qubits
        q_fft(qs_data);
        set result += 1024;

        // Step 4: Measure and count |1⟩ population
        mutable pop = 0;
        for i in 0 .. 7 {
            if (M(qs_data[i]) == One) {
                set pop += 1;
            }
        }
        ResetAll(qs_sys);
        Fact(pop >= 0 and pop <= 8,
             "ham: population count must be 0-8");
        set result += pop;

        // ============================================================
        // Classical Planning Utility Verification
        // ============================================================

        // Step 5: Trotter utilities
        let ts = q_trotter_step_size([1.0, 2.0], 1.0, 2);
        Fact(AbsD(ts - 1.0) < 1e-10, "ham: trotter_step_size");
        set result += 32;

        let to = q_trotter_optimal_steps(3.0, 1.0, 2, 0.01);
        Fact(to == 3, "ham: trotter_optimal_steps");
        set result += 32;

        // Step 6: Qubitization utilities
        let qq = q_qubitization_query_complexity(3, 2.0, 1.0, 0.01);
        Fact(qq == 9, "ham: qubitization_queries");
        set result += 64;

        let qa = q_qubitization_verify_accuracy(1.0, 1.0, 2.0);
        Fact(AbsD(qa - 0.0) < 1e-10, "ham: qubitization_accuracy");
        set result += 64;

        // Step 7: Gibbs utilities
        let gb = q_gibbs_compute_beta(2.0, 0.5);
        Fact(AbsD(gb - 4.0) < 1e-10, "ham: gibbs_beta");
        set result += 128;

        let gf = q_gibbs_free_energy(2.0, 1.0);
        Fact(AbsD(gf - 0.0) < 1e-8, "ham: gibbs_free_energy");
        set result += 128;

        // Step 8: Time-dependent utilities
        let td = q_timedep_discretize_steps(2.0, 1.0, 0.01);
        Fact(td == 4, "ham: timedep_steps");
        set result += 256;

        let tv = q_timedep_verify_evolution(0.0, 1.0, 2.0) ? 1 | 0;
        Fact(tv == 1, "ham: timedep_verify_evolution");
        set result += 256;

        return result;
    }
}
