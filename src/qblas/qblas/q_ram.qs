namespace qblas
{
    open Microsoft.Quantum.Primitive;
    
    open Microsoft.Quantum.Canon;

    newtype ComplexPolar = (Double, Double);
    
    //模拟读取量子内存 RAM[qs_address] = qs_data
    operation q_ram_call_bool ( RAM : Int[], qs_address:Qubit[], qs_data:Qubit[] ) : ()
    {
        body
        {
            let N_RAM = Length(RAM);
            let n_a = Length(qs_address);
            let n_d = Length(qs_data);
            using(qs_tmp = Qubit[n_d])
            {
                for(i in 0..(N_RAM-1) )
                {
                    let r = RAM[i];
                    if(r != 0)
                    {

                    }
                }
            }
        }
    }
    
}
