namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	
	operation q_print (item:Int[] ):Unit
    {
        body(...)
        {
            let line ="";
            let N = Length(item);
            for(i in 0..N-1)
            {
                let p = item[i];
                Message( ToStringI(p) );
            }
            Message("___________");
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}
