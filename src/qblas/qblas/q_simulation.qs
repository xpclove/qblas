namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Convert;

    //CSWAP 模拟
    operation q_simulation_C_Swap (qs_control:Qubit, qs_a: Qubit[], qs_b:Qubit[], time: Double) : Unit
    {
        body(...)
        {
            q_walk_simulation_CSWAP(qs_control,qs_a,qs_b, time);
        }
    }
    //
    operation q_simulation_C_densitymatrix (qs_control:Qubit, qs_rho:Qubit[][], qs_sigma:Qubit[], t:Double, N:Int): Unit
    {
        body(...)
        {
            // let N_D = t*t / err;
            // let dt = t/N_D;
            // let N = Ceiling(N_D);
            let dt =t/ToDouble(N);
            for ( i in 0..1..N-1 )
            {
                //每模拟一步消耗一个 |rho>
                q_walk_simulation_CSWAP (qs_control, qs_rho[i], qs_sigma, dt) ;
            }
        }
    }


    //参考 PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
    operation q_simulation_C_SwapA (qs_control:Qubit,   
     qs_SA_real: q_matrix_1_sparse_oracle, qs_SA_image: q_matrix_1_sparse_oracle,
     qs_u: Qubit[], dt:Double) : Unit
    {
        body
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt;
            q_walk_simulation_matrix_1_sparse (qs_SA_real, qs_SA_image, qs_u, t, 1000);
        }
    }

    operation q_simulation_C_A( qs_control:Qubit, 
     qs_SA_real:q_matrix_1_sparse_oracle, qs_SA_image:q_matrix_1_sparse_oracle,
     qs_u: Qubit[], t:Double, err:Double) : Unit
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
                // qs_SA_real: A实数部分， qs_SA_image: A虚数部分
                q_simulation_C_SwapA(qs_control, qs_SA_real, qs_SA_image, qs_u, dt);
            }

        }
    }

    operation q_simulation_C_SwapA_integer (qs_control:Qubit, qs_SA_int: q_matrix_1_sparse_oracle, qs_u: Qubit[], dt:Double) : Unit
    {
        body
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt; // t=N*dt, N=矩阵A维数
            q_walk_simulation_matrix_1_sparse_integer (qs_SA_int,  qs_u, t);
        }
    }
 }
