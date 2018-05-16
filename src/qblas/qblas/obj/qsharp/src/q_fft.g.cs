#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_fft_core (qs : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs", 144L, 7L, 5L)]
#line hidden
namespace qblas
{
    public class q_fft_core : Unitary<QArray<Qubit>>
    {
        public q_fft_core(IOperationFactory m) : base(m)
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

        public override Func<QArray<Qubit>, QVoid> Body
        {
            get => (qs) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_fft_core", OperationFunctor.Body, qs);
                var __result__ = default(QVoid);
                try
                {
#line 10 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    var nbit = qs.Count;
#line 11 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    foreach (var i in new Range((nbit - 1L), 0L))
                    {
#line 13 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        MicrosoftQuantumPrimitiveH.Apply(qs[i]);
#line 14 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        foreach (var j in new Range((i - 1L), 0L))
                        {
#line 16 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            var k = ((i - j) + 1L);
                            //Cgate (R k) [qs.[j];qs.[i]];
                            ;
                        }
                    }

#line 20 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    foreach (var i in new Range(0L, ((nbit - 1L) / 2L)))
                    {
#line 22 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                        if ((i == ((nbit - 1L) - i)))
                        {
                        }
                        else
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
#line 10 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                    var nbit = qs.Count;
                    foreach (var i in new Range((0L - (((((nbit - 1L) / 2L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        if ((i == ((nbit - 1L) - i)))
                        {
                        }
                        else
                        {
                            MicrosoftQuantumPrimitiveSWAP.Adjoint.Apply((qs[i], qs[((nbit - 1L) - i)]));
                        }
                    }

                    foreach (var i in new Range(((nbit - 1L) - (((0L - (nbit - 1L)) / 1L) * -(1L))), -(1L), (nbit - 1L)))
                    {
                        foreach (var j in new Range((i - 1L), 0L))
                        {
#line 16 "X:\\git\\qblas\\src\\qblas\\qblas\\q_fft.qs"
                            var k = ((i - j) + 1L);
                            //Cgate (R k) [qs.[j];qs.[i]];
                            ;
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
                    foreach (var i in new Range((nbit - 1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveH.Controlled.Apply((controlQubits, qs[i]));
                        foreach (var j in new Range((i - 1L), 0L))
                        {
                            var k = ((i - j) + 1L);
                            //Cgate (R k) [qs.[j];qs.[i]];
                            ;
                        }
                    }

                    foreach (var i in new Range(0L, ((nbit - 1L) / 2L)))
                    {
                        if ((i == ((nbit - 1L) - i)))
                        {
                        }
                        else
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
                    foreach (var i in new Range((0L - (((((nbit - 1L) / 2L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        if ((i == ((nbit - 1L) - i)))
                        {
                        }
                        else
                        {
                            MicrosoftQuantumPrimitiveSWAP.Adjoint.Controlled.Apply((controlQubits, (qs[i], qs[((nbit - 1L) - i)])));
                        }
                    }

                    foreach (var i in new Range(((nbit - 1L) - (((0L - (nbit - 1L)) / 1L) * -(1L))), -(1L), (nbit - 1L)))
                    {
                        foreach (var j in new Range((i - 1L), 0L))
                        {
                            var k = ((i - j) + 1L);
                            //Cgate (R k) [qs.[j];qs.[i]];
                            ;
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
}