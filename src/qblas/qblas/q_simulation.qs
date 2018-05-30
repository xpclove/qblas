namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;

    operation q_simulation_C_Swap (qs_control:Qubit, qs_a: Qubit[], qs_b:Qubit[], time: Double) : ()
    {
        body
        {
            q_walk_simulation_CSWAP(qs_control,qs_a,qs_b, time);
        }
    }

    operation q_simulation_C_densitymatrix (qs_control:Qubit, qs_rho:Qubit[], qs_sigma:Qubit[], t:Double, err:Double): ()
    {
        body
        {
            let N_D = t*t / err;
            let dt = t/N_D;
            let N = Ceiling(N_D);
            for ( i in 1..1..N )
            {
                q_walk_simulation_CSWAP (qs_control, qs_rho, qs_sigma, dt) ;
            }
        }
    }
    operation q_simulation_C_SwapA (qs_A: Qubit[], qs_rho:Qubit[], qs_u: Qubit[], dt:Double) : ()
    {
        body
        {   


        }
    }

    operation q_simulation_A( qs_A:Qubit[], qs_u: Qubit[], time: Double, t:Double,err:Double) : ()
    {
        body
        {
            let nbit = Length(qs_u);
            using(qs_rho=Qubit[nbit])
            {
                let N_D = (t*t) / err;
                let dt = t/N_D;
                let N = Ceiling(N_D);
                for( i in 1..1..N)
                {
                    ResetAll(qs_rho);
                    ApplyToEachCA ( H, qs_rho);
                    q_simulation_C_SwapA(qs_A, qs_rho,qs_u, dt);
                }
            }

        }
    }

 }
