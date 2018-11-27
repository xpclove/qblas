namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Diagnostics;
	open qblas;

	operation U_test (n:Int, u:Qubit[]) : Unit
	{
		body(...)
		{
			let dt = 1.0;
			let angle = dt*ToDouble(n);
			Rz(angle, u[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
	operation test_hhl ( s:Int ):(Int)
	{
		body(...)
		{
			using(qs = Qubit[6])
			{
				H(qs[0]);
				let U = DiscreteOracle ( U_test);
				q_phase_estimate (U, [qs[0]], qs[1..5]) ;
				DumpRegister("phase.txt", qs);
				ResetAll(qs);
			}
			return (0);
		}
	}
}
