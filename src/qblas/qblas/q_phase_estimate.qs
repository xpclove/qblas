namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //  LittleEndian Qubits
    //  U: 
    //  qs_u: state,  qs_phase: control lines 
    operation q_phase_estimate_core ( U:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[] ) : ()
    {
        body
        {
            let nbit = Length(qs_phase);

            ApplyToEachCA(H, qs_phase);

            for( i in 0..1..(nbit-1) ) 
            {  
                let n = 2^(i);
                (Controlled U) ( [ qs_phase[i] ], (n, qs_u) );
            }

            SwapReverseRegister(qs_phase);

            (Adjoint q_fft) (qs_phase);
        }
        adjoint auto
		controlled auto
		controlled adjoint auto
    }

    operation q_phase_estimate ( U:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[] ) : ()
    {
        body
        {
            q_phase_estimate_core(U, qs_u, qs_phase);
        }
    }
}

