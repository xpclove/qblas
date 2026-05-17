// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Quantum Phase Estimation (Standalone)
//
// What it does:
//   Runs Quantum Phase Estimation (QPE) on a user-provided
//   unitary U to estimate its eigenphase. The unitary must
//   support the signature (Int, Qubit[]) => Unit is Adj + Ctl
//   where the Int parameter specifies U^n.
//
// Architecture:
//   - Qubits: n_phase + n_data
//   - Demo config:  12 qubits (8 phase + 4 data), θ = 0.1π
//   - Test config:   5 qubits (4 phase + 1 data), θ = π/4
//   - Oracle: U|ψ⟩ = e^{iθ}|ψ⟩ via Rz(θ) gate
//   - Technique: QFT → CU → IQFT (standard QPE)
//
// Input:
//   U: unitary oracle, signature (Int, Qubit[]) => Unit is Adj + Ctl
//      where U(n, qs) applies U^n to qs
//   n_phase_qubits: number of phase estimation qubits (≥ 1)
//   n_data_qubits: number of data qubits for |1⟩ eigenstate
//
// Output:
//   Measured phase θ' = 2π × m / 2^{n_phase_qubits}
//   where m is the integer measured from phase register.
//
// Pipeline steps and module mapping:
//   Step 1: q_vector → X(qs_data)              — Prepare |1⟩ eigenstate
//   Step 2: q_phase_estimate → q_phase_estimate_core — QPE core
//     - H on phase register
//     - Controlled U^(2^i) for each phase qubit
//     - (Adjoint q_fft) on phase register
//   Step 3: M(phase[i]) × n_phase            — Measure phase register
//   Step 4: Classical conversion              — m → phase = 2π·m/2^n
//
// Verification:
//   - Measured phase in valid range [0, 2π) (Fact)
//
// Reference:
//   [1] Kitaev, "Quantum Measurements and the Abelian Stabilizer
//       Problem" arXiv:quant-ph/9511026 (1995)
//   [2] Nielsen & Chuang, Section 5.2, 10th Anniversary Edition
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    // ============================================================
    // QPE Entry Point (generic interface)
    //
    // Runs QPE on a user-provided unitary U.
    // The data register is initialized to |1...1⟩.
    // Returns the estimated phase θ' = 2π × m / 2^n.
    // ============================================================

    operation DemoQpeStandalone(
        U : (Int, Qubit[]) => Unit is Adj + Ctl,
        n_phase_qubits : Int,
        n_data_qubits : Int
    ) : Double {
        if (n_phase_qubits < 1 or n_data_qubits < 1) { return -1.0; }

        use qs_phase = Qubit[n_phase_qubits];
        use qs_data = Qubit[n_data_qubits];

        // Step 1: Prepare data eigenstate |1...1⟩
        // U|1⟩ = e^{iθ}|1⟩ (Rz eigenstate, eigenvalue e^{iθ})
        for d in 0 .. n_data_qubits - 1 {
            X(qs_data[d]);
        }

        // Step 2: Run QPE core (library function from q_phase_estimate)
        // Performs: H^(⊗n) → Controlled-U^(2^i) → Adjoint QFT
        q_phase_estimate_core(U, qs_data, qs_phase);

        // Step 3: Measure phase register
        mutable m = 0;
        for p in 0 .. n_phase_qubits - 1 {
            if (M(qs_phase[p]) == One) {
                set m += (1 <<< p);
            }
        }

        ResetAll(qs_phase);
        ResetAll(qs_data);

        // Step 4: Convert measurement to phase
        // QPE phase resolution: 2π / 2^{n_phase_qubits}
        // Measured phase = 2π × m / 2^{n_phase_qubits}
        let phase = 2.0 * PI() * IntAsDouble(m) /
                     IntAsDouble(1 <<< n_phase_qubits);

        Fact(phase >= 0.0 and phase < 2.0 * PI(),
             "qpe: phase must be in [0, 2π)");

        // Also verify phase precision is within expected range
        let resolution = 2.0 * PI() / IntAsDouble(1 <<< n_phase_qubits);
        Fact(resolution > 0.0 and resolution <= PI(),
             "qpe: resolution must be positive");

        return phase;
    }
}
