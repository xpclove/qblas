namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open qblas;

	
	operation test_hhl ( s:Int ):(Int)
	{
		body(...)
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
