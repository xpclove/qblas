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
			controlled auto;
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
			adjoint auto;
			controlled auto;
			controlled adjoint auto;
		}
		// ramcall 方式创建向量
		operation q_vector_prepare(ram_call:((Qubit[], Qubit[])=>Unit), qs_address:Qubit[], qs_vector:Qubit[]): Unit
		{
			body(...)
			{
				using(qs_r = Qubit())
				{
					ram_call(qs_address, qs_vector);
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
						let qs_u = qs[1..n_qubit];
						let qs_v = qs[(n_qubit+1)..2*n_qubit];
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
		//向量组 swaptest vector-1(模向量 |phi>) 准备， 目前只支持两组等数量向量
		operation q_vector_s_vnorms_prepare (qs_address:Qubit[], norms:ComplexPolar[], vectors_group :Int[]) : Unit
		{
			body(...)
			{
				let nbit_address = Length(qs_address); //地址线Qubit数目
				let n_vector = 2^nbit_address; // 向量数目
				X (qs_address[nbit_address-1]);
				H (qs_address[nbit_address-1]);
				let vectors_u = norms[0..(n_vector/2-1)];
				let vectors_v = norms[(n_vector/2)..(n_vector-1)];
				(Controlled q_vector_creat) ( [qs_address[nbit_address-1]], (vectors_u, qs_address[0..nbit_address-2]));
				(Controlled q_vector_creat) ( [qs_address[nbit_address-1]], (vectors_v, qs_address[0..nbit_address-2]));
			}
		}
		//向量组 swaptest vector-2(方向向量 |psi>) 准备， 目前只支持两组等数量向量
		operation q_vector_s_vdirections_prepare (qs_pool:(Qubit[],Qubit[]), vectors:ComplexPolar[][], vectors_group:Int[]) : Unit
		{
			body(...)
			{
				let (qs_psi_a, qs_psi_vector) = qs_pool; //弹出向量Qubit[], (地址线， 向量)
				let nbit_address = Length(qs_psi_a); //地址线Qubit数目
				let n_vector = 2^nbit_address; //向量总数目

				H (qs_psi_a[nbit_address-1]);
				let vectors_u = vectors[0..(n_vector/2-1)];
				let vectors_v = vectors[(n_vector/2)..(n_vector-1)];
				(Controlled q_vector_s_creat) ( [qs_psi_a[nbit_address-1]], (vectors_u, qs_psi_a[0..nbit_address-2],
				qs_psi_vector));
				(Controlled q_vector_s_creat) ( [qs_psi_a[nbit_address-1]], (vectors_v, qs_psi_a[0..nbit_address-2],
				qs_psi_vector));
			}
		}
		operation q_vector_s_swaptest_state_prepare(vectors_group :Int[], norms:ComplexPolar[], vectors:ComplexPolar[][],
		 qs:Qubit[] ):Unit
		{
			body(...)
			{
				let nbit_address = Ceiling( Log( ToDouble( Length(vectors_group) ) )/Log(2.0) );
				let nbit_vector = Ceiling( Log( ToDouble( Length(vectors[0]) ) )/Log(2.0) );
				let qs_u =qs[ 1..nbit_address ];
				let qs_v =qs[ (nbit_address+1)..2*nbit_address ];
				let qs_vector = qs[ (2*nbit_address+1)..(nbit_address*2+nbit_vector)];
				q_vector_s_vnorms_prepare(qs_u, norms, vectors_group);
				q_vector_s_vdirections_prepare((qs_v, qs_vector), vectors, vectors_group);
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
		operation q_vector_s_distance (swaptest_state_prepare:(Qubit[]=>Unit), nbit_address:Int, nbit_vector : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let inner=q_vector_s_inner(swaptest_state_prepare, nbit_address, nbit_vector, acc);
				let Z_s =1.0;
				let distance= Z_s*inner;
				return (distance);	
			}
		}
}
