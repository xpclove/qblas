namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;

    newtype ComplexPolar = (Double, Double);
    newtype QBLAS_M_Weight  = (Int, Int, Int) ;
    // newtype QBLAS_M_Real  = (Int,Int);

    
    //函数赋值，qs_data 处于|0>态, 制备到 |data> 基矢态
    operation q_ram_function_assignment_int ( qs_data:Qubit[], data:Int ) : ()
    {
        body
        {
            let n_d = Length(qs_data);
            for(i in 0..n_d-1 )
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

    // //寻址操作
    // operation q_ram_addressing ( qs_address:Qubit[] ) : ()
    // {
    //     let n_a = Length(qs_address);
    //     body
    //     {
    //         for( j in 0..(n_a-1) )
    //         {
    //             let bit = 2^j;
    //             if ( (i&&&bit) == 0 )
    //             {
    //                 X (qs_address[j]);
    //             }
    //         }
    //     }
    // }


    //模拟读取量子内存 RAM[qs_address] = qs_data
	// |qs_address>|qs_data>|qs_r>	->	 |qs_address>|RAM[qs_address]>|1>
    operation q_ram_call_bool ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : ()
    {
        body
        {
            let N_RAM = Length(RAM);
            let n_d = Length(qs_data);
            let n_a = Length(qs_address);
            
                for(i in 0..(N_RAM-1) )
                {
                    let (address, next_address, weight) = RAM[i];

                    // do 寻址
                    for( j in 0..(n_a-1) )
                    {
                        let bit = 2^j;
                        if ( ( address&&&bit ) == 0 )
                        {
                            X (qs_address[j]);
                        }
                    }

                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                    X (qs_weight[0]);

                    // undo 寻址
                    for( j in 0..(n_a-1) )
                    {
                        let bit = 2^j;
                        if ( ( address&&&bit ) == 0 )
                        {
                            X (qs_address[j]);
                        }
                    }

                }
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }


     operation q_ram_call_integer ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : ()
    {
        body
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            
                for(i in 0..(N_RAM-1) )
                {
                        let (address, next_address, weight) = RAM[i];
                        
                        for( j in 0..(n_a-1) )
						{
							let bit = 2^j;
							if ( ( address&&&bit) == 0 )
							{
                                X (qs_address[j]);
							}
						}

						(Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );

                        for( j in 0..(n_a-1) )
						{
							let bit = 2^j;
							if ( ( address&&&bit) == 0 )
							{
                                X (qs_address[j]);
							}
						}

                }
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
    
     operation q_ram_call_real ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : ()
    {
        body
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            
                for(i in 0..(N_RAM-1) )
                {
                        let (address, next_address, weight) = RAM[i];
                        
                        for( j in 0..(n_a-1) )
						{
							let bit = 2^j;
							if ( ( address&&&bit) == 0 )
							{
                                X (qs_address[j]);
							}
						}

						(Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );

                        for( j in 0..(n_a-1) )
						{
							let bit = 2^j;
							if ( ( address&&&bit) == 0 )
							{
                                X (qs_address[j]);
							}
						}

                }
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
    
}
