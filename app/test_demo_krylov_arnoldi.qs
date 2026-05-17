// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Test: Demo Krylov Arnoldi (small config)
//
// Tests with 2 qubits, 10 SWAP measurements.
// Verifies all Fact() assertions pass and result > 0.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_krylov_arnoldi(p : Int) : Int {
        // Small config: 2 qubits, 10 measure, π/4 → fast verification
        let result = DemoKrylovArnoldi(2, 10, PI() / 4.0);
        Fact(result > 0, "demo_krylov_arnoldi: result must be > 0");
        return result;
    }
}
