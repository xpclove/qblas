// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Hamiltonian Simulation Demo (small config)
//
// Tests with 2 data qubits, 1 layer → 4 qubits total, fast.
// All classical planning utilities verified via Fact().
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_hamiltonian_sim(p : Int) : Int {
        // Small config: 2 data qubits, 1 layer → 4 qubits total
        let result = DemoHamiltonianSim(2, 1);
        Fact(result > 0, "demo_hamiltonian: result must be > 0");
        return result;
    }
}
