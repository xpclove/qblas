namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation q_swap_test_core (control:Qubit, u:Qubit[], v:Qubit[]) : Unit
    {
        body(...)
        {
            let nbit=Length(u);
            H(control);
            for(i in 0..1..(nbit-1) )
            {
                (Controlled SWAP)( [control], ( u[i],v[i] ) );
            }
            H(control); 
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
}
