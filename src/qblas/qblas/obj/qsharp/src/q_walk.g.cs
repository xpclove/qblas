#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: OperationDeclaration("qblas", "q_walk_op_W (qs_a : Qubit[], qs_b : Qubit[]) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 163L, 7L, 5L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_T (qs_a : Qubit[], qs_b : Qubit[], qs_r : Qubit, t : Double) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 504L, 24L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_CSWAP (qs_control : Qubit, qs_a : Qubit[], qs_b : Qubit[], t : Double) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1010L, 47L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_op_V (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_a : Qubit[], qs_b : Qubit[], qs_r : Qubit) : ()", new string[] { "Controlled", "Adjoint" }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1265L, 59L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_bool (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1511L, 71L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_integer (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 1978L, 87L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_real (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 2442L, 103L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_imagebool (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 2911L, 119L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_imageinterger (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 3384L, 135L, 2L)]
[assembly: OperationDeclaration("qblas", "q_walk_simulation_matrix_1_sparse_imagereal (matrix_A : qblas.q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs", 3853L, 151L, 2L)]
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
            this.Dependencies = new Type[] { typeof(Microsoft.Quantum.Primitive.Allocate), typeof(Microsoft.Quantum.Primitive.CCNOT), typeof(Microsoft.Quantum.Primitive.Release), typeof(Microsoft.Quantum.Primitive.Rz), typeof(qblas.q_walk_op_W) };
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

        protected IUnitary<(Qubit,Qubit,Qubit)> MicrosoftQuantumPrimitiveCCNOT
        {
            get
            {
                return this.Factory.Get<IUnitary<(Qubit,Qubit,Qubit)>, Microsoft.Quantum.Primitive.CCNOT>();
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
                        MicrosoftQuantumPrimitiveCCNOT.Apply((qs_a[0L], qs_b[0L], qs_bit));
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
                        MicrosoftQuantumPrimitiveCCNOT.Adjoint.Apply((qs_a[0L], qs_b[0L], qs_bit));
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
                        MicrosoftQuantumPrimitiveCCNOT.Controlled.Apply((controlQubits, (qs_a[0L], qs_b[0L], qs_bit)));
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
                        MicrosoftQuantumPrimitiveCCNOT.Adjoint.Controlled.Apply((controlQubits, (qs_a[0L], qs_b[0L], qs_bit)));
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

    public class q_walk_simulation_CSWAP : Unitary<(Qubit,QArray<Qubit>,QArray<Qubit>,Double)>
    {
        public q_walk_simulation_CSWAP(IOperationFactory m) : base(m)
        {
            this.Dependencies = new Type[] { typeof(qblas.q_walk_simulation_T) };
        }

        public override Type[] Dependencies
        {
            get;
        }

        protected IUnitary<(QArray<Qubit>,QArray<Qubit>,Qubit,Double)> q_walk_simulation_T
        {
            get
            {
                return this.Factory.Get<IUnitary<(QArray<Qubit>,QArray<Qubit>,Qubit,Double)>, qblas.q_walk_simulation_T>();
            }
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid> Body
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_a,qs_b,t) = _args;
#line 50 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_control, t));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public override Func<(Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid> AdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Adjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (qs_control,qs_a,qs_b,t) = _args;
                    q_walk_simulation_T.Adjoint.Apply((qs_a, qs_b, qs_control, t));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Adjoint, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(Qubit,QArray<Qubit>,QArray<Qubit>,Double)), QVoid> ControlledBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Controlled, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_control,qs_a,qs_b,t)) = _args;
                    q_walk_simulation_T.Controlled.Apply((controlQubits, (qs_a, qs_b, qs_control, t)));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.Controlled, __result__);
                }
            }

            ;
        }

        public override Func<(QArray<Qubit>,(Qubit,QArray<Qubit>,QArray<Qubit>,Double)), QVoid> ControlledAdjointBody
        {
            get => (_args) =>
            {
#line hidden
                this.Factory.StartOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.ControlledAdjoint, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (controlQubits,(qs_control,qs_a,qs_b,t)) = _args;
                    q_walk_simulation_T.Adjoint.Controlled.Apply((controlQubits, (qs_a, qs_b, qs_control, t)));
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_CSWAP", OperationFunctor.ControlledAdjoint, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit qs_control, QArray<Qubit> qs_a, QArray<Qubit> qs_b, Double t)
        {
            return __m__.Run<q_walk_simulation_CSWAP, (Qubit,QArray<Qubit>,QArray<Qubit>,Double), QVoid>((qs_control, qs_a, qs_b, t));
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
#line 62 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
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

    public class q_walk_simulation_matrix_1_sparse_bool : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_bool(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_bool", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 74 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 75 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 77 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 78 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 79 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 80 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 81 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 82 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_bool", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_bool, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }

    public class q_walk_simulation_matrix_1_sparse_integer : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_integer(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_integer", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 90 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 91 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 93 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 94 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 95 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 96 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 97 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 98 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_integer", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_integer, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }

    public class q_walk_simulation_matrix_1_sparse_real : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_real(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_real", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 106 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 107 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 109 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 110 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 111 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 112 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 113 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 114 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_real", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_real, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }

    public class q_walk_simulation_matrix_1_sparse_imagebool : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_imagebool(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_imagebool", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 122 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 123 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 125 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 126 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 127 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 128 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 129 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 130 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_imagebool", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_imagebool, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }

    public class q_walk_simulation_matrix_1_sparse_imageinterger : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_imageinterger(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_imageinterger", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 138 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 139 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 141 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 142 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 143 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 144 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 145 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 146 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_imageinterger", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_imageinterger, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }

    public class q_walk_simulation_matrix_1_sparse_imagereal : Operation<(IUnitary,QArray<Qubit>,Double), QVoid>
    {
        public q_walk_simulation_matrix_1_sparse_imagereal(IOperationFactory m) : base(m)
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
                this.Factory.StartOperation("qblas.q_walk_simulation_matrix_1_sparse_imagereal", OperationFunctor.Body, _args);
                var __result__ = default(QVoid);
                try
                {
                    var (matrix_A,qs_state,t) = _args;
#line 154 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var nbit = qs_state.Count;
#line 155 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_tmp = Allocate.Apply((nbit + 1L));
#line 157 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_b = qs_tmp.Slice(new Range(0L, (nbit - 1L)));
#line 158 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_r = qs_tmp[nbit];
#line 159 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    var qs_a = qs_state;
#line 160 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Apply((matrix_A, qs_a, qs_b, qs_r));
#line 161 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_simulation_T.Apply((qs_a, qs_b, qs_r, t));
#line 162 "X:\\git\\qblas\\src\\qblas\\qblas\\q_walk.qs"
                    q_walk_op_V.Adjoint.Apply((matrix_A, qs_a, qs_b, qs_r));
#line hidden
                    Release.Apply(qs_tmp);
#line hidden
                    return __result__;
                }
                finally
                {
#line hidden
                    this.Factory.EndOperation("qblas.q_walk_simulation_matrix_1_sparse_imagereal", OperationFunctor.Body, __result__);
                }
            }

            ;
        }

        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, IUnitary matrix_A, QArray<Qubit> qs_state, Double t)
        {
            return __m__.Run<q_walk_simulation_matrix_1_sparse_imagereal, (IUnitary,QArray<Qubit>,Double), QVoid>((matrix_A, qs_state, t));
        }
    }
}