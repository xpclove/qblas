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

		operation q_vector_inner (u : ComplexPolar[], v : ComplexPolar[], n_qubit : Int, acc : Int) : (Double)
		{
			body(...)
			{
				let N = acc;
				mutable num_ones=0;
				mutable p=0.0;
				mutable inner=0.0;
				using(qs=Qubit[n_qubit*2+1])
				{
					for(i in 1..N)
					{
						Reset(qs[0]);
						let qs_u =qs[1..(n_qubit-1)];
						let qs_v =qs[(n_qubit)..(2*n_qubit)];
						q_vector_creat(u, qs_u);
						q_vector_creat(v, qs_v);
						q_swap_test_core( qs[0], qs_u, qs_v );
						let res = M(qs[0]);
						if(res == One) 
						{ 
							set num_ones= num_ones+1;
						}
						ResetAll(qs);
					}
					set p=ToDouble(num_ones)*1.0/ToDouble(N);
					set inner= 2.0*p-1.0 ;
				}
				return (inner);
			}
		}

		operation q_vector_distance (u : ComplexPolar[], v : ComplexPolar[], n_qubit : Int, acc : Int) : (Double)
		{
			body(...)
			{
				let inner=q_vector_inner(u,v,n_qubit,acc);
				let distance=Sqrt(2.0-2.0 * inner);
				return (distance);	
 
			}
		}
}
