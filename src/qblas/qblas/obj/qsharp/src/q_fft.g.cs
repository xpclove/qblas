#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_fft_core (qs : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs", 168L, 8L, 5L)]
[assembly: OperationDeclaration("qblas", "q_fft (qs : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs", 673L, 35L, 2L)]
#line hidden
namespace qblas
{
    public class q_fft_core : Unitary<QArray<Qubit>>
    {
        public q_fft_core(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.H), typeof(Microsoft.Quantum.Primitive.R1Frac), typeof(Microsoft.Quantum.Primitive.SWAP) };
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

        protected IUnitary<(Int64,Int64,Qubit)> MicrosoftQuantumPrimitiveR1Frac
        {
            get
            {
                return this.Factory.Get<IUnitary<(Int64,Int64,Qubit)>, Microsoft.Quantum.Primitive.R1Frac>();
            }
        }

        protected IUnitary<(Qubit,Qubit)> MicrosoftQuantumPrimitiveSWAP
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,Qubit)>, Microsoft.Quantum.Primitive.SWAP>();
            }
        }

        public override Func<QArray<Qubit>, QVoid> Body
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft_core", OperationFunctor.Body, qs);
                var __result__ = default(QVoid);
                try
                {
#line 11 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    var nbit = qs.Count;
#line 12 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    foreach (var i in new Range((nbit - 1L), -(1L), 0L))
                    {
#line 14 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        MicrosoftQuantumPrimitiveH.Apply(qs[i]);
#line 15 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        foreach (var j in new Range((i - 1L), -(1L), 0L))
                        {
#line 17 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            var k = ((i - j) + 1L);
#line 18 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            MicrosoftQuantumPrimitiveR1Frac.Controlled.Apply((new QArray<Qubit>()
                            {qs[j]}, (2L, k, qs[i])));
                        }
                    }

                    //swap all qubits for the right order for ouput
#line 22 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    foreach (var i in new Range(0L, 1L, ((nbit - 1L) / 2L)))
                    {
#line 24 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        if ((i != ((nbit - 1L) - i)))
                        {
#line 26 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            MicrosoftQuantumPrimitiveSWAP.Apply((qs[i], qs[((nbit - 1L) - i)]));
                        }
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft_core", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<QArray<Qubit>, QVoid> AdjointBody
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft_core", OperationFunctor.Adjoint, qs);
                var __result__ = default(QVoid);
                try
                {
#line 11 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    var nbit = qs.Count;
                    //swap all qubits for the right order for ouput
                    foreach (var i in new Range((0L - (((((nbit - 1L) / 2L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        if ((i != ((nbit - 1L) - i)))
                        {
                            MicrosoftQuantumPrimitiveSWAP.Adjoint.Apply((qs[i], qs[((nbit - 1L) - i)]));
                        }
                    }

                    foreach (var i in new Range(((nbit - 1L) - (((0L - (nbit - 1L)) / -(1L)) * -(-(1L)))), -(-(1L)), (nbit - 1L)))
                    {
                        foreach (var j in new Range(((i - 1L) - (((0L - (i - 1L)) / -(1L)) * -(-(1L)))), -(-(1L)), (i - 1L)))
                        {
#line 17 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            var k = ((i - j) + 1L);
                            MicrosoftQuantumPrimitiveR1Frac.Controlled.Adjoint.Apply((new QArray<Qubit>()
                            {qs[j]}, (2L, k, qs[i])));
                        }

                        MicrosoftQuantumPrimitiveH.Adjoint.Apply(qs[i]);
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft_core", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft_core", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,qs) = _args;
                    var nbit = qs.Count;
                    foreach (var i in new Range((nbit - 1L), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveH.Controlled.Apply((controlQubits, qs[i]));
                        foreach (var j in new Range((i - 1L), -(1L), 0L))
                        {
                            var k = ((i - j) + 1L);
                            MicrosoftQuantumPrimitiveR1Frac.Controlled.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                            {qs[j]}, (2L, k, qs[i]))));
                        }
                    }

                    //swap all qubits for the right order for ouput
                    foreach (var i in new Range(0L, 1L, ((nbit - 1L) / 2L)))
                    {
                        if ((i != ((nbit - 1L) - i)))
                        {
                            MicrosoftQuantumPrimitiveSWAP.Controlled.Apply((controlQubits, (qs[i], qs[((nbit - 1L) - i)])));
                        }
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft_core", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft_core", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,qs) = _args;
                    var nbit = qs.Count;
                    //swap all qubits for the right order for ouput
                    foreach (var i in new Range((0L - (((((nbit - 1L) / 2L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        if ((i != ((nbit - 1L) - i)))
                        {
                            MicrosoftQuantumPrimitiveSWAP.Adjoint.Controlled.Apply((controlQubits, (qs[i], qs[((nbit - 1L) - i)])));
                        }
                    }

                    foreach (var i in new Range(((nbit - 1L) - (((0L - (nbit - 1L)) / -(1L)) * -(-(1L)))), -(-(1L)), (nbit - 1L)))
                    {
                        foreach (var j in new Range(((i - 1L) - (((0L - (i - 1L)) / -(1L)) * -(-(1L)))), -(-(1L)), (i - 1L)))
                        {
                            var k = ((i - j) + 1L);
                            MicrosoftQuantumPrimitiveR1Frac.Controlled.Adjoint.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                            {qs[j]}, (2L, k, qs[i]))));
                        }

                        MicrosoftQuantumPrimitiveH.Adjoint.Controlled.Apply((controlQubits, qs[i]));
                    }

#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft_core", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs)
        {
            return __m__.Run<q_fft_core, QArray<Qubit>, QVoid>(qs);
        }
    }

    public class q_fft : Unitary<QArray<Qubit>>
    {
        public q_fft(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(qblas.q_fft_core) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected IUnitary<QArray<Qubit>> q_fft_core
        {
            get
            {
                return this.Factory.Get<IUnitary<QArray<Qubit>>, qblas.q_fft_core>();
            }
        }

        public override Func<QArray<Qubit>, QVoid> Body
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft", OperationFunctor.Body, qs);
                var __result__ = default(QVoid);
                try
                {
#line 38 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    q_fft_core.Apply(qs);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<QArray<Qubit>, QVoid> AdjointBody
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft", OperationFunctor.Adjoint, qs);
                var __result__ = default(QVoid);
                try
                {
                    q_fft_core.Adjoint.Apply(qs);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,qs) = _args;
                    q_fft_core.Controlled.Apply((controlQubits, qs));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,qs) = _args;
                    q_fft_core.Adjoint.Controlled.Apply((controlQubits, qs));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_fft", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs)
        {
            return __m__.Run<q_fft, QArray<Qubit>, QVoid>(qs);
        }
    }
}