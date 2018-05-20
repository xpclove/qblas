#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_walk_op_W (qs_a : Qubit[], qs_b : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 163L, 7L, 5L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_T (qs_a : Qubit[], qs_b : Qubit[], qs_r : Qubit, t : Double) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 491L, 24L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_op_V (matrix_A : ((Qubit[], Qubit[]) => () : Controlled, Adjoint), qs_a : Qubit[], qs_b : Qubit[], qs_r : Qubit) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1050L, 47L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_1sparse (matrix_A : ((Qubit[], Qubit[]) => () : Controlled, Adjoint), qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1306L, 59L, 2L)]
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

    public class q_walk_simulation_T : Unitary<(QArray<Qubit>,QArray<Qubit>,Qubit,Double)>
    {
        public q_walk_simulation_T(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.Rz), typeof(Microsoft.Quantum.Primitive.SWAP), typeof(qblas.q_walk_op_W) };
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

        protected Release Release
        {
            get
            {
                return this.Factory.Get<Release, Microsoft.Quantum.Primitive.Release>();
            }
        }

        protected IUnitary<(Double,Qubit)> MicrosoftQuantumPrimitiveRz
        {
            get
            {
                return this.Factory.Get<IUnitary<(Double,Qubit)>, Microsoft.Quantum.Primitive.Rz>();
            }
        }

        protected IUnitary<(Qubit,Qubit)> MicrosoftQuantumPrimitiveSWAP
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,Qubit)>, Microsoft.Quantum.Primitive.SWAP>();
            }
        }

        protected IUnitary<(QArray<Qubit>,QArray<Qubit>)> q_walk_op_W
        {
            get
            {
                return this.Factory.Get<IUnitary<(QArray<Qubit>,QArray<Qubit>)>, qblas.q_walk_op_W>();
            }
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>,Qubit,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_T", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_a,qs_b,qs_r,t) = _args;
#line 27 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_a.Count;
#line 28 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply(1L);
#line 30 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_bit = qs_tmp[0L];
#line 31 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_W.Apply((qs_a, qs_b));
#line 32 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    foreach (var i in new Range(0L, (nbit - 1L)))
                    {
#line 34 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Apply((new QArray<Qubit>()
                        {qs_bit}, (qs_a[0L], qs_b[0L])));
                    }

#line 36 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    MicrosoftQuantumPrimitiveRz.Controlled.Apply((new QArray<Qubit>()
                    {qs_r}, (t, qs_bit)));
#line 37 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_W.Adjoint.Apply((qs_a, qs_b));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_T", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,QArray<Qubit>,Qubit,Double), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_T", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_a,qs_b,qs_r,t) = _args;
#line 27 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_a.Count;
                    var qs_tmp = Allocate.Apply(1L);
#line 30 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_bit = qs_tmp[0L];
                    q_walk_op_W.Adjoint.Adjoint.Apply((qs_a, qs_b));
                    MicrosoftQuantumPrimitiveRz.Controlled.Adjoint.Apply((new QArray<Qubit>()
                    {qs_r}, (t, qs_bit)));
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Adjoint.Apply((new QArray<Qubit>()
                        {qs_bit}, (qs_a[0L], qs_b[0L])));
                    }

                    q_walk_op_W.Adjoint.Apply((qs_a, qs_b));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_T", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(QArray<Qubit>,QArray<Qubit>,Qubit,Double)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_T", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_a,qs_b,qs_r,t)) = _args;
                    var nbit = qs_a.Count;
                    var qs_tmp = Allocate.Apply(1L);
                    var qs_bit = qs_tmp[0L];
                    q_walk_op_W.Controlled.Apply((controlQubits, (qs_a, qs_b)));
                    foreach (var i in new Range(0L, (nbit - 1L)))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {qs_bit}, (qs_a[0L], qs_b[0L]))));
                    }

                    MicrosoftQuantumPrimitiveRz.Controlled.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                    {qs_r}, (t, qs_bit))));
                    q_walk_op_W.Adjoint.Controlled.Apply((controlQubits, (qs_a, qs_b)));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_T", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(QArray<Qubit>,QArray<Qubit>,Qubit,Double)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_T", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_a,qs_b,qs_r,t)) = _args;
                    var nbit = qs_a.Count;
                    var qs_tmp = Allocate.Apply(1L);
                    var qs_bit = qs_tmp[0L];
                    q_walk_op_W.Adjoint.Adjoint.Controlled.Apply((controlQubits, (qs_a, qs_b)));
                    MicrosoftQuantumPrimitiveRz.Controlled.Adjoint.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                    {qs_r}, (t, qs_bit))));
                    foreach (var i in new Range((0L - ((((nbit - 1L) - 0L) / 1L) * -(1L))), -(1L), 0L))
                    {
                        MicrosoftQuantumPrimitiveSWAP.Controlled.Adjoint.Controlled.Apply((controlQubits, (new QArray<Qubit>()
                        {qs_bit}, (qs_a[0L], qs_b[0L]))));
                    }

                    q_walk_op_W.Adjoint.Controlled.Apply((controlQubits, (qs_a, qs_b)));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_T", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, QArray<Qubit> qs_a, QArray<Qubit> qs_b, Qubit qs_r, Double t)
        {
            return __m__.Run<q_walk_simulation_T, (QArray<Qubit>,QArray<Qubit>,Qubit,Double), QVoid>((qs_a, qs_b, qs_r, t));
        }
    }

    public class q_walk_op_V : Unitary<(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit)>
    {
        public q_walk_op_V(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { };
        }

        public override Type[] Dependencies
        {
            get;
        }

        public override Func<(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_V", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_a,qs_b,qs_r) = _args;
#line 50 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    matrix_A.Apply((qs_a, qs_b));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_V", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_V", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_a,qs_b,qs_r) = _args;
                    matrix_A.Adjoint.Apply((qs_a, qs_b));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_V", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_V", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(matrix_A,qs_a,qs_b,qs_r)) = _args;
                    matrix_A.Controlled.Apply((controlQubits, (qs_a, qs_b)));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_V", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_op_V", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(matrix_A,qs_a,qs_b,qs_r)) = _args;
                    matrix_A.Adjoint.Controlled.Apply((controlQubits, (qs_a, qs_b)));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_op_V", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_a, QArray<Qubit> qs_b, Qubit qs_r)
        {
            return __m__.Run<q_walk_op_V, (IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit), QVoid>((matrix_A, qs_a, qs_b, qs_r));
        }
    }

    public class q_walk_simulation_1sparse : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_1sparse(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.Release), typeof(qblas.q_walk_op_V), typeof(qblas.q_walk_simulation_T) };
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

        protected Release Release
        {
            get
            {
                return this.Factory.Get<Release, Microsoft.Quantum.Primitive.Release>();
            }
        }

        protected IUnitary<(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit)> q_walk_op_V
        {
            get
            {
                return this.Factory.Get<IUnitary<(IUnitary,QArray<Qubit>,QArray<Qubit>,Qubit)>, qblas.q_walk_op_V>();
            }
        }

        protected IUnitary<(QArray<Qubit>,QArray<Qubit>,Qubit,Double)> q_walk_simulation_T
        {
            get
            {
                return this.Factory.Get<IUnitary<(QArray<Qubit>,QArray<Qubit>,Qubit,Double)>, qblas.q_walk_simulation_T>();
            }
        }

        public override Func<(IUnitary,QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_1sparse", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 62 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 63 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 65 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 66 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 67 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 68 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((((IUnitary)matrix_A), qs_a, qs_b, qs_r));
#line 69 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 70 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((((IUnitary)matrix_A), qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_1sparse", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_1sparse, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }
}