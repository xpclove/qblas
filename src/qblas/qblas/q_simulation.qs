namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;

    //
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


    //参考 PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
    operation q_simulation_C_SwapA (qs_control:Qubit, qs_SA: q_matrix_1_sparse_oracle,
     qs_u: Qubit[], dt:Double) : ()
    {
        body
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt;
            q_walk_simulation_matrix_1_sparse_real (qs_SA, qs_u, t);
        }
    }

    operation q_simulation_C_A( qs_control:Qubit, qs_SA:q_matrix_1_sparse_oracle,
     qs_u: Qubit[], t:Double, err:Double) : ()
    {
        body
        {
            let nbit = Length(qs_u) / 2;
            let qs_rho = qs_u[0..nbit-1];
            let N_D = (t*t) / err;
            let dt = t/N_D;
            let N = Ceiling(N_D);
            for( i in 1..1..N)
            {
                ResetAll(qs_rho);
                ApplyToEachCA (H, qs_rho); // 制备全 1 rho
                q_simulation_C_SwapA(qs_control, qs_SA,qs_u, dt);
            }

        }
    }

 }
