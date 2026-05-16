namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;

    // ============================================================
    // Debug and diagnostic operations
    // ============================================================

    // Print a string message
    function q_print_s(item : String) : Unit {
        Message(item);
    }

    // Print integer array
    function q_print(item : Int[]) : Unit {
        let N = Length(item);
        for i in 0 .. N - 1 {
            let p = item[i];
            Message($"{p}");
        }
        Message("___________");
    }

    // Print double array
    function q_print_D(item : Double[]) : Unit {
        let N = Length(item);
        for i in 0 .. N - 1 {
            let p = item[i];
            Message($"{p}");
        }
        Message("___________");
    }
}