namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open qblas;

    operation test (v:Double) : ()
    {
        body
        {
			using(qs=Qubit[10])
			{
				q_fft(qs);
			}
        }
    }
    function t() : () 
    {
        for(i in (-1)..0)
        {
        }
        
    }
}
