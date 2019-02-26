namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;

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
            Message( ToStringI(p) );
        }
        Message("___________");
    }
    function q_print_D (item:Double[] ):Unit
    {
            let N = Length(item);
            for(i in 0..N-1)
            {
                let p = item[i];
                Message( ToStringD(p) );
            }
            Message("___________");
    }
}
