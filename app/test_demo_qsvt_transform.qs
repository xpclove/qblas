// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: QSVT Polynomial Transformation (small config)
//
// Tests with 2 qubits → 2+2=4 qubits.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_qsvt_transform(p : Int) : Int {
        // Small config: 2 qubits → fast verification
        let data = [1.0, 0.0];
        let result = DemoQsvtTransform(data);
        Fact(result > 0, "demo_qsvt: result must be > 0");
        return result;
    }
}
