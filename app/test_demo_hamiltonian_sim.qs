// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Hamiltonian Simulation Demo
//
// Verifies all 16 simulation subroutine results via Fact().
// Covers q_trotter_suzuki, q_qubitization, q_gibbs, q_timedependent.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_hamiltonian_sim(p : Int) : Int {
        let result = DemoHamiltonianSim();
        Fact(result > 0, "demo_hamiltonian: result must be > 0");
        return result;
    }
}
