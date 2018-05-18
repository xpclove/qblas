#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_vector_creat (vector : Double[], qs : Qubit[]) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs", 245L, 9L, 3L)]
[assembly: OperationDeclaration("qblas", "q_vector_inner (u : Double[], v : Double[], n_qubit : Int, acc : Int) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs", 368L, 16L, 3L)]
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
#line 12 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
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

    public class q_vector_inner : Operation<(QArray<Double>,QArray<Double>,Int64,Int64), QVoid>
    {
        public q_vector_inner(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.M), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.Reset), typeof(Microsoft.Quantum.Primitive.ResetAll), typeof(qblas.q_swap_test), typeof(qblas.q_vector_creat) };
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

        protected ICallable<Qubit, QVoid> Reset
        {
            get
            {
                return this.Factory.Get<ICallable<Qubit, QVoid>, Microsoft.Quantum.Primitive.Reset>();
            }
        }

        protected ICallable<QArray<Qubit>, QVoid> ResetAll
        {
            get
            {
                return this.Factory.Get<ICallable<QArray<Qubit>, QVoid>, Microsoft.Quantum.Primitive.ResetAll>();
            }
        }

        protected IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>)> q_swap_test
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>)>, qblas.q_swap_test>();
            }
        }

        protected ICallable<(QArray<Double>,QArray<Qubit>), QVoid> q_vector_creat
        {
            get
            {
                return this.Factory.Get<ICallable<(QArray<Double>,QArray<Qubit>), QVoid>, qblas.q_vector_creat>();
            }
        }

        public override Func<(QArray<Double>,QArray<Double>,Int64,Int64), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_vector_inner", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (u,v,n_qubit,acc) = _args;
#line 19 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    var N = acc;
#line 20 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    var num_ones = 0L;
#line 21 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    var p = 0D;
#line 22 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    var inner = 0D;
#line 23 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    var qs = Allocate.Apply(((n_qubit * 2L) + 1L));
#line 25 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                    foreach (var i in new Range(1L, N))
                    {
#line 27 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        Reset.Apply(qs[0L]);
#line 28 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        q_vector_creat.Apply((u, qs.Slice(new Range(1L, (n_qubit - 1L)))));
#line 29 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        q_vector_creat.Apply((v, qs.Slice(new Range(n_qubit, (2L * n_qubit)))));
#line 30 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        q_swap_test.Apply((qs[0L], qs.Slice(new Range(1L, (n_qubit - 1L))), qs.Slice(new Range(n_qubit, (2L * n_qubit)))));
#line 31 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        var res = M.Apply<Result>(qs[0L]);
#line 32 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        if ((res == Result.One))
                        {
#line 34 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                            num_ones = (num_ones + 1L);
                        }

#line 36 "X:\\git\\qblas\\src\\qblas\\qblas\\q_vector.qs"
                        ResetAll.Apply(qs);
                    }

#line hidden
                    Release.Apply(qs);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_vector_inner", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Double> u, QArray<Double> v, Int64 n_qubit, Int64 acc)
        {
            return __m__.Run<q_vector_inner, (QArray<Double>,QArray<Double>,Int64,Int64), QVoid>((u, v, n_qubit, acc));
        }
    }
}