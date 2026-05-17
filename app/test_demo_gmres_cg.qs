// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Test: Demo GMRES CG (small config)
//
// Tests with 2 qubits, 10 SWAP measurements, 2 iterations.
// Verifies all Fact() assertions pass and result > 0.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_gmres_cg(p : Int) : Int {
        // Small config: 2 qubits, 10 measures, 2 iters → fast
        let result = DemoGmresCg(2, 10, 2, PI() / 4.0);
        Fact(result > 0, "demo_gmres_cg: result must be > 0");
        return result;
    }
}
