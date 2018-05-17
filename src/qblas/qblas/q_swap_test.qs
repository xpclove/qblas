namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation q_swap_test (control:Qubit,u:Qubit[],v:Qubit[]) : ()
    {
        body
        {
            let nbit=Length(u);
            H(control);
            for(i in 0..1..(nbit-1) )
            {
                (Controlled SWAP)( [control], ( u[i],v[i] ) );
            }
            H(control); 
        }
        adjoint auto
		controlled auto
		controlled adjoint auto
    }
}
