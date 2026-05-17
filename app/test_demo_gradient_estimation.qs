namespace Quantum.test {
    open Microsoft.Quantum.Intrinsic; import Std.Diagnostics.Fact;
    open qblas; open qblas.applications;
    operation test_demo_gradient_estimation(p:Int):Int {
        let r=DemoGradientEstimation(); Fact(r>0,"result>0"); return r;
    }
}
