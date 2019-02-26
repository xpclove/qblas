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
	
	//测试 ram_call 方式制备：实数向量
	operation ram_call(qs_address:Qubit[], qs_data:Qubit[]):Unit
	{
		body(...)
		{
			let v = [0.3, 0.6, 0.6, 0.9];
			let RAM = q_com_convert_doubles_to_angles(v);
			q_ram_load_real_angle(RAM, qs_address, qs_data);
		}
		adjoint auto;
	}
	operation test_vector_prepare(p:Int):Unit
	{
		body(...)
		{
			using (qs = Qubit[2])
			{
				// ...
				q_vector_prepare(ram_call, qs, 8);
				DumpRegister("vector_dump.txt",qs);
				ResetAll(qs);
			} 
		}
	}

	//测试 ram_call 方式制备：复数向量
	operation ram_call_complex(qs_address:Qubit[], qs_real:Qubit[], qs_image:Qubit[]):Unit
	{
		body(...)
		{
			let v = [ (0.3,0.0), (0.6,0.0), (0.6,PI()), (0.9, 2.0*PI())];
			let RAM = q_com_convert_tuples_to_angles(v);
			q_ram_load_complex_angle(RAM, qs_address, qs_real, qs_image);
		}
		adjoint auto;
	}
	operation test_vector_complex_prepare(p:Int):Unit
	{
		body(...)
		{
			using (qs = Qubit[2])
			{
				// ...
				q_vector_complex_prepare(ram_call_complex, qs, 8);
				DumpRegister("vector_dump.txt",qs);
				ResetAll(qs);
			} 
		}
	}


	//	2个单位向量内积测试
	operation test_vector_inner (p:Int) : Int
	{
		body(...)
		{
			let u_raw = [(1.0, 0.0), (0.0, 0.0)];
			let v_raw = [(0.0, 0.0), (1.0, 0.0)];
			let u = q_com_convert_tuples_to_complexpolars(u_raw);
			let v = q_com_convert_tuples_to_complexpolars(v_raw);
			let inr = q_vector_inner(u, v, 1, 0.001);
			// let s =  q_vector_distance(1.0, u, 1.0, v, 1, 0.001);
			q_print_D( [inr] );
			return(1);
		}
	}

	// 2组等数量向量内积测试，每组2个向量
	operation oracle(qs:Qubit[]): Unit
	{	
		//态准备oracle
		body(...)
		{
			let vectors_raw = [ [(1.0, 0.0), (0.0, 0.0)],[(1.0, 0.0), (0.0, 0.0)], [(0.0, 0.0), (1.0, 0.0)], [(0.0, 0.0), (1.0, 0.0)] ] ;
			let norms_raw = [ 1.0, 1.0, 1.0, 1.0] ;
			let vectors = q_com_convert_tupless_to_complexpolarss(vectors_raw);
			let norms = q_com_convert_doubles_to_complexpolars(norms_raw);
			let group = [0,0,1,1];

			q_vector_s_swaptest_state_prepare(group, norms, vectors, qs);
		}
	}
	operation test_vectors_inner (p:Int) : Int
	{
		body(...)
		{
			let P_j= q_vector_s_inner(oracle, 2, 4, 0.001);
			let s =  q_vector_s_distance(oracle, 2, 4, 0.001);
			q_print_D([P_j, s]); 
			return(1); 
		}
	}
}
