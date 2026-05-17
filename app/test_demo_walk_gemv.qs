// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Test: Demo Walk GEMV (small config)
//
// Tests with 1 state qubit, 20 shots.
// Verifies all 5 Fact() assertions pass and result > 0.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_walk_gemv(p : Int) : Int {
        // Small config: 1 qubit, 20 shots → fast verification
        let result = DemoWalkGemv(1, 20, PI() / 4.0);
        Fact(result > 0, "demo_walk_gemv: result must be > 0");
        return result;
    }
}
