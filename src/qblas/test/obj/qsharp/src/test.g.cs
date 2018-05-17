#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("Quantum.test", "test (v : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\test\\test.qs", 157L, 8L, 5L)]
[assembly: FunctionDeclaration("Quantum.test", "t () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\test\\test.qs", 268L, 17L, 14L)]
#line hidden
namespace Quantum.test
{
    public class test : Operation<Double, QVoid>
    {
        public test(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.Release), typeof(qblas.q_fft) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected Allocate Allocate
        {
            get
            {
                return this.Factory.Get<Allocate, Microsoft.Quantum.Primitive.Allocate>();
            }
        }

        protected Release Release
        {
            get
            {
                return this.Factory.Get<Release, Microsoft.Quantum.Primitive.Release>();
            }
        }

        protected IUnitary<QArray<Qubit>> qblasq_fft
        {
            get
            {
                return this.Factory.Get<IUnitary<QArray<Qubit>>, qblas.q_fft>();
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
                    var qs = Allocate.Apply(10L);
#line 13 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Apply(qs);
#line hidden
                    Release.Apply(qs);
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

    public class t : Operation<QVoid, QVoid>
    {
        public t(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("Quantum.test.t", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
#line 19 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    foreach (var i in new Range(-(1L), 0L))
                    {
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("Quantum.test.t", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__)
        {
            return __m__.Run<t, QVoid, QVoid>(QVoid.Instance);
        }
    }
}