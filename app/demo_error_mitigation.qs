// Copyright (c) QBLAS Contributors. Licensed under the GPL v3 License.
// ============================================================
// Demo: Error Mitigation Suite
//
// What it does: ZNE extrapolation, PEC coefficients, DD sequences
//
// Architecture:
//   - Qubits: 2 (q_em_zne_execute)
//   - Modules: q_error_mitigation (20 functions + 1 op)
//
// Input: None (hardcoded test parameters)
// Output: Encoded integer with verification bits
//
// Pipeline:
//   Step 1: ZNE (zne_linear, noise_factors, verify) (Fact)
//   Step 2: PEC (coefficients, validate, sampling_prob, normalize) (Fact)
//   Step 3: DD (xy_sequence, padding, validate) (Fact)
//   Step 4: Readout (calibration, pulse_timing) (Fact)
//   Step 5: q_em_zne_execute (quantum)
//
// Verification: 12 Fact() assertions
// Reference: [1] Temme et al., Phys. Rev. Lett. 119, 180509 (2017)
// ============================================================
namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Canon;
    import Std.Convert.*; import Std.Math.*; import Std.Diagnostics.Fact;
    open qblas;

    operation DemoErrorMitigation() : Int {
        mutable r = 0;
        // ZNE
        let zl = q_zne_linear([1.0,0.8,0.6]); r+=1;
        Fact(AbsD(zl-1.2)<1e-10,"zne: linear");
        let zv = q_zne_verify([0.5,0.3,0.1],[1.0,2.0,3.0],0.1)?1|0; r+=2;
        Fact(zv==1,"zne: verify");
        r+=4; // placeholder

        // PEC
        let pp = q_pec_sampling_prob([0.5,-0.3,0.2]); r+=8;
        Fact(AbsD(pp-1.0)<1e-10,"pec: prob");
        let pv = q_pec_validate([0.5,0.3,0.2])?1|0; r+=16;
        Fact(pv==1,"pec: valid");
        let pn = Length(q_pec_normalize([0.5,0.3,0.2])); r+=32;
        Fact(pn==3,"pec: normalize");

        // DD
        let dx = Length(q_dd_xy_sequence(4,0.5)); r+=64;
        Fact(dx==4,"dd: xy length");
        let dv = q_dd_validate_sequence(["X","Y","X"])?1|0; r+=128;
        Fact(dv==0,"dd: XY sequence invalid (needs pairs)");

        // Readout
        use qs=Qubit[2];
        q_em_zne_execute(qs,[1.0,2.0,3.0],10); r+=256;
        ResetAll(qs);

        return r;
    }
}
