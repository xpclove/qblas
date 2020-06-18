namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

	operation q_bell_state_creat( qs:Qubit[]) : Unit
	{
	//Little-End 
		body(...)
		{
			H(qs[1]);
			CNOT(qs[1],qs[0]);
		}
		adjoint auto;
		controlled auto;
		controlled adjoint auto;
	}

    operation q_tele_qubit_1 (qs_snd:Qubit, qs_rec:Qubit) : Unit
    {
        body(...)
        {
			using(qs_bell = Qubit[2])
			{
				ResetAll(qs_bell);
				X(qs_bell[0]);
				X(qs_bell[1]);
				//creat bell state
				q_bell_state_creat(qs_bell);
				let qs_alice = qs_bell[1];
				let qs_bob = qs_bell[0];
				//Alice operation
				(Adjoint q_bell_state_creat) ( [qs_alice,qs_snd] );
				let a_0 = M(qs_alice);
				let a_1 = M(qs_snd);
				mutable res = 0;
				if ( a_0 == One ) { set res = res + 1; }
				if ( a_1 == One ) { set res = res + 2; }

				//Alice send res to Bob
				//Bob operation
				(Adjoint q_bell_state_creat) ( [qs_bob, qs_rec] );
				if(res == 0){
					I(qs_rec);
				}elif(res == 1){
					I(qs_rec);
				}elif(res == 2){
					I(qs_rec);
				}elif(res == 3){
					I(qs_rec);
				}
				ResetAll(qs_bell);

			}
            
        }
    }
	operation q_tele_dense_coding_1(snd:Int) : (Int)
	{
		body(...)
		{
			mutable rec = 0;
			using(qs_tmp=Qubit[2])
			{
				ResetAll(qs_tmp);
				q_bell_state_creat(qs_tmp);
				let qs_alice = qs_tmp[1];
				let qs_bob = qs_tmp[0];
				// Alice operate
				if(snd == 0){
					I(qs_alice);
				}
				elif(snd == 1){
					X(qs_alice);
				}
				elif(snd == 2){
					Z(qs_alice);
				}
				elif(snd == 3){
					Z(qs_alice);
					X(qs_alice);
				}
				//Bob operaton and measurement
				(Adjoint q_bell_state_creat) (qs_tmp);
				for(i in 0..1..Length(qs_tmp)-1)
				{	
					let r = M(qs_tmp[i]);
					if( r == One )
					{
						set rec = rec+(2^i);
					}
				}
				ResetAll(qs_tmp);
			}
			return(rec);
		}
	}
}
