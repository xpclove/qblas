namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open qblas;

	operation test_qs_tele(snd:Int) : (Int)
	{
		body
		{
			mutable rec = 0;
			set rec = q_tele_dense_coding_1(snd);
			return(rec);
		}
	}

    operation test (v:Double) : (Int)
    {
        body
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
				};
				ResetAll(qs);
			};
			return(res);
        }
    }
    function t() : () 
    {
        for(i in (-1)..0)
        {
        }
        
    }
}
