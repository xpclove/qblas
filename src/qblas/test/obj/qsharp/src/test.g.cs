#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("Quantum.test", "test (v : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\test\\test.qs", 157L, 8L, 5L)]
#line hidden
namespace Quantum.test
{
    public class test : Operation<Double, QVoid>
    {
        public test(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(qblas.q_fft) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected ICallable<QVoid, QVoid> qblasq_fft
        {
            get
            {
                return this.Factory.Get<ICallable<QVoid, QVoid>, qblas.q_fft>();
            }
        }

        public override Func<Double, QVoid> Body
        {
            get => (v) =>
            {
#line hidden
                this.Factory.StartOperation("Quantum.test.test", OperationFunctor.Body, v);
                var __result__ = default(QVoid);
                try
                {
#line 11 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Apply(QVoid.Instance);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("Quantum.test.test", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Double v)
        {
            return __m__.Run<test, Double, QVoid>(v);
        }
    }
}