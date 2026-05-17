// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Test: Demo Linear Algebra Solvers Suite (small config)
//
// Tests with 2 qubits, 10 SWAP measurements, π/4 evolution.
// Verifies all 21 Fact() assertions pass and result > 0.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_lin_solvers(p : Int) : Int {
        // Small config: 2 qubits, 10 measures → fast verification
        let result = DemoLinSolvers(2, 10, PI() / 4.0);
        Fact(result > 0, "demo_lin_solvers: result must be > 0");
        return result;
    }
}
