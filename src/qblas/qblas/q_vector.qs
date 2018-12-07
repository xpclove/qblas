namespace qblas
{
		open Microsoft.Quantum.Primitive;
		open Microsoft.Quantum.Canon;
		open Microsoft.Quantum.Extensions.Convert;
		open Microsoft.Quantum.Extensions.Math;

		operation q_vector_creat (vector:ComplexPolar[], qs:Qubit[]) : Unit
		{
			body(...)
			{
				// us Q# Library, PrepareArbitraryState()
				PrepareArbitraryState( vector, BigEndian(qs) );
				
			}
		}
		operation q_vector_s_creat (vs:ComplexPolar[][], qs_address:Qubit[], qs_v:Qubit[]) : Unit
		{
			body(...)
			{
				let nbit = Length(qs_address);
				for(address in 0..(2^nbit-1) )
				{
					let vector = vs[address];
					q_ram_addressing(qs_address, address);
					(Controlled PrepareArbitraryState) (qs_address, ( vector, BigEndian(qs_v) ) ) ; 
					(Adjoint q_ram_addressing) (qs_address, address);
				}
				
			}
		}

		operation q_vector_inner ( u:ComplexPolar[], v : ComplexPolar[], n_qubit : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let N = Ceiling(1.0/acc);
				mutable num_ones=0;
				mutable p=0.0;
				mutable inner=0.0;
				using(qs=Qubit[n_qubit*2+1])
				{
					for(i in 1..N)
					{
						Reset(qs[0]);
						let qs_control = qs[0];

						q_vector_creat(u, qs_u);
						q_vector_creat(v, qs_v);
						q_swap_test_core( qs_control, qs_u, qs_v );
						let res = M(qs[0]);
						// 0 为通过测试, 1为未通过测试
						if(res == Zero) 
						{ 
							set num_ones= num_ones+1;
						}
						ResetAll(qs);
					}
					set p = ToDouble(num_ones)*1.0/ToDouble(N);
					if( p< 0.5)
					{
						set p =0.5;
					}
					set inner = Sqrt(2.0*p-1.0) ;
				}
				return (inner);
			}
		}

		operation q_vector_distance (u_norm:Double, u : ComplexPolar[], v_norm:Double, v : ComplexPolar[], n_qubit : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let inner=q_vector_inner(u, v, n_qubit, acc);
				let distance=Sqrt( u_norm*u_norm + v_norm*v_norm - 2.0*u_norm*v_norm*inner);
				return (distance);	
			}
		}

		operation q_vector_s_distance (norms:Double[], vectors:ComplexPolar[][], us : Int[], vs : Int[], n_qubit : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let inner=q_vector_s_inner(norms, vectors, us, vs, n_qubit, acc);
				let distance=Sqrt(2.0-2.0*inner);
				return (distance);	
			}
		}
		operation q_vector_s_address_prepare (qs_v:Qubit[], us : Int[], vs :Int[]) : Unit
		{
			body(...)
			{
				let nbit = Length(qs_v);
				X(qs_v[nbit-1]);			//最高位 0-1， 0 对应 u那一支， -1对应v那一支
				for(i in 0..(nbit-1))
				{
					H(qs_v[i]);
				}

			}
		}
		operation q_vector_s_swaptest_state_prepare(norms:Double[], vectors:ComplexPolar[][], vectors_group :Int[],
		 qs_address:Qubit[],
		 qs_vector_pool:Qubit[] ):Unit
		{
			body(...)
			{
				let qs_u =qs[ 1..n_qubit ];
				let qs_v =qs[ (n_qubit+1)..2*n_qubit ];
				let nbit_address = Ceiling( Log( ToDouble(n_vector) )/Log(2.0) );
				q_vector_s_address_prepare(qs_v, us, vs);
			}
		}
		operation q_vector_s_inner (swaptest_state_prepare:(Qubit[]=>Unit), nbit_address:Int, nbit_vector : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let N = Ceiling(1.0/acc);
				mutable num_ones=0;
				mutable p=0.0;
				mutable inner=0.0;
				using(qs=Qubit[ 1+nbit_address*2+nbit_vector ] ) 
				{
					for(i in 1..N)
					{
						Reset(qs[0]);
						let qs_control = qs[0];
						let qs_u =qs[ 1..nbit_address ];
						let qs_v =qs[ (nbit_address+1)..2*nbit_address ];
						let qs_vector = qs[ (2*nbit_address+1)..(nbit_address*2+nbit_vector)];
						swaptest_state_prepare(qs);
						q_swap_test_core( qs_control, qs_u, qs_v );
						let res = M(qs[0]);	// 0 为通过测试, 1为未通过测试
						if(res == Zero) 
						{ 
							set num_ones= num_ones+1;
						}
						ResetAll(qs);
					}
					set p = ToDouble(num_ones)*1.0/ToDouble(N);
					if( p< 0.5)
					{
						set p =0.5;
					}
					set inner = Sqrt(2.0*p-1.0) ;
					ResetAll(qs);
				}
				return (inner);
			}
		}
}
