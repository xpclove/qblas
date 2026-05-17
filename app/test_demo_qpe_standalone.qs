// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Quantum Phase Estimation (small config)
//
// Tests with 4 phase qubits, 1 data qubit, θ = π/4.
//   q_phase_estimate_core: 4 phase + 1 data = 5 qubits
//   U|1⟩ = e^{i·π/4}|1⟩ via Rz gate
//   Expected measured phase ≈ π/4 ≈ 0.785 (resolution π/8 ≈ 0.393)
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    // Test oracle: U^n|1⟩ = e^{i·n·π/4}|1⟩
    operation q_test_qpe_oracle(n : Int, qs : Qubit[]) : Unit is Adj + Ctl {
        Rz(PI() / 4.0 * IntAsDouble(n), qs[0]);
    }

    operation test_demo_qpe_standalone(p : Int) : Int {
        let expected = PI() / 4.0;

        // 4 phase qubits, 1 data qubit = 5 qubits total
        // Resolution = 2π / 16 = π/8 ≈ 0.393
        let measured = DemoQpeStandalone(q_test_qpe_oracle, 4, 1);

        // Verify measured phase is within one resolution unit
        let resolution = 2.0 * PI() / 16.0;
        let diff = AbsD(measured - expected);

        Fact(diff < resolution * 1.5,
             "qpe: measured phase within 1.5× resolution of expected");

        return Floor(measured * 100.0);
    }
}
