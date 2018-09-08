namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation bell_state_creat( qs:Qubit[]) : ()
	{
		body
		{
			H(qs[0]);
			CNOT(qs[0],qs[1]);
		}
		adjoint auto
		controlled auto
		controlled adjoint auto
	}

    operation q_tele_qubit_1 (qs_snd:Qubit, qs_rec:Qubit) : ()
    {
        body
        {
            
        }
    }
	operation q_tele_dense_coding():()
	{
		body
		{
		
		}
	}
}
