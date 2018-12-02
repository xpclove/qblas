namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Diagnostics;
	open Microsoft.Quantum.Extensions.Math;
	open qblas;

	operation test_vector () : Int
	{
		body(...)
		{
			let u = [ComplexPolar(1.0, 0.0), ComplexPolar(0.0, 0.0)];
			let v = [ComplexPolar(1.0/Sqrt(2.0), 0.0), ComplexPolar(1.0/Sqrt(2.0), 0.0)];
			let inr= q_vector_inner(u, v, 1, 0.01);
			q_print_D([inr]);
			return(1);
		}
	}
}
