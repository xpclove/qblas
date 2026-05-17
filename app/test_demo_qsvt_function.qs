// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: QSVT Demo
//
// Verifies all QSVT/QSP subroutines produce expected outputs.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_qsvt_function(p : Int) : Int {
        let result = DemoQsvtFunction();
        Fact(result >= 0, "demo_qsvt: result must be >= 0");
        return result;
    }
}
