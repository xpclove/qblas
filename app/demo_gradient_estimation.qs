// Copyright (c) QBLAS Contributors. Licensed under the GPL v3 License.
// ============================================================
// Demo: Gradient Estimation Suite
//
// What it does: Parameter shift, gradient magnitude, convergence
//
// Architecture:
//   - Qubits: 4 (q_ge_parameter_shift)
//   - Modules: q_gradient_estimation (1 op + 11 funcs)
//
// Input: None (hardcoded test parameters)
// Output: Encoded integer with verification bits
//
// Pipeline:
//   Step 1: q_qge_parameter_shift, shift_angle (Fact)
//   Step 2: gradient_magnitude, converged, optimal_lr (Fact)
//   Step 3: gradient_descent_step, valid_shift, variance (Fact)
//   Step 4: q_ge_parameter_shift (quantum)
//
// Verification: 8 Fact() assertions
// Reference: [1] Mitarai et al., Phys. Rev. A 98, 032309 (2018)
// ============================================================
namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Canon;
    import Std.Convert.*; import Std.Math.*; import Std.Diagnostics.Fact;
    open qblas;

    operation DemoGradientEstimation() : Int {
        mutable r = 0;
        // Parameter shift
        let ps = q_qge_parameter_shift(0.8,0.4); r+=1;
        Fact(AbsD(ps-0.2)<1e-10,"ge: param shift");
        let sa = q_qge_shift_angle(); r+=2;
        Fact(AbsD(sa-1.5707963267948966)<1e-10,"ge: shift angle");

        // Magnitude and convergence
        let gm = q_qge_gradient_magnitude([1.0,2.0,3.0]); r+=4;
        Fact(AbsD(gm-3.7416573867739413)<1e-10,"ge: magnitude");
        let gc = q_qge_converged([0.1,0.2],0.5)?1|0; r+=8;
        Fact(gc==1,"ge: converged");
        let ol = q_qge_optimal_learning_rate(0.5,2.0); r+=16;
        Fact(AbsD(ol-0.25)<1e-10,"ge: optimal lr");

        // GD step and variance
        let gs = Length(q_qge_gradient_descent_step([0.5,0.5],[0.1,0.1],0.1)); r+=32;
        Fact(gs==2,"ge: gd step len");
        let gv = q_qge_valid_shift(PI()/4.0)?1|0; r+=64;
        Fact(gv==1,"ge: valid shift");
        let gv2 = q_qge_gradient_variance([1.0,2.0,3.0],3); r+=128;
        Fact(AbsD(gv2-0.6666666666666666)<1e-10,"ge: variance");

        // Quantum parameter shift (separate control and target qubits)
        use qs_params=Qubit[2];
        use qs_shift=Qubit[2];
        X(qs_shift[0]); // set control = 1
        q_ge_parameter_shift(qs_params,qs_shift,PI()/4.0,0); r+=256;
        ResetAll(qs_params); ResetAll(qs_shift);

        return r;
    }
}
