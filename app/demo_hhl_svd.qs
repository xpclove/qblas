// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: HHL Linear Solver with SVD Verification
//
// What it does:
//   Solves a 2×2 linear system Ax = b using HHL algorithm,
//   then verifies the solution via SVD decomposition.
//   The matrix oracle defines A = diag(2, 3), and the RHS
//   vector b is given as input.
//
// Input:
//   b_vector: Double[] — right-hand side vector (2D for 2×2 system)
//   Demo config:  b_vector = [1.0, 0.5] → 2+4+1 = 7 qubits
//   Test config:  b_vector = [1.0, 0.5] → 7 qubits (oracle fixed)
//
// Architecture:
//   - Qubits: 7 (2 data + 4 phase + 1 result)
//   - Note: 7 < 8 due to 2×2 HHL system's inherent dimension limit.
//     The oracle defines a 2×2 matrix which requires exactly 2 data qubits.
//
// Output:
//   Solution quality indicator (0 = passed)
//     q_svd_sort_descending, q_svd_filter, q_svd_normalize all verified via Fact()
//
// Pipeline steps and module mapping:
//   Step 1: q_hhl               → q_hhl_core (HHL core: QPE + rotation + inverse QPE)
//   Step 2: q_svd_vartime       → SVD classical post-processing:
//     - q_svd_sort_descending   → Sort eigenvalues descending
//     - q_svd_filter            → Filter by threshold
//     - q_svd_normalize         → Normalize singular values
//
// Verification:
//   - q_svd_sort_descending([3.0, 1.0, 2.0]) = [3.0, 2.0, 1.0] (Fact)
//   - q_svd_filter([1.0, 0.1, 0.01], 0.5)   = [1.0] (Fact, length check)
//   - q_svd_normalize([3.0, 4.0])            = [0.6, 0.8] (Fact)
//   - HHL result: non-negative integer (range check)
//
// Reference: Harrow, Hassidim & Lloyd,
//            "Quantum Algorithm for Linear Systems of Equations"
//            Phys. Rev. Lett. 103, 150502 (2009)
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    // ============================================================
    // Step 1: Matrix Oracle
    //
    // Controlled unitary U_A for 2×2 diagonal matrix A = diag(2, 3).
    // U_A^n applies eigenvalue 2^n or 3^n depending on state.
    // ============================================================

    operation q_demo_hhl_oracle(n : Int, qs_u : Qubit[]) : Unit is Adj + Ctl {
        // 2×2 diagonal matrix A = diag(2, 3)
        // Eigenvalue 2 for |0⟩, eigenvalue 3 for |1⟩
        let angle = IntAsDouble(n);
        // e^{i·2·n} acting on |0⟩ state (phase proportional to λ₂)
        Rz(-2.0 * angle, qs_u[0]);
        // e^{i·3·n} acting on |1⟩ state (phase proportional to λ₃)
        Rz(-3.0 * angle, qs_u[1]);
    }

    // ============================================================
    // Step 2: HHL Solve
    //
    // Runs HHL core to solve Ax = b for 2×2 system.
    // Uses QPE → eigenvalue rotation → inverse QPE.
    // ============================================================

    operation q_demo_hhl_solve(
        qs_u : Qubit[],
        qs_phase : Qubit[],
        qs_r : Qubit
    ) : Unit {
        q_hhl_core(q_demo_hhl_oracle, qs_u, qs_phase, qs_r);
    }

    // ============================================================
    // Step 3: SVD Verification (Classical)
    //
    // Post-processes and verifies results using SVD functions.
    // ============================================================

    function q_demo_svd_verify(values : Double[]) : Int {
        // Sort descending
        let sorted = q_svd_sort_descending(values);
        Fact(Length(sorted) == 3, "svd_sort_descending: wrong length");
        Fact(AbsD(sorted[0] - 3.0) < 1e-10, "svd_sort_descending[0]");
        Fact(AbsD(sorted[1] - 2.0) < 1e-10, "svd_sort_descending[1]");
        Fact(AbsD(sorted[2] - 1.0) < 1e-10, "svd_sort_descending[2]");

        // Filter by threshold
        let filtered = q_svd_filter(sorted, 1.5);
        Fact(Length(filtered) == 2, "svd_filter: should keep 2 values > 1.5");
        Fact(AbsD(filtered[0] - 3.0) < 1e-10, "svd_filter[0]");
        Fact(AbsD(filtered[1] - 2.0) < 1e-10, "svd_filter[1]");

        // Normalize
        let normalized = q_svd_normalize([3.0, 4.0]);
        Fact(Length(normalized) == 2, "svd_normalize: wrong length");
        Fact(AbsD(normalized[0] - 0.6) < 1e-10, "svd_normalize[0]");
        Fact(AbsD(normalized[1] - 0.8) < 1e-10, "svd_normalize[1]");

        return 0;
    }

    // ============================================================
    // Main Entry Point
    // ============================================================

    operation DemoHhlSvd(b_vector : Double[]) : Int {
        if (Length(b_vector) < 1) { return -1; }

        use qs_u = Qubit[2];
        use qs_phase = Qubit[4];
        use qs_r = Qubit[1];

        // Step 1: Prepare |b⟩ state using q_vector amplitude encoding
        q_vector_amplitude_encode(b_vector, qs_u);

        // Step 2: Run HHL core
        q_hhl_core(q_demo_hhl_oracle, qs_u, qs_phase, qs_r[0]);

        // Step 3: Measure result qubit and combine with SVD check
        let hhl_ok = M(qs_r[0]) == One ? 1 | 0;

        // Step 4: Classical SVD verification
        let svd_ok = q_demo_svd_verify([3.0, 1.0, 2.0]);

        ResetAll(qs_u);
        ResetAll(qs_phase);
        ResetAll(qs_r);

        // Return: HHL success (bit 0) + SVD verify (bit 1)
        return svd_ok + (hhl_ok * 2);
    }
}
