namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open qblas;

	operation U_test (n:Int, u:Qubit[]) : Unit
	{
		body(...)
		{
			let dt = 0.1;
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
			using(qs = Qubit[2])
			{
				let U = DiscreteOracle ( U_test);
				q_hhl(U, [qs[0]], qs[1]);
			}
			return (0);
		}
	}
}
