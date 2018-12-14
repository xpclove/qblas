namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Diagnostics;
	open Microsoft.Quantum.Extensions.Math;
	open qblas;

	// 测试 qs_creat
	operation test_creat(p:Int):Unit
	{
		body(...)
		{
			using (qs = Qubit[1])
			{
				// ...
				let v = [ComplexPolar(3.0, 0.0), ComplexPolar(3.0, 0.0)];
				let u =[3.0,3.0];
				let cp = q_com_convert_doubles_to_complexpolars(u);
				q_vector_creat(cp,qs);
				DumpRegister("ctdump.txt",qs);
				ResetAll(qs);
			} 
		}
	}

	//	2个单位向量测试
	operation test_vector (p:Int) : Int
	{
		body(...)
		{
			let u = [ComplexPolar(1.0, 0.0), ComplexPolar(0.0, 0.0)];
			let v = [ComplexPolar(0.0, 0.0), ComplexPolar(1.0, 0.0)];
			let inr= q_vector_inner(u, v, 1, 0.001);
			let s =  q_vector_distance(1.0, u, 1.0, v, 1, 0.001);
			q_print_D([inr,s]);
			return(1);
		}
	}

	// 2组等数量向量测试，每组2个向量
	operation oracle(qs:Qubit[]): Unit
	{
		body(...)
		{
			let vectors_raw =[ [(1.0, 0.0), (0.0, 0.0)],[(1.0, 0.0), (0.0, 0.0)],
			[(0.0, 0.0), (1.0, 0.0)], [(0.0, 0.0), (1.0, 0.0)] ] ;
			let vectors = q_com_convert_tupless_to_complexpolarss(vectors_raw);
			let group=[0,0,1,1];
			let norms=[ ComplexPolar(1.0, 0.0),ComplexPolar(0.0, 0.0),ComplexPolar(1.0, 0.0),
			ComplexPolar(1.0, 0.0)] ;
			q_vector_s_swaptest_state_prepare(group, norms, vectors, qs);
		}
	}

	operation test_vector_s (p:Int) : Int
	{
		body(...)
		{
			let inr= q_vector_s_inner(oracle, 2, 4, 0.01);
			let s =  q_vector_s_distance(oracle, 2, 4, 0.01);
			q_print_D([inr,s]);
			return(1);
		}
	}
}
