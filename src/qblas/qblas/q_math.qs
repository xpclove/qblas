namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

        
    //Ref: Quantum Algorithms for Scientific Computing and Approximate Optimization(2018)
    operation q_math_reciprocal_int( w:Qubit[], x:Qubit[]) : Unit
    {
        body(...)
        {
            let n = Length(w);
            let b =  Length(x);
            //prepare x_0
            CNOT (w[n-1], x[b-1]);
            for ( i in 2..1..b)
            {
                X(x[b-i+1]);
                CCNOT( w[n-1],x[b-i+1], x[b-i] );
                X(x[b-i+1]);
            }
            //Newton iteration method for x=1/w;
            for ( i in  n-1..-1..1)
            {

            }

        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
}

