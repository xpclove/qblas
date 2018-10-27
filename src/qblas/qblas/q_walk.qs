namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation q_walk_op_W (qs_a: Qubit[], qs_b: Qubit[]) : ()
    {
        body
        {
			let nbit=Length(qs_a);
			for ( i in 0..(nbit-1) )
			{
				CNOT(qs_a[0],qs_b[0]);
				H(qs_a[0]);
			}
            
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
    }
	// T = CSWAP
	operation q_walk_simulation_T (qs_a: Qubit[], qs_b: Qubit[], qs_r: Qubit, t:Double): ()
	{	
		body
        {
			let nbit=Length(qs_a);
			using(qs_tmp=Qubit[1])
			{
				let qs_bit=qs_tmp[0];
				q_walk_op_W(qs_a,qs_b);
				for ( i in 0..(nbit-1) )
				{
					CCNOT ( qs_a[0],qs_b[0],qs_bit );
				}
				(Controlled Rz)( [qs_r], (2*t, qs_bit) );
				(Adjoint q_walk_op_W ) (qs_a, qs_b);
			}
            
        }
		adjoint auto
		controlled auto
		controlled adjoint auto
	}

	operation q_walk_simulation_CSWAP(qs_control:Qubit, qs_a:Qubit[], qs_b:Qubit[], t:Double): ()
	{
		body
		{
			q_walk_simulation_T(qs_a,qs_b,qs_control,t);
			
		}
		adjoint auto
		controlled auto
		controlled adjoint auto
	}
	
	operation q_walk_op_V ( matrix_A: q_matrix_1_sparse_oracle, qs_a: Qubit[], qs_b: Qubit[], qs_r: Qubit ): ()
	{
		body
		{
			matrix_A(qs_a,qs_b, qs_r);
		}
		adjoint auto
		controlled auto		
		controlled adjoint auto		
	}


	operation q_walk_simulation_matrix_1_sparse_bool  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_integer  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_real  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imagebool  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imageinterger  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imagereal  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): ()
	{
		body
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..(nbit-1)];
				let qs_r=qs_tmp[nbit];
				let qs_a=qs_state;
				(q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);
				(q_walk_simulation_T) (qs_a,qs_b,qs_r,t);
				(Adjoint q_walk_op_V) (matrix_A,qs_a,qs_b,qs_r);				
			}
		}
	}
	
}
