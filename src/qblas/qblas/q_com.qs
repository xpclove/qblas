namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //颠倒量子比特顺序
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
    
    //Ref: Quantum Algorithms for Scientific Computing and Approximate Optimization(2018)
    operation q_math_reciprocal_int( w:Qubit[], x:Qubit[]) : Unit
    {
        body(...)
        {
            let n = Length(w);
            let b =  Length(x);
            //prepare x_0
            CNOT (w[n-1], x[b-1]);
            for ( i in 2..1..b)
            {
                X(x[b-i+1]);
                CCNOT( w[n-1],x[b-i+1], x[b-i] );
                X(x[b-i+1]);
            }
            //Newton iteration method for x=1/w;
            for ( i in  n-1..-1..1)
            {

            }

        }
    }
}

