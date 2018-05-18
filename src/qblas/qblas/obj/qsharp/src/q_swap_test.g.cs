#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_swap_test (control : Qubit, u : Qubit[], v : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs", 162L, 7L, 5L)]
#line hidden
namespace qblas
{
    public class q_swap_test : Unitary<(Qubit,QArray<Qubit>,QArray<Qubit>)>
    {
        public q_swap_test(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.H), typeof(Microsoft.Quantum.Primitive.SWAP) };
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

        protected IUnitary<(Qubit,Qubit)> MicrosoftQuantumPrimitiveSWAP
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,Qubit)>, Microsoft.Quantum.Primitive.SWAP>();
            }
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_swap_test", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (control,u,v) = _args;
#line 10 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                    var nbit = u.Count;
#line 11 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                    MicrosoftQuantumPrimitiveH.Apply(control);
#line 12 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                    foreach (var i in new Range(0L, 1L, (nbit - 1L)))
                    {
#line 14 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Apply((new QArray<Qubit>()
                        {control}, (u[i], v[i])));
                    }

#line 16 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                    MicrosoftQuantumPrimitiveH.Apply(control);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_swap_test", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_swap_test", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (control,u,v) = _args;
#line 10 "/home/me/git/qblas/src/qblas/qblas/q_swap_test.qs"
                    var nbit = u.Count;
                    MicrosoftQuantumPrimitiveH.Adjoint.Apply(control);
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Adjoint.Apply((new QArray<Qubit>()
                        {control}, (u[i], v[i])));
                    }

                    MicrosoftQuantumPrimitiveH.Adjoint.Apply(control);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_swap_test", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(Qubit,QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_swap_test", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(control,u,v)) = _args;
                    var nbit = u.Count;
                    MicrosoftQuantumPrimitiveH.Controlled.Apply((controlQubits, control));
                    foreach (var i in new Range(0L, 1L, (nbit - 1L)))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {control}, (u[i], v[i]))));
                    }

                    MicrosoftQuantumPrimitiveH.Controlled.Apply((controlQubits, control));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_swap_test", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(Qubit,QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_swap_test", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(control,u,v)) = _args;
                    var nbit = u.Count;
                    MicrosoftQuantumPrimitiveH.Adjoint.Controlled.Apply((controlQubits, control));
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Adjoint.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {control}, (u[i], v[i]))));
                    }

                    MicrosoftQuantumPrimitiveH.Adjoint.Controlled.Apply((controlQubits, control));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_swap_test", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit control, QArray<Qubit> u, QArray<Qubit> v)
        {
            return __m__.Run<q_swap_test, (Qubit,QArray<Qubit>,QArray<Qubit>), QVoid>((control, u, v));
        }
    }
}