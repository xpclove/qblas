#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_simulation_C_Swap (qs_control : Qubit, qs_a : Qubit[], qs_b : Qubit[], time : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs", 247L, 8L, 5L)]
[assembly: OperationDeclaration("qblas", "q_simulation_C_densitymatrix (qs_control : Qubit, qs_rho : Qubit[], qs_sigma : Qubit[], t : Double, err : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs", 488L, 16L, 5L)]
[assembly: OperationDeclaration("qblas", "q_simulation_C_SwapA (qs_control : Qubit, qs_SA : Qubit[], qs_rho : Qubit[], qs_u : Qubit[], dt : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs", 997L, 32L, 5L)]
[assembly: OperationDeclaration("qblas", "q_simulation_A (qs_control : Qubit, qs_A : Qubit[], qs_u : Qubit[], time : Double, t : Double, err : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs", 1172L, 40L, 5L)]
#line hidden
namespace qblas
{
    public class q_simulation_C_Swap : Operation<(Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid>
    {
        public q_simulation_C_Swap(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(qblas.q_walk_simulation_CSWAP) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>,Double)> q_walk_simulation_CSWAP
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>,Double)>, qblas.q_walk_simulation_CSWAP>();
            }
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_C_Swap", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_a,qs_b,time) = _args;
#line 11 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    q_walk_simulation_CSWAP.Apply((qs_control, qs_a, qs_b, time));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_C_Swap", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_a, QArray<Qubit> qs_b, Double time)
        {
            return __m__.Run<q_simulation_C_Swap, (Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid>((qs_control, qs_a, qs_b, time));
        }
    }

    public class q_simulation_C_densitymatrix : Operation<(Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double), QVoid>
    {
        public q_simulation_C_densitymatrix(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Extensions.Math.Ceiling), typeof(qblas.q_walk_simulation_CSWAP) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected ICallable<Double, Int64> MicrosoftQuantumExtensionsMathCeiling
        {
            get
            {
                return this.Factory.Get<ICallable<Double, Int64>, Microsoft.Quantum.Extensions.Math.Ceiling>();
            }
        }

        protected IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>,Double)> q_walk_simulation_CSWAP
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,QArray<Qubit>,QArray<Qubit>,Double)>, qblas.q_walk_simulation_CSWAP>();
            }
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_C_densitymatrix", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_rho,qs_sigma,t,err) = _args;
#line 19 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var N_D = ((t * t) / err);
#line 20 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var dt = (t / N_D);
#line 21 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var N = MicrosoftQuantumExtensionsMathCeiling.Apply<Int64>(N_D);
#line 22 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    foreach (var i in new Range(1L, 1L, N))
                    {
#line 24 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                        q_walk_simulation_CSWAP.Apply((qs_control, qs_rho, qs_sigma, dt));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_C_densitymatrix", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_rho, QArray<Qubit> qs_sigma, Double t, Double err)
        {
            return __m__.Run<q_simulation_C_densitymatrix, (Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double), QVoid>((qs_control, qs_rho, qs_sigma, t, err));
        }
    }

    public class q_simulation_C_SwapA : Operation<(Qubit,QArray<Qubit>,QArray<Qubit>,QArray<Qubit>,Double), QVoid>
    {
        public q_simulation_C_SwapA(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { };
        }

        public override Type[] Dependencies
        {
            get;
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_C_SwapA", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_SA,qs_rho,qs_u,dt) = _args;
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_simulation_C_SwapA", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_SA, QArray<Qubit> qs_rho, QArray<Qubit> qs_u, Double dt)
        {
            return __m__.Run<q_simulation_C_SwapA, (Qubit,QArray<Qubit>,QArray<Qubit>,QArray<Qubit>,Double), QVoid>((qs_control, qs_SA, qs_rho, qs_u, dt));
        }
    }

    public class q_simulation_A : Operation<(Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double,Double), QVoid>
    {
        public q_simulation_A(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Canon.ApplyToEachCA<>), typeof(Microsoft.Quantum.Extensions.Math.Ceiling), typeof(Microsoft.Quantum.Primitive.H), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.ResetAll), typeof(qblas.q_simulation_C_SwapA) };
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

        protected ICallable<Double, Int64> MicrosoftQuantumExtensionsMathCeiling
        {
            get
            {
                return this.Factory.Get<ICallable<Double, Int64>, Microsoft.Quantum.Extensions.Math.Ceiling>();
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

        protected ICallable<(Qubit,QArray<Qubit>,QArray<Qubit>,QArray<Qubit>,Double), QVoid> q_simulation_C_SwapA
        {
            get
            {
                return this.Factory.Get<ICallable<(Qubit,QArray<Qubit>,QArray<Qubit>,QArray<Qubit>,Double), QVoid>, qblas.q_simulation_C_SwapA>();
            }
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_simulation_A", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_A,qs_u,time,t,err) = _args;
#line 43 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var nbit = qs_u.Count;
#line 44 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var qs_rho = Allocate.Apply(nbit);
#line 46 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var N_D = ((t * t) / err);
#line 47 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var dt = (t / N_D);
#line 48 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    var N = MicrosoftQuantumExtensionsMathCeiling.Apply<Int64>(N_D);
#line 49 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                    foreach (var i in new Range(1L, 1L, N))
                    {
#line 51 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                        ResetAll.Apply(qs_rho);
#line 52 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                        MicrosoftQuantumCanonApplyToEachCA.Apply((((IUnitary)MicrosoftQuantumPrimitiveH), qs_rho));
#line 53 "X:\\git\\qblas\\src\\qblas\\qblas\\q_simulation.qs"
                        q_simulation_C_SwapA.Apply((qs_control, qs_A, qs_rho, qs_u, dt));
                    }

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

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_A, QArray<Qubit> qs_u, Double time, Double t, Double err)
        {
            return __m__.Run<q_simulation_A, (Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double,Double), QVoid>((qs_control, qs_A, qs_u, time, t, err));
        }
    }
}