#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("Quantum.qblas", "creat () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs", 137L, 7L, 5L)]
#line hidden
namespace Quantum.qblas
{
    public class creat : Operation<QVoid, QVoid>
    {
        public creat(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { };
        }

        public override Type[] Dependencies
        {
            get;
        }

        public override Func<QVoid, QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("Quantum.qblas.creat", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("Quantum.qblas.creat", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__)
        {
            return __m__.Run<creat, QVoid, QVoid>(QVoid.Instance);
        }
    }
}