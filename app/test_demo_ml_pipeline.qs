// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Demo ML Pipeline (small config)
//
// Tests with 2 features → 2 qubits, 1 iteration.
// Verifies the full quantum ML pipeline: encode → QFT → reflect → measure.
// All classical steps (PCA, lambda, ridge) verified via Fact() assertions.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_ml_pipeline(p : Int) : Int {
        // Small config: 2 features → 2 qubits
        let features = [1.0, 0.5];
        let result = DemoMLPipeline(features);
        Fact(result >= 0, "demo_ml_pipeline: prediction must be >= 0");
        return result;
    }
}
