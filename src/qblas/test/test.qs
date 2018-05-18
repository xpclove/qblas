namespace Quantum.test
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open qblas;

    operation test (v:Double) : (Double)
    {
        body
        {
			mutable res=0.0;
			using(qs=Qubit[10])
			{
				set res=q_vector_inner([1.0],[2.0],3,100);
				ResetAll(qs);
				
			}
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
