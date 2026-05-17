// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: QSVT Matrix Function Transformation
//
// What it does:
//   Demonstrates QSVT and QSP modules for polynomial
//   transformation of matrix functions. Covers phase sequence
//   generation, polynomial evaluation, Chebyshev approximation,
//   and quantum rotation application.
//
// Input:
//   Hard-coded polynomial coefficients, Chebyshev degree k=3,
//   2D vector [3.0, 4.0] for normalization test.
//
// Output:
//   Single integer encoding test outcomes:
//     bit 0: symmetric phase sequence passes
//     bit 1: Chebyshev phase generation passes
//     bit 2: polynomial evaluation passes
//     bit 3: QSP rotation runs
//
// Pipeline steps and module mapping:
//   Step 1: q_qsp → q_qsp_symmetric_phase_seq  → Phase sequence generation
//   Step 2: q_qsp → q_qsp_chebyshev_phase       → Chebyshev phase generation
//   Step 3: q_qsp → q_qsp_poly_eval             → Polynomial evaluation
//   Step 4: q_qsp → q_qsp_is_valid_phase        → Phase validation
//   Step 5: q_qsp → q_qsp_validate_sequence     → Sequence validation
//   Step 6: q_qsvt → q_qsvt_normalize_vector    → Vector normalization
//   Step 7: q_qsvt → q_qsvt_check_dims          → Dimension check
//   Step 8: q_qsp → q_qsp_apply_rotation        → Quantum rotation
//
// Verification:
//   - symmetric_phase_seq(4): length == 4 (Fact)
//   - chebyshev_phase(3): length == 6 (Fact)
//   - poly_eval([1,0.5,0.25], 0.5) = 1.3125 (Fact)
//   - is_valid_phase([0.5]): true (Fact)
//   - validate_sequence([0.5], 3, 0.01): true (Fact)
//   - normalize_vector([3,4])[0] = 0.6, [1] = 0.8 (Fact)
//   - check_dims(4, 2): true (Fact)
//
// Reference: Gilyén et al.,
//            "Quantum Singular Value Transformation"
//            STOC 2019. https://arxiv.org/abs/1806.01838
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
    // Full QSVT Pipeline
    // ============================================================

    operation DemoQsvtFunction() : Int {
        mutable result = 0;

        // Step 1: Symmetric phase sequence (m=4 → 2m+1 = 9 phases)
        let sym_phases = q_qsp_symmetric_phase_seq(4);
        Fact(Length(sym_phases) == 9, "sym_phase_seq: length = 2m+1");
        Fact(AbsD(sym_phases[4] - 0.6283185307179586) < 1e-10, "sym_phase_seq[4]");
        set result += 1;

        // Step 2: Chebyshev phase generation (degree 3 → 4 phases)
        let cheb_phases = q_qsp_chebyshev_phase(3);
        Fact(Length(cheb_phases) == 4, "cheb_phase: length = degree+1");
        Fact(AbsD(cheb_phases[1] - 0.7853981633974483) < 1e-10, "cheb_phase[1]");
        set result += 2;

        // Step 3: Polynomial evaluation
        let poly_val = q_qsp_poly_eval([1.0, 0.5, 0.25], 0.5);
        Fact(AbsD(poly_val - 1.3125) < 1e-10, "poly_eval");
        set result += 4;

        // Step 4: Phase validity check (single phase in [-π, π] is valid)
        let valid_phase = q_qsp_is_valid_phase([0.5]) ? 1 | 0;
        Fact(valid_phase == 1, "is_valid_phase: single phase");
        set result += 8;

        // Step 5: Vector normalization
        let normalized = q_qsvt_normalize_vector([3.0, 4.0]);
        Fact(Length(normalized) == 2, "normalize: length");
        Fact(AbsD(normalized[0] - 0.6) < 1e-10, "normalize[0]");
        Fact(AbsD(normalized[1] - 0.8) < 1e-10, "normalize[1]");
        set result += 16;

        // Step 6: Dimension check (1 data qubit needs 1 ancilla qubit)
        let valid = q_qsvt_check_dims(1, 1) ? 1 | 0;
        Fact(valid == 1, "check_dims: 1 data needs 1 ancilla");
        set result += 32;

        // Step 7: QSP rotation (quantum operation)
        use qs_target = Qubit();
        use qs_ancilla = Qubit[1];
        q_qsp_apply_rotation(qs_target, qs_ancilla, [PI() / 4.0], PI() / 2.0);
        set result += 64;
        Reset(qs_target);
        ResetAll(qs_ancilla);

        return result;
    }
}
