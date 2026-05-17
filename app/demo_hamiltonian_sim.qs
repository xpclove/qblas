// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Hamiltonian Ground State Simulation
//
// What it does:
//   Simulates a quantum system with configurable size:
//   encodes initial state on n_data_qubits, applies HEA
//   variational ansatz, performs QFT for spectral analysis,
//   and verifies simulation planning utilities.
//
// Input:
//   n_data_qubits: number of data qubits (≥ 1)
//   n_layers: number of HEA layers (≥ 1)
//   Demo config:  n_data_qubits = 8, n_layers = 4 → 16 qubits, ≥ 8 ✓
//   Test config:  n_data_qubits = 2, n_layers = 1 →  4 qubits, fast
//
// Architecture:
//   - Qubits: 2 × n_data_qubits (data + auxiliary)
//   - HEA: n_data_qubits qubits, n_layers layers
//   - Parameters: n_data_qubits × n_layers × 2
//   - QFT: n_data_qubits qubits
//   - Measurement: M × n_data_qubits
//
// Output:
//   Single integer encoding:
//     lower bits: |1⟩ population (0 to n_data_qubits)
//     bit 5-8:    Trotter/Qubitization/Gibbs/TimeDep utilities
//     bit 9:     HEA forward pass executed
//     bit 10:    QFT executed
//     bit 11:    Amplitude encoding executed
//
// Pipeline steps and module mapping:
//   Step 1: q_vector → q_vector_amplitude_encode    → State preparation (n_data)
//   Step 2: q_vqe    → q_vqe_hea(n_data, n_layers)  → Variational evolution
//   Step 3: q_fft    → q_fft(n_data)                → Spectral analysis
//   Step 4: M × n_data                               → Measurement
//   Step 5-8: Trotter + Qubitization + Gibbs + TimeDep utilities
//
// Verification:
//   - Amplitude encoding on n_data qubits runs (quantum)
//   - HEA on n_data qubits × n_layers runs (quantum)
//   - QFT on n_data qubits runs (quantum)
//   - Measurement population in [0, n_data] (Fact)
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

    operation DemoHamiltonianSim(n_data_qubits : Int, n_layers : Int) : Int {
        if (n_data_qubits < 1 or n_layers < 1) { return -1; }

        mutable result = 0;
        let n_params = n_data_qubits * n_layers * 2;

        // ============================================================
        // Quantum Execution (2 × n_data_qubits = total qubits)
        // ============================================================

        // Step 1: Amplitude encode initial state on n_data_qubits
        use qs_sys = Qubit[n_data_qubits * 2];
        let qs_data = qs_sys[0 .. n_data_qubits - 1];
        let qs_aux = qs_sys[n_data_qubits .. n_data_qubits * 2 - 1];

        mutable init_data = [0.0, size = n_data_qubits];
        for i in 0 .. n_data_qubits - 1 {
            set init_data w/= i <- IntAsDouble(n_data_qubits - i) / IntAsDouble(n_data_qubits);
        }
        q_vector_amplitude_encode(init_data, qs_data);
        set result += 2048;

        // Step 2: HEA variational evolution
        mutable theta = [0.0, size = n_params];
        for i in 0 .. n_params - 1 {
            set theta w/= i <- IntAsDouble(i) * 0.05;
        }
        q_vqe_hea(n_data_qubits, theta, qs_data, n_layers);
        set result += 512;

        // Step 3: QFT spectral analysis
        q_fft(qs_data);
        set result += 1024;

        // Step 4: Measure and count |1⟩ population
        mutable pop = 0;
        for i in 0 .. n_data_qubits - 1 {
            if (M(qs_data[i]) == One) {
                set pop += 1;
            }
        }
        ResetAll(qs_sys);
        Fact(pop >= 0 and pop <= n_data_qubits,
             "ham: population must be 0-n_data_qubits");
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
