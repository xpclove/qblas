namespace Quantum.test {
    open Microsoft.Quantum.Intrinsic; import Std.Diagnostics.Fact;
    open qblas; open qblas.applications;
    operation test_demo_spectral_analysis(p:Int):Int {
        let r=DemoSpectralAnalysis(); Fact(r>0,"result>0"); return r;
    }
}
