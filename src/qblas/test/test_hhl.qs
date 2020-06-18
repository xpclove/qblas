namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Oracles;
	open Microsoft.Quantum.Convert;
	open Microsoft.Quantum.Diagnostics;
	open Microsoft.Quantum.Math;
	open qblas;
	
	//Discrete Oracle：U = exp( i*sigma_z*dt)
	operation U_test (n:Int, qs_u:Qubit[]) : Unit
	{
		body(...)
		{
			let dt = -1.0;
			let angle = 2.0*dt*IntAsDouble(n);
			Rz (angle, qs_u[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation U_hhl (n:Int, u:Qubit[]) : Unit
	{
		body(...)
		{
			let dt = 3.0;
			let angle = dt*IntAsDouble(n);
			Rx(angle, u[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
	//测试相估计, Discrete Oracle:U=exp(i*sigma_z*t ), |u>=|0>, U|u> = exp(i t)|u> 采用 QPE 计算 此相位 t
	// t = 1.0
	operation test_qpe ( s:Int ):Double
	{
		body(...)
		{
			mutable phase =0.0;
			using(qs = Qubit[11]) //qs[0]待测试比特, qs[1..10]保存相位
			{
				let U 	= DiscreteOracle ( U_test );
				let mq 	= LittleEndian( qs[1..10] );

				q_phase_estimate(U, [qs[0]], qs[1..10]) ;
				DumpRegister( "phase.txt", qs );

				let phase_base 	= 	2.0*PI() / IntAsDouble( 2^10 );
				let result_int 	= 	IntAsDouble( MeasureInteger(mq) );
				set phase		= 	result_int * phase_base;
				ResetAll(qs);
			}
			q_print_D([phase]);
			return (phase);
		}
	}

	//测试 HHL 矩阵求逆 A|x>=|u>, |x>=A-1|u>, 令|u>=|1>，A=sigma_x, 求|x>
	//|x>=|0>
	operation test_hhl(s:Int):Double
	{
		body(...)
		{
			mutable res = 0.0;
			using(qs = Qubit[12])
			{
				let U 		= 	DiscreteOracle ( U_hhl );
				let qs_u 	=	qs[0];	//待求拟比特
				let qs_r 	= 	qs[1];	//辅助比特
				let qs_phase= 	qs[2..11];	//存放相位
				X(qs_u);
				DumpRegister("phase_0.txt", [qs_u]);
				q_hhl_core (U, [qs_u], qs_phase, qs_r) ;
				ResetAll(qs_phase);
				let r = MeasureInteger( LittleEndian( [qs_r] ) );
				DumpRegister( "phase_1.txt", [qs_u] );
				let result_u = MeasureInteger( LittleEndian( [qs_u] ) );
				set res = IntAsDouble(r);

				q_print( [r, result_u] ); //|r>=|1>,代表HHL成功
				ResetAll(qs);
			}
			return(res);
		}
	}

	//测试 密度矩阵模拟
	// |rho> = |+>, |sigma> = |0>, 演化时间 Pi/3.0
	// |sigma> 演化结果 |sigma_end> = sqrt(0.75)|0> + sqrt(0.25)|1>
	operation test_DM_simulation(p:Int):Double
	{
		body(...)
		{
			mutable res = 0.0;
			let N =1;
			for(s in 1..N)
			{
				using(qs = Qubit[20])
				{
					let qs_control= qs[1];
					let qs_sigma = [qs[0]];
					mutable qs_rhos= new (Qubit[])[18];
					for( i in 0..17)
					{
						H(qs[2+i]); //制备 |rho>
						// set qs_rhos[i]=[qs[2+i]];
						set qs_rhos  w/= i <- [qs[2+i]];
					}
					X(qs_control);
					let time = PI()/3.0;
					q_simulation_C_densitymatrix([qs_control], qs_rhos, qs_sigma, time, 18);
					DumpRegister("dm.txt", qs_sigma);
					DumpRegister("dump.txt", qs);
					let r = M(qs_sigma[0]);
					if(r == One) {set res = res + 1.0/IntAsDouble(N);}
					ResetAll(qs);
				}
			}
			q_print_D([res]);
			return(res);
		}
	}

	operation test_swap_simulation(p:Int):Double
	{
	//测试 Swap simulation ，时间 Pi/2.0, |a>=|11> 交换到 |b>=|00>
		body(...)
		{
			using(qs = Qubit[5])
			{
				let qs_a = qs[0..1]; // |a>
				let qs_b = qs[2..3]; // |b>
				let qs_control = qs[4];

				X(qs[0]);
				X(qs[1]); // let |a> =|11>

				X(qs_control);// let |control> =|1>
				let time = PI()/2.0;
				DumpRegister("swap0.txt", qs_b);
				q_simulation_C_swap([qs_control], qs_a, qs_b, time);
				DumpRegister("swap1.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_1_sparse_bool(p:Int):Double
	{
	//测试 1 sparse bool matrix simulation , 2*2， 时间 Pi/4 	, bool_matrix = sigma_x, image_bool_matrx = sigma_y
		body(...)
		{
			using(qs = Qubit[3])
			{
				let qs_a = [qs[0]];

				let qs_b = [qs[1]];//被模拟比特
				let qs_weight = [qs[2]];//存放矩阵权重

				let time = PI()/4.0;
				let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
				
				q_walk_simulation_matrix_1_sparse_bool(ora, qs_b, time);
				// q_walk_simulation_matrix_1_sparse_imagebool(ora, qs_b, time);
				DumpRegister("bool.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_1_sparse_integer(p:Int):Double
	{
	//测试 1 sparse integer matrix simulation , 2*2, 时间 Pi/8, integer_matrix = 2*sigma_x, image_integer_matrx = 2*sigma_y
		body(...)
		{
			using(qs = Qubit[4])
			{
				let qs_a = [qs[0]];

				let qs_b = [qs[1]];//被模拟比特
				let qs_weight = qs[2..3];

				let time = PI()/8.0;
				let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_integer_test);
				
				q_walk_simulation_matrix_1_sparse_integer(ora,	qs_b,  time);
				// q_walk_simulation_matrix_1_sparse_imageinteger(ora,	qs_b,  time);
				DumpRegister("integer.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_SwapA(p: Int): Double
	{
	//测试 low rank SwapA matrix simulation , A(2*2), 时间 Pi/6.0, 等价于DM Pi/3.0 
		body(...)
		{
			mutable res=0.0;
			let N =1;
			for(j in 1..N)
			{
				using(qs = Qubit[20])
				{
					// let qs_a = qs[4..5];
					// let qs_b = qs[2..3];
					// let qs_weight = qs[0..1];

					// // H(qs[4]);
					// // H(qs[5]);
					// // q_matrix_SwapA_test(qs_a, qs_b, qs_weight);

					let ora = q_matrix_1_sparse_oracle(q_matrix_SwapA_test);
					
					let qs_u =qs[0..0];
					mutable qs_rhos= new (Qubit[])[18];
					for( i in 0..17)
					{
						// set qs_rhos[i]=[qs[1+i]];
						set qs_rhos w/= i <- [qs[1+i]];
					}
					let qs_control = qs[19];
					X(qs_control);

					let time = PI()/6.0;
					q_simulation_C_A_type ([qs_control], 1, ora, qs_rhos, qs_u, time, 18);
					DumpRegister("swapa.txt", qs_u);
					DumpRegister("dump.txt", qs);
					let r = M(qs_u[0]);
					if( r == One) { set res = res + 1.0/IntAsDouble(N); }
					ResetAll(qs);
				}
			}
			return(res);
		}
	}

}
