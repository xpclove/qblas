// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: VQE Circuit Execution
//
// Verifies: HEA forward pass, measurement, classical utilities.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_vqe_execution(p : Int) : Int {
        let result = DemoVqeExecution();
        Fact(result > 0, "demo_vqe: result must be > 0");
        return result;
    }
}
