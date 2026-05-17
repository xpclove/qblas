// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.
// ============================================================
// Demo: Spectral Analysis Suite
//
// What it does: Spectrale analyse via Chebyshev, eigenvalue filter, pseudoinverse
//
// Architecture:
//   - Qubits: 8 (quantum eigenvalue filter)
//   - Modules: q_chebyshev, q_eigenvalue_filter, q_pseudoinverse
//
// Input: None (hardcoded test parameters)
// Output: Encoded integer with verification bits
//
// Pipeline:
//   Step 1: q_chebyshev → polynomials, map, error bound (Fact)
//   Step 2: q_eigenvalue_filter → lowpass, highpass, bandpass (Fact)
//   Step 3: q_pseudoinverse → coeffs, check, effective cond (Fact)
//
// Verification: 9 Fact() assertions
// Reference: [1] Trefethen, Approximation Theory, SIAM 2013
// ============================================================
namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic; open Microsoft.Quantum.Canon;
    import Std.Convert.*; import Std.Math.*; import Std.Diagnostics.Fact;
    open qblas;

    operation DemoSpectralAnalysis() : Int {
        mutable r = 0;
        // Chebyshev
        let cp = q_chebyshev_polynomials(0.5, 3);
        Fact(Length(cp)==4, "cheb: length 4");
        Fact(AbsD(cp[0]-1.0)<1e-10,"cheb: T0=1");
        r+=1;
        let cd = q_chebyshev_select_degree(10.0, 1e-6);
        Fact(cd>=1,"cheb: degree selected"); r+=2;
        let ce = q_chebyshev_error_bound([1.0,0.5,0.25],3);
        Fact(AbsD(ce-0.0)<1e-10,"cheb: error bound"); r+=4;

        // Eigenvalue filter
        let fl = q_eigenvalue_filter_lowpass(0.5,2.0,0.1);
        Fact(Length(fl)==3,"eig: lowpass"); r+=8;
        let fh = q_eigenvalue_filter_highpass(1.0,3.0,0.1);
        Fact(Length(fh)>=3,"eig: highpass"); r+=16;
        let fb = q_eigenvalue_filter_bandpass(0.3,0.8,2.0,0.1);
        Fact(Length(fb)>=2,"eig: bandpass"); r+=32;

        // Pseudoinverse
        let pc = q_pseudoinverse_coeffs(2.0,1e-6);
        Fact(Length(pc)>0,"pinv: coeffs"); r+=64;
        let pk = q_pseudoinverse_check_applicable(2.0,1e-6)?1|0;
        Fact(pk==1,"pinv: applicable"); r+=128;
        let pe = q_pseudoinverse_effective_condition(2.0,0.5);
        Fact(AbsD(pe-4.0)<1e-10,"pinv: eff cond"); r+=256;
        return r;
    }
}
