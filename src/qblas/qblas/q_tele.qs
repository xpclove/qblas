namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation bell_state_creat( qs:Qubit[]) : ()
	{
		body
		{
			H(qs[0]);
			CNOT(qs[0],qs[1]);
		}
		adjoint auto
		controlled auto
		controlled adjoint auto
	}

    operation q_tele_qubit_1 (qs_snd:Qubit, qs_rec:Qubit) : ()
    {
        body
        {
            
        }
    }
	operation q_tele_dense_coding_1(snd:Int) : (Int)
	{
		body
		{
			mutable rec = 0;
			using(qs_tmp=Qubit[2])
			{
				ResetAll(qs_tmp);
				bell_state_creat(qs_tmp);
				let qs_alice = qs_tmp[0];
				let qs_bob = qs_tmp[1];
				// Alice operate
				if(snd == 0){
					I(qs_alice);
				}
				elif(snd == 1){
					Z(qs_alice);
				}
				elif(snd == 2){
					X(qs_alice);
				}
				elif(snd == 3){
					Z(qs_alice);
					X(qs_alice);
				}
				//Bob operaton and measurement
				(Adjoint bell_state_creat) (qs_tmp);
				for(i in 0..1..Length(qs_tmp)-1)
				{	
					let r = M(qs_tmp[i]);
					if( r == One )
					{
						set rec = rec+(2^i);
					}
				};
				ResetAll(qs_tmp);
			}
			return(rec);
		}
	}
}
