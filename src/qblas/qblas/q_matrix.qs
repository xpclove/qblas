namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;
    
    open Microsoft.Quantum.Extensions.Math;

    //1 sparse matrix oracle, input Qubit[]: address, Qubit[]: data, |a>|c>
    // 1-稀疏矩阵如何存储： 只保存非0矩阵元，|x>|y>|element>形式
    newtype q_matrix_1_sparse_oracle = ( (Qubit[], Qubit[], Qubit[]) => (): Adjoint,Controlled ) ;

    operation q_matrix_1_sparse_bool_test( qs_address:Qubit[], qs_data:Qubit[], qs_r:Qubit ) : ()
    {
        body
        {
            let RAM = [1;0;2];
            q_ram_call_bool(RAM, qs_address, qs_data, qs_r);
        }
        adjoint auto
		controlled auto
		controlled adjoint auto
    }
    operation q_matrix_1_sparse_integer_test( qs_address:Qubit[], qs_data:Qubit[], qs_r:Qubit ) : ()
    {
        body
        {
            let RAM = [1;0;2];
            q_ram_call_bool(RAM, qs_address, qs_data, qs_r);
        }
        adjoint auto
		controlled auto
		controlled adjoint auto
    }

    operation q_matrix () : ()
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
