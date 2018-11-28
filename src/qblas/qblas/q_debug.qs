namespace qblas
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	
	operation q_print(item:()):Unit
    {
        body(...)
        {
            mutable line ="";
            for( i in item)
            {
               set line = line +" "+ToStingI(i));
            }
            Message(line);
        }
    }
}
