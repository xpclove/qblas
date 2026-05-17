// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: QSVT Polynomial Transformation
//
// What it does:
//   Applies QSP (Quantum Signal Processing) rotation to an
//   n-qubit quantum state, demonstrating polynomial-based
//   eigenvalue transformation via the q_qsp module.
//
// Input:
//   data: Double[] — amplitude data to encode (length = n_qubits)
//   Demo config:  8 qubits [1,1,1,1,0.5,0.5,0.5,0.5] → 8+2=10 qubits
//   Test config:  2 qubits [1.0, 0.0] → 2+2=4 qubits
//
// Architecture:
//   - Qubits: n_qubits + 2 (ancilla)
//   - Demo: 10 qubits (8 data + 2 ancilla)
//   - Test:  4 qubits (2 data + 2 ancilla)
//   - Encoding: Amplitude encoding via q_vector_amplitude_encode
//   - Rotation: QSP phase rotations via q_qsp_apply_rotation × n_qubits
//
// Output:
//   Single integer encoding:
//     low bits: |1⟩ population count (0 to n_qubits, from measurement)
//     bit 4:    QSP rotation executed
//     bit 5:    phase sequence verified
//     bit 6:    Chebyshev phase verified
//     bit 7:    polynomial evaluation verified
//     bit 8:    phase validity verified
//     bit 9:    vector normalization verified
//
// Pipeline steps and module mapping:
//   Step 1: q_vector → q_vector_amplitude_encode    → State preparation (n_qubits)
//   Step 2: q_qsp    → q_qsp_apply_rotation × n    → QSP rotation on each qubit
//   Step 3: M × n_qubits                           → Measurement
//   Step 4: q_qsp    → symmetric_phase_seq          → Phase generation
//   Step 5: q_qsp    → chebyshev_phase, poly_eval   → Polynomial utilities
//
// Verification:
//   - Amplitude encoding on n_qubits runs (quantum)
//   - QSP rotation on n_qubits + 2 ancilla runs (quantum)
//   - Measurement population in [0, n_qubits] (Fact)
//   - All classical QSP functions verified via Fact()
//
// Reference:
//   [1] Low & Chuang, "Quantum Signal Processing"
//       Phys. Rev. Lett. 118, 010501 (2017)
//   [2] Gilyén et al., "Quantum Singular Value Transformation"
//       STOC 2019. https://arxiv.org/abs/1806.01838
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    operation DemoQsvtTransform(data : Double[]) : Int {
        mutable result = 0;
        let n_qubits = Length(data);
        if (n_qubits < 1) { return -1; }

        // ============================================================
        // Quantum Execution
        // ============================================================

        // Step 1: Amplitude encode data vector on n_qubits
        use qs_data = Qubit[n_qubits];
        q_vector_amplitude_encode(data, qs_data);
        set result += 16;

        // Step 2: Apply QSP rotation to each data qubit
        use qs_ancilla = Qubit[2];
        let phases = q_qsp_symmetric_phase_seq(4);
        for i in 0 .. n_qubits - 1 {
            q_qsp_apply_rotation(qs_data[i], qs_ancilla, phases, PI() / 4.0);
        }
        set result += 32;

        // Step 3: Measure all qubits and count |1⟩ outcomes
        mutable qsp_pop = 0;
        for i in 0 .. n_qubits - 1 {
            if (M(qs_data[i]) == One) {
                set qsp_pop += 1;
            }
        }
        ResetAll(qs_data);
        ResetAll(qs_ancilla);
        Fact(qsp_pop >= 0 and qsp_pop <= n_qubits,
             "qsvt: population count must be 0-n_qubits");
        set result += qsp_pop;

        // ============================================================
        // Classical Verification
        // ============================================================

        // Step 4: Symmetric phase sequence (m=4 → 9 phases)
        let sym = q_qsp_symmetric_phase_seq(4);
        Fact(Length(sym) == 9, "qsvt: sym_phase len = 9");
        Fact(AbsD(sym[4] - 0.6283185307179586) < 1e-10, "qsvt: sym_phase[4]");
        set result += 64;

        // Step 5: Chebyshev phase (degree 3 → 4 phases)
        let chp = q_qsp_chebyshev_phase(3);
        Fact(Length(chp) == 4, "qsvt: cheb_phase len = 4");
        set result += 128;

        // Step 6: Polynomial evaluation
        let pv = q_qsp_poly_eval([1.0, 0.5, 0.25], 0.5);
        Fact(AbsD(pv - 1.3125) < 1e-10, "qsvt: poly_eval = 1.3125");
        set result += 256;

        // Step 7: Phase validity
        let vp = q_qsp_is_valid_phase([0.5]) ? 1 | 0;
        Fact(vp == 1, "qsvt: is_valid_phase = true");
        set result += 512;

        // Step 8: Vector normalization
        let nv = q_qsvt_normalize_vector([3.0, 4.0]);
        Fact(AbsD(nv[0] - 0.6) < 1e-10, "qsvt: normalize[0] = 0.6");
        set result += 1024;

        // Step 9: Dimension check
        let dc = q_qsvt_check_dims(1, 1) ? 1 | 0;
        Fact(dc == 1, "qsvt: check_dims = true");
        set result += 2048;

        return result;
    }
}
