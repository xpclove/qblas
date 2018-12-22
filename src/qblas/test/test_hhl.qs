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
	// |rho> = |+>, |sigma> = |0>, 演化时间 Pi/6
	operation test_DM_simulation(p:Int):Double
	{
		body(...)
		{
			mutable res = 0.0;
			using(qs = Qubit[20])
			{
				let qs_control= qs[0];
				let qs_sigma = [qs[1]];
				mutable qs_rhos= new (Qubit[])[18];
				for( i in 0..17)
				{
					set qs_rhos[i]=[qs[2+i]];
				}
				X(qs_control);
				q_simulation_C_densitymatrix(qs_control, qs_rhos, qs_sigma, 1.0, 18);
				DumpRegister("dm.txt", qs_sigma);
				ResetAll(qs);
			}
			return(res);
		}
	}

}
