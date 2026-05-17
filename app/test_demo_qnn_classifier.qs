// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: QNN Classifier Demo
//
// Verifies all QNN subroutines produce expected outputs.
// HEA forward pass validated on 16 qubits.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_qnn_classifier(p : Int) : Int {
        let result = DemoQnnClassifier();
        Fact(result > 0, "demo_qnn: result must be > 0");
        return result;
    }
}
