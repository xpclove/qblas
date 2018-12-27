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
    operation q_simulation_matrix_1_sparse_type (matrix_type:Int, matrix: q_matrix_1_sparse_oracle, qs_u:Qubit[], t:Double): Unit
    { //type 代表 6种基本 1-sparse matrix type
        body(...)
        {           
            q_walk_simulation_matrix_1_sparse_type(matrix_type, matrix, qs_u, t);

        }
    }
    operation q_simulation_C_matrix_1_sparse_type (qs_control:Qubit, matrix_type:Int, matrix: q_matrix_1_sparse_oracle, qs_u:Qubit[], t:Double): Unit
    { //type 代表 6种基本 1-sparse matrix type
        body(...)
        {           
            q_walk_simulation_C_matrix_1_sparse_type(qs_control, matrix_type, matrix, qs_u, t);

        }
    }
    operation q_simulation_C_Trotter (qs_control:Qubit, matrixs: q_matrix_1_sparse_oracle[], matrixs_type:Int[], qs_u:Qubit[], t:Double, N:Int): Unit
    {
        body(...)
        {
            let dt =t/ToDouble(N);
            for ( i in 0..1..(Length(matrixs)-1) )
            {
                q_simulation_matrix_1_sparse_type (  matrixs_type[i], matrixs[i], qs_u, t );
            }
        }
    }

    //参考 PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
    operation q_simulation_C_SwapA_complex (qs_control:Qubit,   
     qs_SA_real: q_matrix_1_sparse_oracle, qs_SA_image: q_matrix_1_sparse_oracle,
     qs_u: Qubit[], dt:Double) : Unit
    {
        body(...)
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt;
            q_walk_simulation_matrix_1_sparse_complex (qs_SA_real, qs_SA_image, qs_u, t, 1000);
        }
    }

    operation q_simulation_C_A_complex( qs_control:Qubit, 
     qs_SA_real: q_matrix_1_sparse_oracle, qs_SA_image: q_matrix_1_sparse_oracle,
     qs_rhos: Qubit[][],
     qs_u: Qubit[], t:Double, N:Int) : Unit
    {
        body(...)
        {
            let dt =  t/ToDouble(N);
            for( i in 0..1..N-1)
            {
                ResetAll(qs_rhos[i]);
                q_com_apply (H, qs_rhos[i]); // 制备全 1 rho
                // qs_SA_real: A实数部分， qs_SA_image: A虚数部分
                q_simulation_C_SwapA_complex(qs_control, qs_SA_real, qs_SA_image, qs_u, dt);
            }

        }
    }

    operation q_simulation_C_SwapA_type (qs_control:Qubit, type:Int, qs_SA: q_matrix_1_sparse_oracle, qs_u: Qubit[], dt:Double) : Unit
    {
        body(...)
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt; // t=N*dt, N=矩阵A维数
            q_simulation_C_matrix_1_sparse_type (qs_control, type, qs_SA,  qs_u, t);
        }
    }
    operation q_simulation_C_A_type ( qs_control:Qubit, type: Int, qs_SA:q_matrix_1_sparse_oracle, qs_rhos: Qubit[][], qs_u: Qubit[], t:Double, N:Int) : Unit
    {
        body(...)
        {
            let dt =  t/ToDouble(N);
            for( i in 0..1..N-1 )
            {
                q_print([i]);
                ResetAll(qs_rhos[i]);
                q_com_apply( H, qs_rhos[i]); // 制备  |rho> =|+>
                let qs_ru = q_com_array_join( qs_rhos[i], qs_u ) ;
                q_simulation_C_SwapA_type(qs_control, type,  qs_SA, qs_ru, dt);
            }
        }
    }
    operation q_simulation_SwapA_type (type:Int, qs_SA: q_matrix_1_sparse_oracle, qs_u: Qubit[], dt:Double) : Unit
    {
        body(...)
        {
            let nbit = Length(qs_u) /2 ;
            let t = ToDouble(2^nbit) * dt; // t=N*dt, N=矩阵A维数
            q_simulation_matrix_1_sparse_type (type, qs_SA,  qs_u, t);
        }
    }
    operation q_simulation_A_type (type: Int, qs_SA:q_matrix_1_sparse_oracle, qs_rhos: Qubit[][], qs_u: Qubit[], t:Double, N:Int) : Unit
    {
        body(...)
        {
            let dt =  t/ToDouble(N);
            for( i in 0..1..N-1 )
            {
                q_print([i]);
                ResetAll(qs_rhos[i]);
                q_com_apply( H, qs_rhos[i]); // 制备  |rho> =|+>
                let qs_ru = q_com_array_join( qs_rhos[i], qs_u ) ;
                q_simulation_SwapA_type(type,  qs_SA, qs_ru, dt);
            }
        }
    }
 }
