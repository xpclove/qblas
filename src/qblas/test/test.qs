namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open qblas;

	operation test_qwalk(s:Int):(Int)
	{
		body(...)
		{
			using(qs =Qubit[2])
			{
				mutable m = q_matrix_1_sparse_oracle(q_matrix_1_sparse_bool_test );
				q_walk_simulation_matrix_1_sparse_bool (m, qs, 3.0);

			}
			return (0);
		}
	}

	operation test_qs_tele(snd:Int) : (Int)
	{
		body(...)
		{
			mutable rec = 0;
			set rec = q_tele_dense_coding_1(snd);
			return(rec);
		}
	}

    operation test (v:Double) : (Int)
    {
        body(...)
        {
			mutable res=0;
			using(qs=Qubit[4])
			{
				//set res=q_vector_inner([1.0],[2.0],5,100);
				
				X(qs[0]);
				//X(qs[1]);
				q_fft(qs);
//				SWAP(qs[0],qs[3]);
				(Adjoint q_fft) (qs[0..1]);
				X(qs[1]);
				X(qs[0]);
				//Z(qs[0]);
				(q_fft) (qs[0..1]);
				//Z(qs[1]);
				//(Controlled Y)([qs[0]],qs[1]);
				(Adjoint q_fft)(qs);
				for(i in 0..1..Length(qs)-1)
				{	
					let r = M(qs[i]);
					if( r == One )
					{
						set res = res+(10^i);
					}
				}
				ResetAll(qs);
			}
			return(res);
        }
    }
    function t() : Unit 
    {
        for(i in (-1)..0)
        {
        }
        
    }
}
