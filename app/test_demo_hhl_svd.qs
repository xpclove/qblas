// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: HHL + SVD Demo (small config)
//
// Tests with 2D RHS vector [1.0, 0.5] → 7 qubits.
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
        // Small config: 2D RHS vector → same oracle (fixed 2×2)
        let b = [1.0, 0.5];
        let result = DemoHhlSvd(b);
        // svd_ok=0 (bits 0), hhl_ok=0 or 1 (bit 1) → result = 0 or 2
        Fact(result == 0 or result == 2,
             "demo_hhl_svd: should return 0 or 2");
        return result;
    }
}
