// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: HHL + SVD Demo
//
// Verifies the HHL+SVD demo pipeline runs correctly.
// All SVD classical steps validated via Fact().
// HHL quantum step verified by non-crash + valid range.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_hhl_svd(p : Int) : Int {
        let result = DemoHhlSvd();
        Fact(result == 0, "demo_hhl_svd: should return 0 on success");
        return result;
    }
}
