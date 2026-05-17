namespace Quantum.test {
    open Microsoft.Quantum.Intrinsic; import Std.Diagnostics.Fact;
    open qblas; open qblas.applications;
    operation test_demo_error_mitigation(p:Int):Int {
        let r=DemoErrorMitigation(); Fact(r>0,"result>0"); return r;
    }
}
