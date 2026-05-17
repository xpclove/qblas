// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Test: Block Encoding + LCU (small config)
//
// Tests with 2×2 diagonal matrix, 2 LCU coefficients.
//   q_be_diagonal: 2 sys + 2 anc + 2 lcu = 6 qubits
//   Verifies: pipeline runs, all Fact() assertions pass.
// ============================================================

namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    import Std.Diagnostics.Fact;
    open qblas;
    open qblas.applications;

    operation test_demo_block_lcu(p : Int) : Int {
        let matrix = [[1.0, 0.0], [0.0, 1.0]];
        let coeffs = [0.5, 0.5];

        let result = DemoBlockLcu(matrix, coeffs);
        Fact(result > 0, "demo_blcu: result must be > 0");
        return result;
    }
}
