namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	
	//LitteEndian Qubits
    operation q_fft_core (qs:Qubit[]) : Unit
    {
        body(...)
        {
			let nbit=Length(qs);
			for(i in (nbit-1)..-1..0 )
			{
				H(qs[i]);
				for(j in (i-1)..-1..0 )
				{	
					let n = i-j+1;
					let k = 2;
					//q_print([i,j,n,k]);
					(Controlled R1Frac)  ( [qs[j]], (k, n, qs[i]) );
				}
			}
			//swap all qubits for the right order for ouput
            //SwapReverseRegister(qs);

			q_com_swap_all(qs);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
	operation q_fft(qs:Qubit[]) : Unit
	{
		body(...)
		{
			q_fft_core(qs);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;	
	}
}
