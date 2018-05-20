#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_walk_op_W (qs_a : Qubit[], qs_b : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 163L, 7L, 5L)]
#line hidden
namespace qblas
{
    public class q_walk_op_W : Unitary<(QArray<Qubit>,QArray<Qubit>)>
    {
        public q_walk_op_W(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.CNOT), typeof(Microsoft.Quantum.Primitive.H) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected IUnitary<(Qubit,Qubit)> MicrosoftQuantumPrimitiveCNOT
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,Qubit)>, Microsoft.Quantum.Primitive.CNOT>();
            }
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveH
        {
            get
            {
                return this.Factory.Get<IUnitary<Qubit>, Microsoft.Quantum.Primitive.H>();
            }
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_W", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_a,qs_b) = _args;
#line 10 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_a.Count;
#line 11 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    foreach (var i in new Range(0L, (nbit - 1L)))
                    {
#line 13 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                        MicrosoftQuantumPrimitiveCNOT.Apply((qs_a[0L], qs_b[0L]));
#line 14 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                        MicrosoftQuantumPrimitiveH.Apply(qs_a[0L]);
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_W", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_W", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_a,qs_b) = _args;
#line 10 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_a.Count;
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveH.Adjoint.Apply(qs_a[0L]);
                        MicrosoftQuantumPrimitiveCNOT.Adjoint.Apply((qs_a[0L], qs_b[0L]));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_W", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_W", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_a,qs_b)) = _args;
                    var nbit = qs_a.Count;
                    foreach (var i in new Range(0L, (nbit - 1L)))
                    {
                        MicrosoftQuantumPrimitiveCNOT.Controlled.Apply((controlQubits, (qs_a[0L], qs_b[0L])));
                        MicrosoftQuantumPrimitiveH.Controlled.Apply((controlQubits, qs_a[0L]));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_W", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(QArray<Qubit>,QArray<Qubit>)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_W", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_a,qs_b)) = _args;
                    var nbit = qs_a.Count;
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveH.Adjoint.Controlled.Apply((controlQubits, qs_a[0L]));
                        MicrosoftQuantumPrimitiveCNOT.Adjoint.Controlled.Apply((controlQubits, (qs_a[0L], qs_b[0L])));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_W", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs_a, QArray<Qubit> qs_b)
        {
            return __m__.Run<q_walk_op_W, (QArray<Qubit>,QArray<Qubit>), QVoid>((qs_a, qs_b));
        }
    }
}