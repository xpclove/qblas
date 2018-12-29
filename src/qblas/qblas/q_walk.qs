namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Math;
	open Microsoft.Quantum.Extensions.Diagnostics;

    operation q_walk_op_W (qs_a: Qubit[], qs_b: Qubit[]) : Unit
    {
        body(...)
        {
			let nbit=Length(qs_a);
			for ( i in 0..(nbit-1) )
			{
				CNOT(qs_a[i],qs_b[i]);
				H(qs_a[i]);
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }
	operation q_walk_op_A (qs_a: Qubit[], qs_b: Qubit[], qs_tmp:Qubit) : Unit
    {
        body(...)
        {
			let nbit=Length(qs_a);
			
			q_walk_op_W(qs_a,qs_b);

			for ( i in 0..(nbit-1) )
			{
				CCNOT ( qs_a[i],qs_b[i],qs_tmp);
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

	// T = SWAP
	operation q_walk_simulation_C_T (qs_a: Qubit[], qs_b: Qubit[], qs_r: Qubit[], t:Double): Unit
	{	
		body(...)
        {
			let nbit=Length(qs_a);
			let angle = 2.0*t; //旋转角度
			using(qs_tmp=Qubit[1])
			{
				let qs_bit=qs_tmp[0];

				q_walk_op_A (qs_a, qs_b, qs_bit); // A

				(Controlled Rz) ( qs_r, (angle, qs_bit) ); //Rz
				
				(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_bit); // A+
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

	operation q_walk_simulation_C_SWAP( qs_controls:Qubit[], qs_a:Qubit[], qs_b:Qubit[], t:Double ): Unit
	{
		body(...)
		{
			q_walk_simulation_C_T(qs_a,qs_b,qs_controls,t);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	
	// M 
	operation q_walk_op_V ( matrix_A: q_matrix_1_sparse_oracle, qs_a: Qubit[], qs_b: Qubit[], qs_r:Qubit ): Unit
	{
		body(...)
		{
			// matrix_A(qs_a, qs_b, qs_r);
		}
		adjoint auto;
		controlled auto;		
		controlled adjoint auto;
	}
	operation q_walk_op_M ( matrix_A: q_matrix_1_sparse_oracle, qs_a: Qubit[], qs_b: Qubit[], qs_weight: Qubit[] ): Unit
	{
		body(...)
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
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b = qs_tmp[0..nbit-1];
				let qs_weight = qs_tmp[nbit..nbit+1-1];
				let qs_r = qs_tmp[0]; //control line 
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R) (PauliZ, qs_a, qs_b, qs_weight, t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
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
			using(qs_tmp=Qubit[nbit+4])
			{
				let qs_b=qs_tmp[0..nbit];
				let qs_weight=qs_tmp[nbit..nbit+4-1];
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliZ, qs_a, qs_b, qs_weight, 0, t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_real  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			let nbit_float = q_com_real_nbit_float();
			using(qs_tmp=Qubit[nbit+8] )
			{
				let qs_b=qs_tmp[0..nbit-1];
				let qs_weight=qs_tmp[nbit..nbit+8-1];
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliZ, qs_a, qs_b, qs_weight, nbit_float, t); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);					
			}
		}
	}
	operation q_walk_simulation_T_R(Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_weight:Qubit[], t:Double) : Unit
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
	operation q_walk_simulation_T_R_sF (Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_weight:Qubit[], n_bits_float:Int, t:Double): Unit
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
		controlled adjoint auto;
	}
	operation q_walk_simulation_matrix_1_sparse_imagebool  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state); 
			using(qs_tmp=Qubit[nbit+1])
			{
				let qs_b=qs_tmp[0..nbit-1];
				let qs_weight=qs_tmp[nbit..nbit+1-1];
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R) (PauliY, qs_a,qs_b, qs_weight, -t); //时间翻转问题需要解决
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imageinteger  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			using(qs_tmp=Qubit[nbit+4])
			{
				let qs_b=qs_tmp[0..nbit-1];
				let qs_weight=qs_tmp[nbit..nbit+4-1];
				let qs_a=qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliY, qs_a, qs_b, qs_weight, 0, -t);
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_imagereal  ( matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit=Length(qs_state);
			let nbit_float = q_com_real_nbit_float();
			using( qs_tmp=Qubit[nbit+8] )
			{
				let qs_b=qs_tmp[0..nbit-1];
				let qs_weight=qs_tmp[nbit..nbit+8-1];
				let qs_a = qs_state;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (PauliY, qs_a, qs_b, qs_weight, nbit_float, -t); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_matrix_1_sparse_complex  ( matrix_A_real: q_matrix_1_sparse_oracle,
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
	operation q_walk_matrix_type(type: Int):(Pauli, Int, Int, Double) // (Pauli, nbit_flaot, nbit_weight)
	{
		let p= [PauliZ, PauliY];
		let nbit_float = q_com_real_nbit_float();
		// type: 0 bool , 1 integer, 2 real, 3 imagebool, 4 imageinteger, 5 imagereal
		let types = [ (p[0], 0, 1, 1.0), (p[0], 0, 4, 1.0), (p[0], nbit_float, 8, 1.0), (p[1], 0, 1, -1.0), (p[1], 0, 4, -1.0), (p[1], nbit_float, 8, -1.0)];
		return(types[type]);
	}
	operation q_walk_simulation_matrix_1_sparse_core  (matrix_type:Int, matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit = Length( qs_state );
			let ( Rp, nbit_float, nbit_weight, t_sign) = q_walk_matrix_type( matrix_type );
			using( qs_tmp = Qubit[nbit+nbit_weight] )
			{
				let qs_b = qs_tmp[0..nbit-1];
				let qs_weight = qs_tmp[nbit..nbit+nbit_weight-1];
				let qs_a = qs_state;
				let time = t_sign * t;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_T_R_sF) (Rp, qs_a,qs_b, qs_weight, nbit_float, time); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
	operation q_walk_simulation_C_matrix_1_sparse_core  (qs_controls: Qubit[], matrix_type:Int, matrix_A: q_matrix_1_sparse_oracle, qs_state: Qubit[], t: Double ): Unit
	{
		body(...)
		{
			let nbit = Length( qs_state );
			let ( Rp, nbit_float, nbit_weight, t_sign) = q_walk_matrix_type( matrix_type );
			using( qs_tmp = Qubit[nbit+nbit_weight] )
			{
				let qs_b = qs_tmp[0..nbit-1];
				let qs_weight = qs_tmp[nbit..nbit+nbit_weight-1];
				let qs_a = qs_state;
				let time = t_sign * t;
				(q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);
				(q_walk_simulation_C_T_R_sF) (qs_controls, Rp, qs_a, qs_b, qs_weight, nbit_float, time); // 目前两位浮点
				(Adjoint q_walk_op_M) (matrix_A,qs_a,qs_b,qs_weight);				
			}
		}
	}
    operation q_walk_simulation_matrix_1_sparse_type (matrix_type:Int, matrix: q_matrix_1_sparse_oracle, qs_u:Qubit[], t:Double): Unit
    {
        body(...)
        {           
            q_walk_simulation_matrix_1_sparse_core(matrix_type, matrix, qs_u, t);
		}
	}
    operation q_walk_simulation_C_matrix_1_sparse_type (qs_controls:Qubit[], matrix_type:Int, matrix: q_matrix_1_sparse_oracle, qs_u:Qubit[], t:Double): Unit
    {
        body(...)
        {           
            q_walk_simulation_C_matrix_1_sparse_core(qs_controls, matrix_type, matrix, qs_u, t);
		}
	}
	operation q_walk_simulation_C_T_R_sF(qs_controls: Qubit[], Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_weight:Qubit[], n_bits_float:Int, t:Double): Unit
	{	
		body(...)
        {
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];
			q_walk_op_A (qs_a, qs_b, qs_sign); // A
			(Controlled q_walk_simulation_sF) ( qs_controls, (qs_weight, t, n_bits_float, Rp) ); // rotation F	for Rp
			(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_sign); // A+
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
	operation q_walk_simulation_C_T_R(qs_controls: Qubit[], Rp: Pauli, qs_a: Qubit[], qs_b: Qubit[], qs_weight:Qubit[], t:Double) : Unit
	{
		body(...)
		{
			let nbit = Length(qs_weight);
			let qs_sign = qs_weight[nbit-1];
			q_walk_op_A (qs_a, qs_b, qs_sign); // A
			let angle = 2.0*t;
			(Controlled R) ( qs_controls, (Rp, angle, qs_sign) );
			(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_sign); // A+
		}
	}
	operation q_walk_simulation_T (qs_a: Qubit[], qs_b: Qubit[], t:Double): Unit
	{	
		body(...)
        {
			let nbit=Length(qs_a);
			let angle = 2.0*t; //旋转角度
			using(qs_tmp=Qubit[1])
			{
				let qs_bit=qs_tmp[0];

				q_walk_op_A (qs_a, qs_b, qs_bit); // A

				(Rz) ( (angle, qs_bit) ); //Rz
				
				(Adjoint q_walk_op_A ) (qs_a, qs_b, qs_bit); // A+
			}
            
        }
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

	operation q_walk_simulation_SWAP(qs_a:Qubit[], qs_b:Qubit[], t:Double ): Unit
	{
		body(...)
		{
			q_walk_simulation_T(qs_a,qs_b,t);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}
}
