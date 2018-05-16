#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_phaseestimate () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_phaseestimate.qs", 139L, 7L, 5L)]
#line hidden
namespace qblas
{
    public class q_phaseestimate : Operation<QVoid, QVoid>
    {
        public q_phaseestimate(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_phaseestimate", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phaseestimate", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__)
        {
            return __m__.Run<q_phaseestimate, QVoid, QVoid>(QVoid.Instance);
        }
    }
}