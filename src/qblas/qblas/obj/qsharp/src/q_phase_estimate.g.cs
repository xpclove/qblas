#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_phase_estimate (qs : Qubit[]) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_phase_estimate.qs", 150L, 7L, 5L)]
#line hidden
namespace qblas
{
    public class q_phase_estimate : Operation<QArray<Qubit>, QVoid>
    {
        public q_phase_estimate(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { };
        }

        public override Type[] Dependencies
        {
            get;
        }

        public override Func<QArray<Qubit>, QVoid> Body
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_phase_estimate", OperationFunctor.Body, qs);
                var __result__ = default(QVoid);
                try
                {
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phase_estimate", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs)
        {
            return __m__.Run<q_phase_estimate, QArray<Qubit>, QVoid>(qs);
        }
    }
}