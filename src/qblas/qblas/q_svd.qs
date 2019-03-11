namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	//Ref: PhysRevA.97.012327_Quantum singular-value decomposition of nonsparse low-rank matrices
		
	//qs_phase: LitteEndian Qubits, qs_r rotation to 1/lamda |0> +(1-1/lamda) |1>
	operation q_md_rotation_lamda_rcp( qs_phase:Qubit[], qs_r:Qubit ):Unit
	{
		body(...)
		{
			q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	//矩阵分解核心程序，采用QPE方法
    operation q_md_core (U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit) : Unit
    {
        body(...)
        {
			q_phase_estimate_core (U_A,qs_u, qs_phase);
			q_md_rotation_lamda_rcp(qs_phase, qs_r);
			(Adjoint q_phase_estimate_core) (U_A,qs_u, qs_phase);
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

	//奇异值分解: 核心思想，用量子态所对应的密度矩阵模拟演化量子态自己导出本征值 对应奇异值
	operation q_svd( U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit):Unit
	{
		body(...)
		{
				q_md_core(U_A,qs_u,qs_phase, qs_r);
		}
	}
	//本征值分解: 采用QPE导出矩阵本征值， |qs_u> 本征态， |qs_phase> 本征值 
	operation q_evd( U_A:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[], qs_r:Qubit):Unit
	{
		body(...)
		{
				q_md_core(U_A,qs_u,qs_phase, qs_r);
		}
	}
}
