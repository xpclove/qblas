#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_vector_creat (vector : Double[], qs : Qubit[]) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs", 156L, 7L, 3L)]
#line hidden
namespace qblas
{
    public class q_vector_creat : Operation<(QArray<Double>,QArray<Qubit>), QVoid>
    {
        public q_vector_creat(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.H) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveH
        {
            get
            {
                return this.Factory.Get<IUnitary<Qubit>, Microsoft.Quantum.Primitive.H>();
            }
        }

        public override Func<(QArray<Double>,QArray<Qubit>), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_vector_creat", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (vector,qs) = _args;
#line 10 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    MicrosoftQuantumPrimitiveH.Apply(qs[0L]);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_vector_creat", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Double> vector, QArray<Qubit> qs)
        {
            return __m__.Run<q_vector_creat, (QArray<Double>,QArray<Qubit>), QVoid>((vector, qs));
        }
    }
}