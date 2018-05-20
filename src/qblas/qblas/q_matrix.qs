namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;

    //1 sparse matrix oracle, input Qubit[]: address, Qubit[]: data, |a>|c>
    newtype q_matrix_1_sparse_oracle = ( (Qubit[], Qubit[]) => (): Adjoint,Controlled ) ;

    operation q_matrix () : ()
    {
        body
        {
            
        }
    }
    
}
