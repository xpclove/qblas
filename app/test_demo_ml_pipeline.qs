// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Demo ML Pipeline
//
// Verifies the demo pipeline runs without error and produces
// a valid prediction (non-negative integer result).
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
        let result = DemoMLPipeline();
        Fact(result >= 0, "demo_ml_pipeline: prediction must be >= 0");
        return result;
    }
}
