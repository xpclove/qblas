namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;

    operation q_com_real_nbit_float():Int
    {
        return(2);
    }
    //颠倒量子比特顺序
    operation q_com_swap_all ( qs:Qubit[] ) : Unit
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
    function q_com_convert_tupless_to_complexpolarss(data:(Double,Double)[][]) : ComplexPolar[][]
    {
        // DoubleTuple[][]  to ComplexPolar[][]
        let n1 = Length(data);
        let n2 = Length(data[0]); 
        mutable newdata = new (ComplexPolar[])[n1];
        for(i in 0..n1-1)
        {
           mutable newdata_i = new (ComplexPolar)[n2];
            for(j in 0..n2-1)
            {
                set newdata_i[j]=ComplexPolar(data[i][j]);
            }
            set newdata[i] = newdata_i;
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
    function q_com_convert_doubless_to_complexpolarss(data:Double[][]) : ComplexPolar[][]
    {
        // DoubleTuple[][]  to ComplexPolar[][]
        let n1 = Length(data);
        let n2 = Length(data[0]); 
        mutable newdata = new (ComplexPolar[])[n1];
        for(i in 0..n1-1)
        {
           mutable newdata_i = new (ComplexPolar)[n2];
            for(j in 0..n2-1)
            {
                set newdata_i[j]=ComplexPolar(data[i][j], 0.0);
            }
            set newdata[i] = newdata_i;
        }
        return(newdata);
    }
    
    function q_com_convert_doubles_to_angles ( data:Double[] ): Int[]
    {
        // double to rotation angle for rotation
        let n = Length(data);
        mutable newdata = new Int[n];
        for(i in 0..n-1)
        {
            set newdata[i]= Floor( 2.0*ArcSin(data[i])/PI()*128.0 );
        }
        return(newdata);
    }
}

