// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: VQE Circuit Execution (small config)
//
// Tests with 4 qubits, 1 layer → 8 params.
// All classical steps validated via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_vqe_execution(p : Int) : Int {
        // Small config: 4 qubits, 1 layer → 8 params, fast
        let result = DemoVqeExecution(4, 1);
        Fact(result > 0, "demo_vqe: result must be > 0");
        return result;
    }
}
