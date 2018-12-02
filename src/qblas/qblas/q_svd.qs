namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	//Ref: PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
		
	//qs_phase: LitteEndian Qubits, qs_r rotation to 1/lamda |0> +(1-1/lamda) |1>
	operation q_svd_rotation_lamda_rcp( qs_phase:Qubit[], qs_r:Qubit ):Unit
	{
		body(...)
		{
			q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

    operation q_svd_core (U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit) : Unit
    {
        body(...)
        {
			q_phase_estimate_core (U_A,qs_u, qs_phase);
			q_svd_rotation_lamda_rcp(qs_phase, qs_r);
			(Adjoint q_phase_estimate_core) (U_A,qs_u, qs_phase);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

	operation q_svd( U_A:DiscreteOracle, qs_u:Qubit[], qs_r:Qubit, nbit_phase:Int):Unit
	{
		body(...)
		{
			using( qs_phase=Qubit[nbit_phase] )
			{
				q_svd_core(U_A,qs_u,qs_phase, qs_r);
				ResetAll(qs_phase);
			}
		}
	}

}
