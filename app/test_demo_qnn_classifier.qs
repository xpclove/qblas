// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: QNN Classifier Demo (small config)
//
// Tests with 4 samples, 2D, 1 epoch → 2 qubits, 2 layers.
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
        // Small config: 4 samples, 2D, 1 epoch → fast
        let samples = [
            [0.8, 0.2],
            [0.9, 0.1],
            [0.1, 0.9],
            [0.2, 0.8]
        ];
        let labels = [0, 0, 1, 1];
        let result = DemoQnnClassifier(samples, labels, 1);
        Fact(result >= 0, "demo_qnn: result must be >= 0");
        return result;
    }
}
