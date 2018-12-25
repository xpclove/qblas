namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Diagnostics;
	open Microsoft.Quantum.Extensions.Math;
	open qblas;

	operation U_test (n:Int, u:Qubit[]) : Unit
	{
		body(...)
		{
			let dt = 2.0;
			let angle = dt*ToDouble(n);
			Rz(angle, u[0]);
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
			let angle = dt*ToDouble(n);
			Rx(angle, u[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
	//测试相估计
	operation test_qpe ( s:Int ):Double
	{
		body(...)
		{
			mutable phase =0.0;
			using(qs = Qubit[11])
			{
				H(qs[0]);
				let U = DiscreteOracle ( U_test);
				let mq = LittleEndian(qs[1..10]);

				q_phase_estimate(U, [qs[0]], qs[1..10]) ;
				DumpRegister("phase.txt", qs);

				let phase_base = 2.0*PI()/ToDouble(2^10-1);
				let result_int = ToDouble(MeasureInteger(mq));
				set phase= result_int*phase_base;
				ResetAll(qs);
			}
			return (phase);
		}
	}

	//测试HHL 矩阵求逆
	operation test_hhl(s:Int):Double
	{
		body(...)
		{
			mutable res = 0.0;
			using(qs = Qubit[12])
			{
				let U = DiscreteOracle ( U_hhl );
				let qs_u =qs[0];
				let qs_phase = qs[2..11];
				let qs_r = qs[1];
				X(qs_u);
				DumpRegister("phase_0.txt", [qs_u]);
				q_hhl_core (U, [qs_u], qs_phase, qs_r) ;
				ResetAll(qs_phase);
				let r = MeasureInteger(LittleEndian([qs_r]));
				DumpRegister("phase_1.txt", [qs_u]);
				let result_u = MeasureInteger( LittleEndian( [qs_u] ) );
				set res = ToDouble(r);
				q_print([r,result_u]);
				ResetAll(qs);
			}
			return(res);
		}
	}

	//测试 密度矩阵模拟
	// |rho> = |+>, |sigma> = |0>, 演化时间 Pi
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
						set qs_rhos[i]=[qs[2+i]];
					}
					X(qs_control);
					let time = PI();
					q_simulation_C_densitymatrix(qs_control, qs_rhos, qs_sigma, time, 18);
					DumpRegister("dm.txt", qs_sigma);
					DumpRegister("dump.txt", qs);
					let r = M(qs_sigma[0]);
					if(r == One) {set res = res + 1.0/ToDouble(N);}
					ResetAll(qs);
				}
			}
			q_print_D([res]);
			return(res);
		}
	}

	operation test_swap_simulation(p:Int):Double
	{
	//测试 Swap simulation ，时间 Pi/2.0
		body(...)
		{
			using(qs = Qubit[3])
			{
				let qs_a = [qs[0]];
				let qs_b = [qs[1]];
				let qs_control = qs[2];

				X(qs[0]);
				X(qs[2]);
				let time = PI()/2.0;
				q_simulation_C_Swap(qs_control, qs_a, qs_b, time);
				DumpRegister("swap.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_1_sparse_bool(p:Int):Double
	{
	//测试 1 sparse bool matrix simulation , 2*2， 时间 Pi/4
		body(...)
		{
			using(qs = Qubit[3])
			{
				let qs_a = [qs[0]];
				let qs_b = [qs[1]];
				let qs_weight = [qs[2]];

				// H(qs[0]);
				// q_matrix_1_sparse_bool_test(qs_a, qs_b, qs_weight);

				let time = PI()/4.0;
				let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test);
				
				// q_walk_simulation_matrix_1_sparse_bool(ora,	qs_b,  time);
				q_walk_simulation_matrix_1_sparse_imagebool(ora,	qs_b,  time);
				// Rx (2.0*time, qs[1]);
				DumpRegister("bool.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_1_sparse_integer(p:Int):Double
	{
	//测试 1 sparse integer matrix simulation , 2*2, 时间 Pi/8
		body(...)
		{
			using(qs = Qubit[4])
			{
				let qs_a = [qs[0]];
				let qs_b = [qs[1]];
				let qs_weight = qs[2..3];

				// H(qs[0]);
				// q_matrix_1_sparse_integer_test(qs_a, qs_b, qs_weight);

				let time = PI()/8.0;
				let ora = q_matrix_1_sparse_oracle(q_matrix_1_sparse_integer_test);
				
				// q_walk_simulation_matrix_1_sparse_integer(ora,	qs_b,  time);
				q_walk_simulation_matrix_1_sparse_imageinteger(ora,	qs_b,  time);
				// Ry (time*4.0, qs[1] );
				DumpRegister("integer.txt", qs_b);
				ResetAll(qs);
			}
			return(1.0);
		}
	}

	operation test_SwapA(p: Int): Double
	{
	//测试 low rank SwapA matrix simulation , A(2*2), 时间 Pi
		body(...)
		{
			mutable res=0.0;
			let N =1;
			for(i in 1..N)
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
					
					let qs_u =qs[0..18];
					let qs_control = qs[19];
					X(qs_control);
					let time = PI();
					q_simulation_C_A_integer(qs_control, ora, qs_u, time, 18);
					DumpRegister("swapa.txt", qs_u);
					DumpRegister("dump.txt", qs);
					let r = M(qs_u[0]);
					if( r == One) { set res = res + 1.0/ToDouble(N); }
					ResetAll(qs);
				}
			}
			return(res);
		}
	}

}
