#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_phase_estimate_core (U : Microsoft.Quantum.Canon.DiscreteOracle, qs_u : Qubit[], qs_phase : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs", 235L, 9L, 5L)]
#line hidden
namespace qblas
{
    public class q_phase_estimate_core : Unitary<(IUnitary,QArray<Qubit>,QArray<Qubit>)>
    {
        public q_phase_estimate_core(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Canon.ApplyToEachCA<>), typeof(Microsoft.Quantum.Primitive.H), typeof(Microsoft.Quantum.Canon.SwapReverseRegister), typeof(qblas.q_fft) };
        }

        public override Type[] Dependencies
        {
            get;
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

        protected IUnitary<QArray<Qubit>> MicrosoftQuantumCanonSwapReverseRegister
        {
            get
            {
                return this.Factory.Get<IUnitary<QArray<Qubit>>, Microsoft.Quantum.Canon.SwapReverseRegister>();
            }
        }

        protected IUnitary<QArray<Qubit>> q_fft
        {
            get
            {
                return this.Factory.Get<IUnitary<QArray<Qubit>>, qblas.q_fft>();
            }
        }

        public override Func<(IUnitary,QArray<Qubit>,QArray<Qubit>), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_phase_estimate_core", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (U,qs_u,qs_phase) = _args;
#line 12 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    var nbit = qs_phase.Count;
#line 14 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    MicrosoftQuantumCanonApplyToEachCA.Apply((((IUnitary)MicrosoftQuantumPrimitiveH), qs_phase));
#line 16 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    foreach (var i in new Range(0L, 1L, (nbit - 1L)))
                    {
#line 18 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                        var n = 2L.Pow(i);
#line 19 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                        U.Controlled.Apply((new QArray<Qubit>()
                        {qs_phase[i]}, (n, qs_u)));
                    }

#line 22 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    MicrosoftQuantumCanonSwapReverseRegister.Apply(qs_phase);
#line 24 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    q_fft.Adjoint.Apply(qs_phase);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phase_estimate_core", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(IUnitary,QArray<Qubit>,QArray<Qubit>), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_phase_estimate_core", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (U,qs_u,qs_phase) = _args;
#line 12 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                    var nbit = qs_phase.Count;
                    q_fft.Adjoint.Adjoint.Apply(qs_phase);
                    MicrosoftQuantumCanonSwapReverseRegister.Adjoint.Apply(qs_phase);
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
#line 18 "/home/me/git/qblas/src/qblas/qblas/q_phase_estimate.qs"
                        var n = 2L.Pow(i);
                        U.Controlled.Adjoint.Apply((new QArray<Qubit>()
                        {qs_phase[i]}, (n, qs_u)));
                    }

                    MicrosoftQuantumCanonApplyToEachCA.Adjoint.Apply((((IUnitary)MicrosoftQuantumPrimitiveH), qs_phase));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phase_estimate_core", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(IUnitary,QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_phase_estimate_core", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(U,qs_u,qs_phase)) = _args;
                    var nbit = qs_phase.Count;
                    MicrosoftQuantumCanonApplyToEachCA.Controlled.Apply((controlQubits, (((IUnitary)MicrosoftQuantumPrimitiveH), qs_phase)));
                    foreach (var i in new Range(0L, 1L, (nbit - 1L)))
                    {
                        var n = 2L.Pow(i);
                        U.Controlled.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {qs_phase[i]}, (n, qs_u))));
                    }

                    MicrosoftQuantumCanonSwapReverseRegister.Controlled.Apply((controlQubits, qs_phase));
                    q_fft.Adjoint.Controlled.Apply((controlQubits, qs_phase));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phase_estimate_core", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(IUnitary,QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_phase_estimate_core", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(U,qs_u,qs_phase)) = _args;
                    var nbit = qs_phase.Count;
                    q_fft.Adjoint.Adjoint.Controlled.Apply((controlQubits, qs_phase));
                    MicrosoftQuantumCanonSwapReverseRegister.Adjoint.Controlled.Apply((controlQubits, qs_phase));
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        var n = 2L.Pow(i);
                        U.Controlled.Adjoint.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {qs_phase[i]}, (n, qs_u))));
                    }

                    MicrosoftQuantumCanonApplyToEachCA.Adjoint.Controlled.Apply((controlQubits, (((IUnitary)MicrosoftQuantumPrimitiveH), qs_phase)));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_phase_estimate_core", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary U, QArray<Qubit> qs_u, QArray<Qubit> qs_phase)
        {
            return __m__.Run<q_phase_estimate_core, (IUnitary,QArray<Qubit>,QArray<Qubit>), QVoid>((U, qs_u, qs_phase));
        }
    }
}