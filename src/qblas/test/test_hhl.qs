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
			let dt = 2.0;
			let angle = dt*ToDouble(n);
			Ry(angle, u[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
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

	operation test_hhl(s:Int):Double
	{
		body(...)
		{
			mutable res = 0.0;
			using(qs = Qubit[12])
			{
				let U = DiscreteOracle ( U_hhl );
				let qs_u =qs[0];
				let qs_phase = qs[1..10];
				let qs_r = qs[11];
				DumpRegister("phase_0.txt", [qs_u]);
				q_hhl_core (U, [qs_u], qs_phase, qs_r) ;

				let r = MeasureInteger(LittleEndian([qs_r]));
				ResetAll(qs[1..11]);
				DumpRegister("phase_1.txt", [qs_u]);
				let result_int = MeasureInteger( LittleEndian( [qs_u] ) );
				set res = ToDouble(result_int);
				q_print([r,result_int]);
				ResetAll(qs);
			}
			return(res);
		}
	}
}
