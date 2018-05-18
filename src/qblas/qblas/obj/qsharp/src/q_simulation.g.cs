#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_simulation_swap (qs : Qubit[], time : Double) : ()", new string[] { }, "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs", 160L, 7L, 5L)]
[assembly: OperationDeclaration("qblas", "q_simulation_swapA (qs_rho : Qubit[], qs_u : Qubit[]) : ()", new string[] { }, "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs", 337L, 17L, 5L)]
[assembly: OperationDeclaration("qblas", "q_simulation_A (qs_u : Qubit[], time : Double) : ()", new string[] { }, "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs", 453L, 26L, 5L)]
#line hidden
namespace qblas
{
    public class q_simulation_swap : Operation<(QArray<Qubit>,Double), QVoid>
    {
        public q_simulation_swap(IOperationFactory m) : base(m)
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

        public override Func<(QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_swap", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs,time) = _args;
#line 10 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    var nbit = (qs.Count / 2L);
#line 11 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    MicrosoftQuantumPrimitiveH.Apply(qs[0L]);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_swap", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs, Double time)
        {
            return __m__.Run<q_simulation_swap, (QArray<Qubit>,Double), QVoid>((qs, time));
        }
    }

    public class q_simulation_swapA : Operation<(QArray<Qubit>,QArray<Qubit>), QVoid>
    {
        public q_simulation_swapA(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { };
        }

        public override Type[] Dependencies
        {
            get;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_swapA", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_rho,qs_u) = _args;
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_swapA", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs_rho, QArray<Qubit> qs_u)
        {
            return __m__.Run<q_simulation_swapA, (QArray<Qubit>,QArray<Qubit>), QVoid>((qs_rho, qs_u));
        }
    }

    public class q_simulation_A : Operation<(QArray<Qubit>,Double), QVoid>
    {
        public q_simulation_A(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Canon.ApplyToEachCA<>), typeof(Microsoft.Quantum.Primitive.H), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.ResetAll), typeof(qblas.q_simulation_swapA) };
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

        protected IUnitary MicrosoftQuantumCanonApplyToEachCA
        {
            get
            {
                return new GenericOperation(this.Factory, typeof(Microsoft.Quantum.Canon.ApplyToEachCA<>));
            }
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveH
        {
            get
            {
                return this.Factory.Get<IUnitary<Qubit>, Microsoft.Quantum.Primitive.H>();
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

        protected ICallable<(QArray<Qubit>,QArray<Qubit>), QVoid> q_simulation_swapA
        {
            get
            {
                return this.Factory.Get<ICallable<(QArray<Qubit>,QArray<Qubit>), QVoid>, qblas.q_simulation_swapA>();
            }
        }

        public override Func<(QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_A", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_u,time) = _args;
#line 29 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    var nbit = qs_u.Count;
#line 30 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    var qs_rho = Allocate.Apply(nbit);
#line 32 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    ResetAll.Apply(qs_rho);
#line 33 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    MicrosoftQuantumCanonApplyToEachCA.Apply((((IUnitary)MicrosoftQuantumPrimitiveH), qs_rho));
#line 34 "/home/me/git/qblas/src/qblas/qblas/q_simulation.qs"
                    q_simulation_swapA.Apply((qs_rho, qs_u));
#line hidden
                    Release.Apply(qs_rho);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_A", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs_u, Double time)
        {
            return __m__.Run<q_simulation_A, (QArray<Qubit>,Double), QVoid>((qs_u, time));
        }
    }
}