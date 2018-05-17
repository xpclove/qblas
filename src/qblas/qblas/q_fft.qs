namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation q_fft_core (qs:Qubit[]) : ()
    {
        body
        {
			let nbit=Length(qs);
			for(i in (nbit-1)..0)
			{
				H(qs[i]);
				for(j in i-1..0)
				{	
					let k = i-j+1;
					(Controlled R1Frac)  ( [qs[j]], (2,k,qs[i]) );
				}
			}
			//swap all qubits for the right order of ouput
			for(i in 0..(nbit-1)/2)
			{
				if(i!=nbit-1-i)
				{
					SWAP(qs[i],qs[nbit-1-i]);
				}
			}
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
	operation q_fft(qs:Qubit[]):()
	{
		body
		{
			q_fft_core(qs);
		}
		adjoint auto
		controlled auto
		controlled adjoint auto	
	}
}
