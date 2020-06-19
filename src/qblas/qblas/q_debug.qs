namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Convert;
    
	function q_print_s(item:String ):Unit
    {
            Message(item);
    }

	function q_print(item:Int[] ):Unit
    {
        let N = Length(item);
        for(i in 0..N-1)
        {
            let p = item[i];
            Message( IntAsString(p) );
        }
        Message("___________");
    }
    function q_print_D (item:Double[] ):Unit
    {
            let N = Length(item);
            for(i in 0..N-1)
            {
                let p = item[i];
                Message( DoubleAsString(p) );
            }
            Message("___________");
    }
}
