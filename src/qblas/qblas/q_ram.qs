namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;

    
    newtype QBLAS_M_Weight  = (Int, Int, Int) ;
    // newtype QBLAS_M_Real  = (Int,Int);

    
    //函数赋值，qs_data 处于|0>态, 制备到 |data> 基矢态
    operation q_ram_function_assignment_int ( qs_data:Qubit[], data:Int ) : Unit
    {
        body(...)
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
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    operation q_ram_function_assignment_real ( qs_data:Qubit[], data:Int) : Unit
    {
        body(...)
        {
            let n_d = Length(qs_data);
            for(i in 0..n_d-1 )
            {
                let bit = 2^i;
                let v_bit = data*1;
                if ( (data&&&bit) != 0)
                {
                    X (qs_data[i]);
                }
            }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    //寻址操作
    operation q_ram_addressing ( qs_address:Qubit[], address:Int ) : Unit
    {
        body(...)
        {
            let n_a = Length(qs_address);
            for( j in 0..(n_a-1) )
            {
                let bit = 2^j;
                if ( (address&&&bit) == 0 )
                {
                    X (qs_address[j]);
                }
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
    //模拟读取量子内存 RAM[qs_address] = qs_data
    operation q_ram_load ( RAM:Int[], qs_address:Qubit[], qs_data:Qubit[] ) : Unit
    {
        body(...)
        {
            let N_RAM = Length(RAM);
            for(i in 0..(N_RAM-1) )
            {
                    let (address, data) = (i, RAM[i]);
                    q_ram_addressing (qs_address, address);
                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , data) );
                    (Adjoint q_ram_addressing) (qs_address, address);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
    operation q_ram_loads ( RAM:(Int,Int)[], qs_address:Qubit[], qs_data:Qubit[][] ) : Unit
    {
        body(...)
        {
            let N_RAM = Length(RAM);
            for(i in 0..(N_RAM-1) )
            {
                    let (address, data) = (i, RAM[i]);
                    let (data_0, data_1) = data;
                    q_ram_addressing (qs_address, address);
                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data[0] , data_0) );
                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data[1] , data_1) );
                    (Adjoint q_ram_addressing) (qs_address, address);
            }
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
	// |qs_address>|qs_data>|qs_r>	->	 |qs_address>|RAM[qs_address]>|1>
    operation q_ram_call_bool ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body(...)
        {
            let N_RAM = Length(RAM);
            let n_d = Length(qs_data);
            let n_a = Length(qs_address);
            
                for(i in 0..(N_RAM-1) )
                {
                    let (address, next_address, weight) = RAM[i]!;

                    // do 寻址
                    (q_ram_addressing) (qs_address, address);

                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                    (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );


                    // undo 寻址
                    (Adjoint q_ram_addressing) (qs_address, address);

                }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }


     operation q_ram_call_integer ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body(...)
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            
                for(i in 0..(N_RAM-1) )
                {
                        let (address, next_address, weight) = RAM[i]!;

                        q_ram_addressing(qs_address, address);

						(Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );

                        (Adjoint q_ram_addressing) (qs_address, address);

                }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    
    operation q_ram_call_real ( RAM : QBLAS_M_Weight[], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body(...)
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            
                for(i in 0..(N_RAM-1) )
                {
                        let (address, next_address, weight) = RAM[i]!;

                        q_ram_addressing(qs_address, address);

						(Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );

                        (Adjoint q_ram_addressing) (qs_address, address); 

                }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    operation q_ram_load_real_angle ( RAM : Int[], qs_address:Qubit[], qs_data:Qubit[]) : Unit
    {
    // Real Value = Int type, ( rotantion_angle/PI *128 ) ;
        body(...)
        {
            let N_RAM = Length(RAM);
            q_ram_load(RAM, qs_address, qs_data);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    operation q_ram_load_complex_angle ( RAM : (Int,Int)[], qs_address:Qubit[], qs_v_r:Qubit[], qs_v_i:Qubit[]) : Unit
    {
    // Real and Image Value = Int type, ( rotantion_angle/PI *128 ) ;
        body(...)
        {
            let N_RAM = Length(RAM);
            q_ram_loads(RAM, qs_address, [qs_v_r, qs_v_i]);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    operation q_ram_call_SwapA ( RAM : Int[][], qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body(...)
        {
            // let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            let N = 2^(n_a/2); // RAM size
            //RAM(N*N) 填充 SWAP(N^2*N^2) 填充规则 RAM[i][j] -> SWAP[j*N+i][i*N+j]

                for(j in 0..(N-1) )
                {       
                    for( i in 0..(N-1) )
                    {
                        let address = j*N+i; // SWAP 非0元素位置
                        let next_address = i*N+j;  // SWAP 非0元素位置
                        let weight = RAM[i][j];
                        
                        q_ram_addressing(qs_address, address);

                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_data , next_address) );
                        (Controlled q_ram_function_assignment_int) ( qs_address, (qs_weight , weight) );

                        (Adjoint q_ram_addressing) (qs_address, address);

                    }
                }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    operation q_ram_call_lamda_rcp ( qs_address:Qubit[], qs_weight:Qubit[], lamda_div:Double) : Unit
    {
        body(...)
        {
            let n_a = Length(qs_address);

                for(i in 0..(2^n_a-1) )
                {
                    let (address, phase) = ( i, i );

                    // do 寻址
                    (q_ram_addressing) (qs_address, address);

                    if( address > 0)
                    {
                        //补码 负数部分
                        if ( address >= 2^(n_a-1) )
                        {
                            let lamda = ToDouble(phase-2^n_a)*lamda_div;
                            if(lamda <= -1.0) 
                            {
                                let angle = 2.0*ArcSin( 1.0/lamda );
                                (Controlled Ry) ( qs_address, (angle , qs_weight[0]) );
                            }
                        }
                        //补码 正数部分
                        else
                        {
                            let lamda = ToDouble(phase)*lamda_div;
                            if(lamda >= 1.0)
                            {  
                                let angle = 2.0*ArcSin( 1.0/lamda );
                                (Controlled Ry) ( qs_address, (angle , qs_weight[0]) );
                            }
                        }
                    }

                    // undo 寻址
                    (Adjoint q_ram_addressing) (qs_address, address);

                }
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    
}
