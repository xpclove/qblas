namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	//Reference
		//PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
		
	//qs_phase: LitteEndian Qubits, qs_r rotation to 1/lamda |0> +(1-1/lamda) |1>
	operation q_svd_rotation_lamda( qs_phase:Qubit[], qs_r:Qubit ):()
	{
		body
		{
			let nbit =Length ( qs_phase );
			let dt =0.1;
			let N=2^nbit-1;
			for(i in 0..N)
			{
				(Controlled Ry) ( qs_phase, (dt,  qs_r) );
			}
		}
		adjoint auto
		controlled auto
		controlled adjoint auto
	}

    operation q_svd_core (U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit) : ()
    {
        body
        {
			q_phase_estimate_core (U_A,qs_u, qs_phase);
			q_hhl_rotation_lamda(qs_phase, qs_r);
			(Adjoint q_phase_estimate_core) (U_A,qs_u, qs_phase);
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }

	operation q_svd( U_A:DiscreteOracle, qs_u:Qubit[], qs_r:Qubit ):()
	{
		body
		{
			using( qs_phase=Qubit[4] )
			{
				q_hhl_core(U_A,qs_u,qs_phase, qs_r);
				ResetAll(qs_phase);
			}
		}
	}

}
