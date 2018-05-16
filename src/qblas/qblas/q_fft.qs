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
					//Cgate (R k) [qs.[j];qs.[i]];
				}
			}
			for(i in 0..(nbit-1)/2)
			{
				if(i==nbit-1-i)
				{
				}
				else{
					SWAP(qs[i],qs[nbit-1-i]);
				}
			}
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
}
