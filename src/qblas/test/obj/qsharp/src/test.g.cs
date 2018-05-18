#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("Quantum.test", "test (v : Double) : Double", new string[] { }, "/home/me/git/qblas/src/qblas/test/test.qs", 156L, 8L, 5L)]
[assembly: FunctionDeclaration("Quantum.test", "t () : ()", new string[] { }, "/home/me/git/qblas/src/qblas/test/test.qs", 349L, 21L, 14L)]
#line hidden
namespace Quantum.test
{
    public class test : Operation<Double, Double>
    {
        public test(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.ResetAll), typeof(qblas.q_vector_inner) };
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

        protected ICallable<QArray<Qubit>, QVoid> ResetAll
        {
            get
            {
                return this.Factory.Get<ICallable<QArray<Qubit>, QVoid>, Microsoft.Quantum.Primitive.ResetAll>();
            }
        }

        protected ICallable<(QArray<Double>,QArray<Double>,Int64,Int64), Double> qblasq_vector_inner
        {
            get
            {
                return this.Factory.Get<ICallable<(QArray<Double>,QArray<Double>,Int64,Int64), Double>, qblas.q_vector_inner>();
            }
        }

        public override Func<Double, Double> Body
        {
            get => (v) =>
            {
#line hidden
                this.Factory.StartOperation("Quantum.test.test", OperationFunctor.Body, v);
                var __result__ = default(Double);
                try
                {
#line 11 "/home/me/git/qblas/src/qblas/test/test.qs"
                    var res = 0D;
#line 12 "/home/me/git/qblas/src/qblas/test/test.qs"
                    var qs = Allocate.Apply(10L);
#line 14 "/home/me/git/qblas/src/qblas/test/test.qs"
                    res = qblasq_vector_inner.Apply<Double>((new QArray<Double>()
                    {1D}, new QArray<Double>()
                    {2D}, 5L, 100L));
#line 15 "/home/me/git/qblas/src/qblas/test/test.qs"
                    ResetAll.Apply(qs);
#line hidden
                    Release.Apply(qs);
#line hidden
                    __result__ = res;
#line 18 "/home/me/git/qblas/src/qblas/test/test.qs"
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

        public static System.Threading.Tasks.Task<Double> Run(IOperationFactory __m__, Double v)
        {
            return __m__.Run<test, Double, Double>(v);
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
#line 23 "/home/me/git/qblas/src/qblas/test/test.qs"
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