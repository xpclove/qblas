namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;

    // 1-sparse matrix oracle: |vertex>|next_vertex>|weight>
    newtype q_matrix_1_sparse_oracle = (Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl;

    // RAM entry: (vertex, next_vertex, weight)
    // QBLAS_M_Weight is already defined in q_ram.qs

    function q_matrix_convert(ram : (Int, Int, Int)[]) : QBLAS_M_Weight[] {
        let n = Length(ram);
        mutable RAM = [];
        for i in 0 .. n - 1 {
            let (v, next_v, w) = ram[i];
            set RAM += [QBLAS_M_Weight(v, next_v, w)];
        }
        return RAM;
    }

    operation q_matrix_1_sparse_bool_test(qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 0), (1, 0, 0)]);
        let RAM_image = q_matrix_convert([(0, 1, 1), (1, 0, 0)]);
        q_ram_call_bool(RAM, qs_address, qs_data, qs_weight);
    }

    operation q_matrix_1_sparse_integer_test(qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 2), (1, 0, 2)]);
        let RAM_image = q_matrix_convert([(0, 1, 10), (1, 0, 2)]);
        q_ram_call_integer(RAM, qs_address, qs_data, qs_weight);
    }

    operation q_matrix_1_sparse_real_test(qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([(0, 1, 1), (1, 0, 1)]);
        q_ram_call_real(RAM, qs_address, qs_data, qs_weight);
    }

    operation q_matrix_SwapA_test(qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let RAM = [[1, 1], [1, 1]];
        q_ram_call_SwapA(RAM, qs_address, qs_data, qs_weight);
    }

    // DEPRECATED: Empty placeholder operation, not used in current implementation
    operation q_matrix() : Unit { }
}