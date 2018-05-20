#pragma warning disable 1591
using System;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.MetaData.Attributes;

[assembly: UdtDeclaration("qblas", "q_matrix_1_sparse_oracle", "((Qubit[], Qubit[]) => () : Adjoint, Controlled)", "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs", 177L, 7L, 76L)]
[assembly: OperationDeclaration("qblas", "q_matrix () : ()", new string[] { }, "X:\\git\\qblas\\src\\qblas\\qblas\\q_matrix.qs", 308L, 11L, 5L)]
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
}