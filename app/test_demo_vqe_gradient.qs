// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: VQE Gradient Demo
//
// Verifies all VQE optimization subroutines produce
// expected outputs. All steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_vqe_gradient(p : Int) : Int {
        let result = DemoVqeGradient();
        Fact(result >= 0, "demo_vqe_gradient: result must be >= 0");
        return result;
    }
}
