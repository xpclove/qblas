// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: QSVT Polynomial Transformation
//
// Verifies: QSP rotation on 8 qubits, measurement, utilities.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_qsvt_transform(p : Int) : Int {
        let result = DemoQsvtTransform();
        Fact(result > 0, "demo_qsvt: result must be > 0");
        return result;
    }
}
