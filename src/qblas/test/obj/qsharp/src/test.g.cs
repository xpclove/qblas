#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("Quantum.test", "test (v : Double) : Int", new string[] { }, "X:\\git\\qblas\\src\\qblas\\test\\test.qs", 160L, 8L, 5L)]
[assembly: FunctionDeclaration("Quantum.test", "t () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\test\\test.qs", 766L, 41L, 14L)]
#line hidden
namespace Quantum.test
{
    public class test : Operation<Double, Int64>
    {
        public test(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.M), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.ResetAll), typeof(Microsoft.Quantum.Primitive.X), typeof(qblas.q_fft) };
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

        protected ICallable<Qubit, Result> M
        {
            get
            {
                return this.Factory.Get<ICallable<Qubit, Result>, Microsoft.Quantum.Primitive.M>();
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

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveX
        {
            get
            {
                return this.Factory.Get<IUnitary<Qubit>, Microsoft.Quantum.Primitive.X>();
            }
        }

        protected IUnitary<QArray<Qubit>> qblasq_fft
        {
            get
            {
                return this.Factory.Get<IUnitary<QArray<Qubit>>, qblas.q_fft>();
            }
        }

        public override Func<Double, Int64> Body
        {
            get => (v) =>
            {
#line hidden
                this.Factory.StartOperation("Quantum.test.test", OperationFunctor.Body, v);
                var __result__ = default(Int64);
                try
                {
#line 11 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    var res = 0L;
#line 12 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    var qs = Allocate.Apply(4L);
                    //set res=q_vector_inner([1.0],[2.0],5,100);
#line 16 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    MicrosoftQuantumPrimitiveX.Apply(qs[0L]);
                    //X(qs[1]);
#line 18 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Apply(qs);
                    //				SWAP(qs[0],qs[3]);
#line 20 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Adjoint.Apply(qs.Slice(new Range(0L, 1L)));
#line 21 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    MicrosoftQuantumPrimitiveX.Apply(qs[1L]);
#line 22 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    MicrosoftQuantumPrimitiveX.Apply(qs[0L]);
                    //Z(qs[0]);
#line 24 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Apply(qs.Slice(new Range(0L, 1L)));
                    //Z(qs[1]);
                    //(Controlled Y)([qs[0]],qs[1]);
#line 27 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    qblasq_fft.Adjoint.Apply(qs);
#line 28 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    foreach (var i in new Range(0L, 1L, (qs.Count - 1L)))
                    {
#line 30 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                        var r = M.Apply<Result>(qs[i]);
#line 31 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                        if ((r == Result.One))
                        {
#line 33 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                            res = (res + 10L.Pow(i));
                        }
                    }

                    //;
#line 36 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
                    ResetAll.Apply(qs);
#line hidden
                    Release.Apply(qs);
#line hidden
                    __result__ = res;
                    //;
#line 38 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
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

        public static System.Threading.Tasks.Task<Int64> Run(IOperationFactory __m__, Double v)
        {
            return __m__.Run<test, Double, Int64>(v);
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
#line 43 "X:\\git\\qblas\\src\\qblas\\test\\test.qs"
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