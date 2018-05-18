namespace qblas
{
		open Microsoft.Quantum.Primitive;
		open Microsoft.Quantum.Canon;

		operation q_vector_creat (vector:Double[],qs:Qubit[]) : ()
		{
			body
			{
				H(qs[0]);
			}
		}
}
