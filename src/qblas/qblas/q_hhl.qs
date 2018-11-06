namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	
	//qs_phase: LitteEndian Qubits
	operation q_hhl_rotation_lamda(qs_phase:Qubit[]):()
	{
		body
		{
			let nbit =Length ( qs_phase);
			using (qs_tmp=Qubit[2]) 
			{
				// ...
				let qs_r=qs_tmp[0];
				X(qs_r);
				for(i in 0..nbit-1)
				{
				}
				
			}
		}
		adjoint auto
		controlled auto
		controlled adjoint auto
	}
    operation q_hhl_core (U_A : DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[]) : ()
    {
        body
        {
			q_phase_estimate_core (U_A,qs_u, qs_phase);
			q_hhl_rotation_lamda(qs_phase);
			(Adjoint q_phase_estimate_core) (U_A,qs_u, qs_phase);
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
	operation q_hhl(qs_SA_real:q_matrix_1_sparse_oracle, qs_SA_image:q_matrix_1_sparse_oracle,
     qs_u: Qubit[], err:Double):()
	{
		body
		{
			// q_fft_core(qs_SA_real:q_matrix_1_sparse_oracle, qs_SA_image:q_matrix_1_sparse_oracle, qs_u);
		}
		adjoint auto
		controlled auto
		controlled adjoint auto	
	}
}
