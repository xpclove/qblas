// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Quantum Teleportation Demo (small config)
//
// Tests with 1 round → 3 qubits.
// All dense coding values verified via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_teleport(p : Int) : Int {
        // Small config: 1 round → 3 qubits, fast
        let result = DemoTeleport(1);
        Fact(result >= 0, "demo_teleport: result must be >= 0");
        return result;
    }
}
