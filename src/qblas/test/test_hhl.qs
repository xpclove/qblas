namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open qblas;

	operation U_test ( n: Int, u:Qubit[] ) : ()
	{
		body
		{
			let dt =0.1;
			let t = dt * ToDouble(n);
			Rz (t, u[0]);
		}
		adjointed auto
		controlled auto
	}

	operation test_hhl ( s:Int ):(Int)
	{
		body
		{
			using(qs = Qubit[2])
			{

				let  n = 1;
				//q_hhl(U_test, [qs[0]], qs[1]);
			}
			return (0);
		}
	}
}
