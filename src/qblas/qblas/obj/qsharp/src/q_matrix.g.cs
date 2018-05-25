#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: UdtDeclaration("qblas", "q_matrix_1_sparse_oracle", "((Qubit[], Qubit[]) => () : Adjoint, Controlled)", "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs", 226L, 8L, 76L)]
[assembly: OperationDeclaration("qblas", "q_matrix () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs", 357L, 12L, 5L)]
[assembly: OperationDeclaration("qblas", "q_matrix_simulation_densitymatrix_C (qs_control : Qubit, qs_rho : Qubit[], qs_sigma : Qubit[], t : Double, err : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs", 552L, 20L, 5L)]
#line hidden
namespace qblas
{
    public class q_matrix : Operation<QVoid, QVoid>
    {
        public q_matrix(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_matrix", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_matrix", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__)
        {
            return __m__.Run<q_matrix, QVoid, QVoid>(QVoid.Instance);
        }
    }

    public class q_matrix_simulation_densitymatrix_C : Operation<(Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double), QVoid>
    {
        public q_matrix_simulation_densitymatrix_C(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Extensions.Math.Ceiling), typeof(Microsoft.Quantum.Extensions.Math.Sqrt), typeof(qblas.q_walk_simulation_CSWAP) };
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

        protected ICallable<Double, Double> MicrosoftQuantumExtensionsMathSqrt
        {
            get
            {
                return this.Factory.Get<ICallable<Double, Double>, Microsoft.Quantum.Extensions.Math.Sqrt>();
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
                this.Factory.StartOperation("qblas.q_matrix_simulation_densitymatrix_C", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_rho,qs_sigma,t,err) = _args;
#line 23 "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs"
                    var N_D = (MicrosoftQuantumExtensionsMathSqrt.Apply<Double>(t) / err);
#line 24 "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs"
                    var dt = (t / N_D);
#line 25 "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs"
                    var N = MicrosoftQuantumExtensionsMathCeiling.Apply<Int64>(N_D);
#line 26 "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs"
                    foreach (var i in new Range(1L, 1L, N))
                    {
#line 28 "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs"
                        q_walk_simulation_CSWAP.Apply((qs_control, qs_rho, qs_sigma, dt));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_matrix_simulation_densitymatrix_C", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_rho, QArray<Qubit> qs_sigma, Double t, Double err)
        {
            return __m__.Run<q_matrix_simulation_densitymatrix_C, (Qubit,QArray<Qubit>,QArray<Qubit>,Double,Double), QVoid>((qs_control, qs_rho, qs_sigma, t, err));
        }
    }
}