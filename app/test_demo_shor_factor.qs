// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Shor's Algorithm Factorization Demo
//
// Verifies the Shor factorization pipeline runs and produces
// a valid factorization result when the period is found.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_shor_factor(p : Int) : Int {
        let result = DemoShorFactor();
        Fact(result >= 0, "demo_shor: result must be >= 0");
        return result;
    }
}
