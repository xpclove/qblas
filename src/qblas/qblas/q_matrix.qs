namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;
    
    open Microsoft.Quantum.Extensions.Math;
    //1 sparse matrix oracle, input Qubit[]: address, Qubit[]: data, |a>|c>
    newtype q_matrix_1_sparse_oracle = ( (Qubit[], Qubit[]) => (): Adjoint,Controlled ) ;

    operation q_matrix () : ()
    {
        body
        {
            
        }
    }

    operation q_matrix_simulation_densitymatrix_C(qs_control:Qubit, rho:Qubit[], sigma:Qubit[], t:Double, err:Double): ()
    {
        body
        {
            let N_D = Sqrt(t) / err;
            let dt = t/N_D;
            let N = Ceiling(N_D);
            for ( i in 1..1..N )
            {
                q_walk_simulation_CSWAP (qs_control, rho, sigma, dt) ;
            }
        }
    }
    
}
