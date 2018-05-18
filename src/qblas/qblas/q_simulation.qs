namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation q_simulation_swap (qs: Qubit[], time: Double) : ()
    {
        body
        {
            let nbit = Length(qs)/2;
            H(qs[0]);

        }
    }

    operation q_simulation_swapA (qs_rho: Qubit[], qs_u: Qubit[]) : ()
    {
        body
        {   


        }
    }

    operation q_simulation_A( qs_u: Qubit[], time: Double ) : ()
    {
        body
        {
            let nbit = Length(qs_u);
            using(qs_rho=Qubit[nbit])
            {
                ResetAll(qs_rho);
                ApplyToEachCA( H, qs_rho);
                q_simulation_swapA(qs_rho,qs_u);
                
            }

        }
    }

 }
