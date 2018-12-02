namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Math; 
	
	//qs_phase: LitteEndian Qubits, qs_r rotation to 1/lamda |0> +(1-1/lamda) |1>
	operation q_hhl_rotation_lamda_rcp( qs_phase:Qubit[], qs_r:Qubit ):Unit
	{
		body(...)
		{
			let nbit =Length ( qs_phase );
			let sign = nbit-1;
			// for(i in 0..nbit-2)
			// {
			// 	(Controlled X)([qs_phase[sign]], qs_phase[i]);
			// }
			// for(i in nbit..1)
			// {
			let lamda_div = 2.0*PI()/ToDouble( (2^nbit) -1) ;
			// 	let A_1 =  1.0 / (  ToDouble(2^i) ) ;
			// 	let dt = ArcSin(A_1) * 2.0 ;
			// 	(Controlled Ry) ( [qs_phase[i]], (dt,  qs_r) );
			// }
			q_ram_call_lamda_rcp(qs_phase, [qs_r], lamda_div);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

    operation q_hhl_core (U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit) : Unit
    {
        body(...)
        {
			q_phase_estimate_core (U_A,qs_u, qs_phase);
			q_hhl_rotation_lamda_rcp (qs_phase, qs_r);
			(Adjoint q_phase_estimate_core) (U_A,qs_u, qs_phase);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

	operation q_hhl( U_A:DiscreteOracle, qs_u:Qubit[], qs_r:Qubit, nbit_phase:Int ):Unit
	{
		body(...)
		{
			using( qs_phase=Qubit[nbit_phase] )
			{
				q_hhl_core(U_A,qs_u,qs_phase, qs_r);
				ResetAll(qs_phase);
			}
		}
	}
	operation q_hhl_OK( U_A:DiscreteOracle, qs_u:Qubit[], qs_r:Qubit, nbit_phase:Int ):Unit
	{
		body(...)
		{
			using( qs_phase=Qubit[nbit_phase] )
			{
				repeat
				{
					q_hhl_core(U_A,qs_u,qs_phase, qs_r);
					ResetAll(qs_phase);
					let result = M(qs_r);
					ResetAll(qs_phase);
				}until (result == One)
				fixup
				{

				}
			}
		}
	}

}
