namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation q_com_swap_all ( qs:Qubit[] ) : ()
    {
        body(...)
        {
            let nbit = Length(qs);
            for( i in 0..1..(nbit-1)/2 )
			{
				if( i != (nbit-1-i) )
				{
					SWAP( qs[i], qs[nbit-1-i] );
				}
			}
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}

