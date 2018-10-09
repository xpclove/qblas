namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;

    newtype ComplexPolar = (Double, Double);
    
    //模拟读取量子内存 RAM[qs_address] = qs_data
    //qs_data 处于0态
    operation q_ram_qstoint(qs_data:Qubit[], data:Int) : ()
    {
        body
        {
            let n_q = Length(qs_data);
            for(i in 0..n_q-1 )
            {
                let bit = 2^i;
                if ( (data&&&bit) != 0)
                {
                    X (qs_data[i]);
                }
            }
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
    operation q_ram_call_bool ( RAM : Int[], qs_address:Qubit[], qs_data:Qubit[] ) : ()
    {
        body
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            using(qs_tmp = Qubit[n_a])
            {
                for(i in 0..(N_RAM-1) )
                {
                    let next_address = RAM[i];
                    if(next_address != 0)
                    {
                        for( j in 0..(n_a-1) )
						{
							let bit =2^j;
							if ( i&&&bit !=0)
							{
							
							}
						}

                    }
                }
            }
        }
    }
    
}
