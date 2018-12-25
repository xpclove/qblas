namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Math;
	open Microsoft.Quantum.Extensions.Diagnostics;

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
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
	operation q_walk_op_A (qs_a: Qubit[], qs_b: Qubit[], qs_tmp:Qubit) : ()
    {
        body
        {
			let nbit=Length(qs_a);
			
			q_walk_op_W(qs_a,qs_b);

			for ( i in 0..(nbit-1) )
			{
				CCNOT ( qs_a[0],qs_b[0],qs_tmp);
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

	// T = CSWAP
	operation q_walk_simulation_T (qs_a: Qubit[], qs_b: Qubit[], qs_r: Qubit, t:Double): ()
	{	
		body
        {
			let nbit=Length(qs_a);
			let angle = 2.0*t; //旋转角度
			using(qs_tmp=Qubit[1])
			{
				let qs_bit=qs_tmp[0];

				q_walk_op_A (qs_a, qs_b, qs_bit); // A

				(Controlled Rz) ( [qs_r], (angle, qs_bit) ); //Rz
				
				(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_bit); // A+
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

	operation q_walk_simulation_CSWAP( qs_control:Qubit, qs_a:Qubit[], qs_b:Qubit[], t:Double ): ()
	{
		body
		{
			q_walk_simulation_T(qs_a,qs_b,qs_control,t);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
	// M 
	operation q_walk_op_V ( matrix_A: q_matrix_1_sparse_oracle, qs_a: Qubit[], qs_b: Qubit[], qs_r:Qubit ): ()
	{
		body
		{
			// matrix_A(qs_a, qs_b, qs_r);
		}
		adjoint auto;
		controlled auto;		
		controlled adjoint auto;
	}
	operation q_walk_op_M ( matrix_A: q_matrix_1_sparse_oracle, qs_a: Qubit[], qs_b: Qubit[], qs_weight: Qubit[] ): ()
	{
		body
		{
			matrix_A! (qs_a, qs_b, qs_weight);
		}
		adjoint auto;
		controlled auto;		
		controlled adjoint auto;		
	}

	operation q_walk_simulation_matrix_1_sparse_bool  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+1+1])
			{
				let qs_b = qs_tmp[1..nbit];
				let qs_weight = qs_tmp[nbit+1..nbit+1];
				let qs_r = qs_tmp[0]; //control line 
				let qs_a = qs_state;
				X(qs_r); 
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R) (PauliZ, qs_a, qs_b, qs_r, qs_weight, t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				X(qs_r);			
			}
		}
	}

	// weight:litte-end 正数； n_bits_float:小数部分位数，小数在前
	operation q_walk_simulation_F_p( qs_weight:Qubit[], t:Double, n_bits_float:Int) : Unit
	{
		body(...)
		{
			let nbit = Length(qs_weight);
			for(i in 0..nbit-1)
			{
				let fi = ToDouble(i);
				let ff = ToDouble(n_bits_float);
				let g = PowD(2.0, fi-ff);
				let angle = ( t * g );
				Rz (angle, qs_weight[i]);
			}
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation q_walk_simulation_F_n( qs_weight:Qubit[], t:Double, n_bits_float:Int) : Unit
	{
		body(...)
		{
			let nbit = Length(qs_weight);
			for(i in 0..nbit-1)
			{
				let fi = ToDouble(i);
				let ff = ToDouble(n_bits_float);
				let g = PowD(2.0, fi-ff);
				let angle =0.0 - ( t * g );  //负数
				Rz (angle, qs_weight[i]);
			}
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation q_walk_simulation_T_sF (qs_a: Qubit[], qs_b: Qubit[], qs_control: Qubit, qs_weight:Qubit[], n_bits_float:Int, t:Double): Unit
	{
		body(...)
        {
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];
			q_walk_op_A (qs_a, qs_b, qs_sign); // A
			(q_walk_simulation_sF) (qs_weight, t, n_bits_float, PauliZ); // rotation F	
			(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_sign); // A+
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation q_walk_simulation_sF( qs_weight:Qubit[], t:Double, n_bits_float:Int, Rp:Pauli) :Unit
	{
		body(...)
		{
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];// sign=1 t为负数，exp( -i t), 因此旋转相位为正； sign=0 为正数
			for(i in 0..nbit-2)
			{
				let fi = ToDouble(i);
				let ff = ToDouble(n_bits_float);
				let g = PowD(2.0, fi-ff);
				let angle = 2.0 * ( t * g ); // exp(-i sigma t) 因此两倍t
				(Controlled R) ( [qs_weight[i]], (Rp, angle, qs_sign) );
			}
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation q_walk_simulation_matrix_1_sparse_integer  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[1+nbit+4])
			{
				let qs_b=qs_tmp[1..nbit];
				let qs_weight=qs_tmp[nbit+1..nbit+4];
				let qs_r = qs_tmp[0]; //保留 control line, 未使用
				// X(qs_r);
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliZ, qs_a,qs_b,qs_r, qs_weight, 0, t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_real  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[1+nbit+8])
			{
				let qs_b=qs_tmp[1..nbit];
				let qs_weight=qs_tmp[nbit+1..nbit+8];
				let qs_r = qs_tmp[0]; 
				// X(qs_r);
				let qs_a=qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_sF) (qs_a,qs_b,qs_r, qs_weight, 2, t); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);					
			}
		}
	}
	operation q_walk_simulation_T_R(Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_control: Qubit, qs_weight:Qubit[], t:Double) : Unit
	{
		body(...)
		{
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];
			q_walk_op_A (qs_a, qs_b, qs_sign); // A
			let angle = 2.0*t;
			(R) (Rp, angle, qs_sign);
			(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_sign); // A+

		}
	}
	operation q_walk_simulation_T_R_sF (Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_control: Qubit, qs_weight:Qubit[], n_bits_float:Int, t:Double): Unit
	{	
		body(...)
        {
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];
			q_walk_op_A (qs_a, qs_b, qs_sign); // A
			(q_walk_simulation_sF) (qs_weight, t, n_bits_float, Rp); // rotation F	for Rp
			(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_sign); // A+
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation Hy(qs: Qubit):Unit
	{
		body(...)
		{
			H (qs);
			S (qs);
		}
		adjoint auto;
		controlled auto;
	}
	operation q_walk_simulation_matrix_1_sparse_imagebool  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state); 
			using(qs_tmp=Qubit[1+nbit+1])
			{
				let qs_b=qs_tmp[1..nbit];
				let qs_weight=qs_tmp[nbit+1..nbit+1];
				let qs_r = qs_tmp[0];
				let qs_a=qs_state;
				X(qs_r);
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R) (PauliY, qs_a,qs_b,qs_r, qs_weight, -t); 
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				X(qs_r);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imageinteger  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[1+nbit+4])
			{
				let qs_b=qs_tmp[1..nbit];
				let qs_weight=qs_tmp[nbit+1..nbit+4];
				let qs_r = qs_tmp[0];
				let qs_a=qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliY, qs_a,qs_b,qs_r, qs_weight, 0, -t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imagereal  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[1+nbit+8])
			{
				let qs_b=qs_tmp[1..nbit];
				let qs_weight=qs_tmp[nbit+1..nbit+8];
				let qs_r = qs_tmp[0];
				let qs_a=qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliY, qs_a,qs_b,qs_r, qs_weight, 2, t); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse  ( matrix_A_real: q_matrix_1_sparse_oracle,
	 matrix_A_image: q_matrix_1_sparse_oracle,
	 qs_state: Qubit[], 
	 t: Double,
	 N: Int ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			let dt = t / ToDouble(N);
			for( i in 0..N-1)
			{
				q_walk_simulation_matrix_1_sparse_real(matrix_A_real, qs_state, dt);
				q_walk_simulation_matrix_1_sparse_imagereal(matrix_A_image, qs_state, dt);
			}
		}
	}
	
}
