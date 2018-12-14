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
    function q_com_convert_tuple_to_complexpolar(data:(Double,Double)[]) : ComplexPolar[]
    {
        // ...
        let n = Length(data);
        mutable newdata = new ComplexPolar[n];
        for(i in 0..n-1)
        {
            set newdata[i]=ComplexPolar(data[i]);
        }
        return(newdata);
    }

}

