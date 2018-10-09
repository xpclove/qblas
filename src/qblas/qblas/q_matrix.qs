namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;
    
    open Microsoft.Quantum.Extensions.Math;

    //1 sparse matrix oracle, input Qubit[]: address, Qubit[]: data, |a>|c>
    // 1-稀疏矩阵如何存储： 只保存非0矩阵元，|x>|y>|element>形式
    newtype q_matrix_1_sparse_oracle = ( (Qubit[], Qubit[]) => (): Adjoint,Controlled ) ;

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
