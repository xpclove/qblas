namespace qblas
{
		open Microsoft.Quantum.Primitive;
		open Microsoft.Quantum.Canon;
		open Microsoft.Quantum.Extensions.Convert;
		open Microsoft.Quantum.Extensions.Math;
		open Microsoft.Quantum.Extensions.Diagnostics;

		//use Q# Library to creat vector, ComplexPolar[] -> |qs_v>
		operation q_vector_creat (vector:ComplexPolar[], qs_v:Qubit[]) : Unit
		{
			body(...)
			{
				// us Q# Library, PrepareArbitraryState()
				PrepareArbitraryState( vector, BigEndian(qs_v) );
				
			}
			controlled auto;
		}

		//use Q# Library to creat vectors, ComplexPolar[][] -> |qs_address>|qs_v>
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

		// ram_call 方式制备实数向量
		operation q_vector_prepare(ram_call:((Qubit[], Qubit[])=>Unit: Adjoint), qs_address:Qubit[], nbit_real:Int): Unit
		{
			body(...)
			{
				using(qs_tmp = Qubit[ nbit_real+1 ] )
				{
					let qs_vector=qs_tmp[ 0..(nbit_real-1) ];
					let qs_r = qs_tmp[ nbit_real ];
					repeat
					{
						ResetAll (qs_address);
						for(i in 0..Length(qs_address)-1 )
						{ 
							H(qs_address[i]);
						}
						ram_call (qs_address, qs_vector); //加载数据
						let n_v =Length(qs_vector);
						for(i in 0..n_v-1)
						{
							let angle_base = 2.0*PI() / (ToDouble(2^n_v)) ;
							let angle = ToDouble(2^i)*angle_base;
							(Controlled Ry) ( [qs_vector[i]], (angle, qs_r) ); //受控旋转 Ry 制备振幅
						}
						let result = M(qs_r); //通过测量制备向量
						(Adjoint ram_call) (qs_address, qs_vector); //撤销加载
						ResetAll(qs_tmp);
					} until (result == One) //直到制备完成，否则一直循环
					fixup{}
				}

			}
		}

		//ram_call 方式制备复数向量
		operation q_vector_complex_prepare(ram_call:((Qubit[], Qubit[], Qubit[])=>Unit: Adjoint), qs_address:Qubit[], nbit:Int): Unit
		{
			body(...)
			{
				using(qs_tmp = Qubit[ 2 * nbit + 1 ] ) //nbit 数据位数，精度控制
				{
					let qs_vector_real = qs_tmp[ 0..(nbit-1) ];
					let qs_vector_image = qs_tmp[ nbit..(2*nbit-1) ];
					let qs_r = qs_tmp[ 2*nbit ];
					repeat
					{
						ResetAll (qs_address);
						for(i in 0..Length(qs_address)-1 )
						{ 
							H(qs_address[i]);
						}
						ram_call (qs_address, qs_vector_real, qs_vector_image); //加载数据, real:振幅, image:相位

						let n_r =Length(qs_vector_real);
						for(i in 0..n_r-1)
						{
							let angle_base = 2.0*PI() / (ToDouble(2^n_r)) ;
							let angle = ToDouble(2^i)*angle_base;
							(Controlled Ry) ( [qs_vector_real[i]], (angle, qs_r) ); //受控旋转 Ry 制备振幅
						}

						let n_i =Length(qs_vector_image);
						for(i in 0..n_i-1)
						{
							let angle_base = 2.0*PI() / (ToDouble(2^n_i)) ;
							let angle = ToDouble(2^i)*angle_base;
							(Controlled Rz) ( [qs_vector_image[i]], (2.0*angle, qs_r) ); //受控旋转 Rz 制备相位
						}

						let result = M(qs_r); //通过测量制备向量
						(Adjoint ram_call) (qs_address, qs_vector_real, qs_vector_image); //撤销加载
						ResetAll(qs_tmp);
					} until (result == One)	//直到制备完成，否则一直循环
					fixup{}
				}

			}
		}

		// 计算两个向量内积 u,v: 待计算向量, nbit_vector: 向量所占qubit数量, acc: 计算精确度
		operation q_vector_inner ( u:ComplexPolar[], v : ComplexPolar[], nbit_vector : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let N = Ceiling(1.0/acc);
				mutable num_ones=0;
				mutable p=0.0;
				mutable inner=0.0;
				using( qs = Qubit[nbit_vector*2+1] )
				{
					for(i in 1..N)
					{
						Reset(qs[0]);
						let qs_control = qs[0];
						let qs_u = qs[ 1..nbit_vector ];
						let qs_v = qs[ (nbit_vector+1)..2*nbit_vector ];
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

		operation q_vector_distance (u_norm:Double, u : ComplexPolar[], v_norm:Double, v : ComplexPolar[], nbit_vector : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let inner	 = q_vector_inner(u, v, nbit_vector, acc);
				let distance = Sqrt( u_norm*u_norm + v_norm*v_norm - 2.0*u_norm*v_norm*inner );
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
				if ( nbit_address   == 0 ) //暂时不用
				{
					X (qs_address[nbit_address-1]);
					H (qs_address[nbit_address-1]);
					let vectors_u = norms[0..(n_vector/2-1)];
					let vectors_v = norms[(n_vector/2)..(n_vector-1)];
					(Controlled q_vector_creat) ( [qs_address[nbit_address-1]], (vectors_u, qs_address[0..nbit_address-2]));
					(Controlled q_vector_creat) ( [qs_address[nbit_address-1]], (vectors_v, qs_address[0..nbit_address-2]));
				}
				else
				{
					q_vector_creat ( norms, qs_address );
					Rz( PI(), qs_address[ nbit_address-1 ] );
				}
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
				
				if( nbit_address == 0 ) //暂时不用
				{
					H (qs_psi_a[nbit_address-1]);
					let vectors_u = vectors[0..(n_vector/2-1)];
					let vectors_v = vectors[(n_vector/2)..(n_vector-1)];
					(Controlled q_vector_s_creat) ( [qs_psi_a[nbit_address-1]], (vectors_u, qs_psi_a[0..nbit_address-2],
					qs_psi_vector));
					(Controlled q_vector_s_creat) ( [qs_psi_a[nbit_address-1]], (vectors_v, qs_psi_a[0..nbit_address-2],
					qs_psi_vector));
				}

				q_vector_s_creat (vectors, qs_psi_a, qs_psi_vector);
			}
		}
		
		operation q_vector_s_swaptest_state_prepare(vectors_group :Int[], norms:ComplexPolar[], vectors:ComplexPolar[][],
		 qss:Qubit[][] ):Unit
		{
			body(...)
			{
				let qs_u = qss[0];
				let qs_v = qss[1];
				let qs_vector = qss[2];
				q_vector_s_vnorms_prepare(qs_u, norms, vectors_group);
				q_vector_s_vdirections_prepare((qs_v, qs_vector), vectors, vectors_group);
			}
		}

		operation q_vector_s_inner (swaptest_state_prepare:(Qubit[][]=>Unit), nbit_address:Int, nbit_vector : Int, acc : Double) : (Double)
		{
			body(...)
			{
				let N = Ceiling(1.0/acc);
				mutable num_ones=0;
				mutable p=0.0;
				mutable inner=0.0;
				using(qs=Qubit[ 1 + nbit_address*2 + nbit_vector ] ) 
				{
					for(i in 1..N)
					{
						Reset(qs[0]);
						let qs_control = qs[0];
						let qs_u =qs[ 1..nbit_address ];
						let qs_v =qs[ (nbit_address+1)..2*nbit_address ];
						let qs_vector = qs[ (2*nbit_address+1)..(nbit_address*2+nbit_vector) ];
						let qs_swaptest = [ qs_u, qs_v, qs_vector]; 
						swaptest_state_prepare( qs_swaptest );
						q_swap_test_core( qs_control, qs_u, qs_v );
						let res = M(qs[0]);	// 0 为通过测试, 1为未通过测试
						if(res == Zero) 
						{ 
							set num_ones= num_ones+1;
						}
						ResetAll(qs);
					}
					set p = ToDouble(num_ones)*1.0/ToDouble(N) ;
					if( p< 0.5)
					{
						set p =0.5;
					}
					set inner = Sqrt(2.0*p-1.0) ; //向量组投影振幅
					ResetAll(qs);
				}
				return (inner);
			}
		}

		operation q_vector_Z_simulation():Unit
		{
			body(...)
			{
			//待完成...
			}
		}

		operation q_vector_count_Z():Double
		{
			body(...)
			{
			//待完成...
				return(4.0);
			}
		}
		
		operation q_vector_s_distance ( swaptest_state_prepare:(Qubit[][]=>Unit), nbit_address:Int, nbit_vector : Int, acc : Double ) : (Double)
		{
			body(...)
			{
				let A_p =q_vector_s_inner(swaptest_state_prepare, nbit_address, nbit_vector, acc);
				let Z_s = ToDouble(2^nbit_address);	// 向量总模数
				let M_s = ToDouble(2^nbit_address); // 向量总个数
				let distance = Sqrt( Z_s*M_s*A_p*A_p );
				return (distance);	
			}
		}
}
