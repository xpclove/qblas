namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //  LittleEndian Qubits
    //  U: 
    //  qs_u: state,  qs_phase: control lines 
    operation q_phase_estimate_core ( U_A: DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[] ) : Unit
    {
        body(...)
        {
            let nbit = Length(qs_phase);

            for(i in 0..1..(nbit-1))
            {
                H(qs_phase[i]);
            }

            for( i in 0..1..(nbit-1) ) 
            {  
                let n = 2^i;
                (Controlled U_A!) ( [ qs_phase[i] ], (n, qs_u) );
            }

            (Adjoint q_fft) (qs_phase);
        }
        adjoint auto;
		controlled auto;
		controlled adjoint auto;
    }

    operation q_phase_estimate ( U:DiscreteOracle, qs_u:Qubit[], qs_phase:Qubit[] ) : Unit
    {
        body(...)
        {
            q_phase_estimate_core(U, qs_u, qs_phase);
        }
    }
}

