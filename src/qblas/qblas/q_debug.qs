namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	
	operation q_print(item:()):Unit
    {
        body(...)
        {
            for( i in item)
            {
                Message(ToStingI(i));
            }
        }
    }
}
