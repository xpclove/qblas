namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;

    operation q_com_real_nbit_float( ) : Int
    {
        //设置 real 浮点位数
        let nbit_float = 2;
        return(nbit_float);
    }
    //颠倒全部量子比特顺序
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
    function q_com_convert_ints_to_complexpolars(data:Int[]) : ComplexPolar[]
    {
        // Int[]  to ComplexPolar[]
        let n = Length(data);
        mutable newdata = new ComplexPolar[n];
        for(i in 0..n-1)
        {
            set newdata[i]=ComplexPolar(ToDouble( data[i] ), 0.0);
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
    function q_com_convert_tuples_to_angles ( data:(Double, Double)[] ): (Int,Int)[]
    {
        // Polar (double,double) to rotation (angle,angle) for rotation
        let n = Length(data);
        mutable newdata = new (Int, Int)[n];
        for(i in 0..n-1)
        {
            let (data_r, data_i) = data[i];
            let angle_r = Floor( 2.0*ArcSin( data_r )/PI()*128.0 );
            let angle_i = Floor( data_i/PI()*128.0 );
            set newdata[i]= (angle_r, angle_i);
        }
        return(newdata);
    }

    function q_com_array_join ( qa: Qubit[], qb:Qubit[] ) : Qubit[] 
    {
        let na = Length(qa);
        let nb = Length(qb);
        let n = na + nb;
        mutable qs = new Qubit[n];
        for( i in 0..na-1)
        {
            set qs[i] = qa[i];
        }
        for( i in 0..nb-1)
        {
            set qs[ na+i ] = qb[i];
        }
        return (qs);
    }
    operation q_com_apply ( op: (Qubit => Unit: Adjoint, Controlled), qs: Qubit[]): Unit
    {
        body(...)
        {
            for ( i in 0..Length(qs)-1)
            {
                op (qs[i]);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}

