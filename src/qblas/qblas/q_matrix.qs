namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;
    
    open Microsoft.Quantum.Extensions.Math;


    //1 sparse matrix oracle, input Qubit[]: address, Qubit[]: data, |a>|c>
    // 1-稀疏矩阵如何存储： 只保存非0矩阵元，|x>|y>|element>形式
    // |vertex>|0>|0>   ->  |vertex>|netxt-vertex>|weight>
    newtype q_matrix_1_sparse_oracle = ( (Qubit[], Qubit[], Qubit[])=>(): Adjoint, Controlled );
    // newtype QBLAS_M_Weight = (Int. Int);



    function q_matrix_convert(ram:(Int, Int, Int)[]) : QBLAS_M_Weight[]
    {
        let n = Length(ram);
        mutable  RAM = new QBLAS_M_Weight[n];
        for(i in 0..n-1)
        {
            let (v,next_v,w) = ram[i];
            set RAM[i] = QBLAS_M_Weight(v,next_v,w);
        }
        return RAM;
    }

    operation q_matrix_1_sparse_bool_test ( qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body
        {
            let RAM = q_matrix_convert( [(0,1,1),(1,0,1)] );
            q_ram_call_bool(RAM, qs_address, qs_data, qs_weight);
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    operation q_matrix_1_sparse_integer_test( qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit 
    {
        body
        {
            let RAM = q_matrix_convert( [(0,1,2),(1,0,2)] );           
            q_ram_call_integer(RAM, qs_address, qs_data, qs_weight);
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
    operation q_matrix_1_sparse_real_test( qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body
        {
            let ram = [(0,1,1),(1,0,1)];
            let RAM = q_matrix_convert(ram);            
            q_ram_call_real(RAM, qs_address, qs_data, qs_weight);
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    operation q_matrix_SwapA_test( qs_address:Qubit[], qs_data:Qubit[], qs_weight:Qubit[] ) : Unit
    {
        body
        {
            let RAM = [ [1,1], [1,1] ];
            q_ram_call_SwapA(RAM, qs_address, qs_data, qs_weight);
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    operation q_matrix () : Unit
    {
        body
        {
            
        }
    }

    // _C 表示受控版本
    operation q_matrix_simulation_densitymatrix_C(qs_control:Qubit, qs_rho:Qubit[], qs_sigma:Qubit[], t:Double, err:Double): ()
    {
        body
        {
            let N_D = Sqrt(t) / err;
            let dt = t/N_D;
            let N = Ceiling(N_D);
            for ( i in 1..1..N )
            {
                q_walk_simulation_CSWAP (qs_control, qs_rho, qs_sigma, dt) ;
            }
        }
    }
    
}
