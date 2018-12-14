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
    function q_com_convert_tuples_to_complexpolars(data:(Double,Double)[]) : ComplexPolar[]
    {
        // DoubleTuple[]  to ComplexPolar[]
        let n = Length(data);
        mutable newdata = new ComplexPolar[n];
        for(i in 0..n-1)
        {
            set newdata[i]=ComplexPolar(data[i]);
        }
        return(newdata);
    }

        function q_com_convert_doubles_to_complexpolars(data:Double[]) : ComplexPolar[]
    {
        // Double[]  to ComplexPolar[]
        let n = Length(data);
        mutable newdata = new ComplexPolar[n];
        for(i in 0..n-1)
        {
            set newdata[i]=ComplexPolar(data[i], 0.0);
        }
        return(newdata);
    }
}

