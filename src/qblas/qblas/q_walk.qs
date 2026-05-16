namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum walk operators and simulation
    // ============================================================

    // Hadamard + S gate = Hy (approximation of Y rotation)
    operation Hy(qs : Qubit) : Unit is Adj + Ctl {
        H(qs);
        S(qs);
    }

    // Walk operator W: H on each qubit, then CNOT from a to b
    operation q_walk_op_W(qs_a : Qubit[], qs_b : Qubit[]) : Unit is Adj + Ctl {
        let nbit = Length(qs_a);
        for i in 0 .. nbit - 1 {
            CNOT(qs_a[i], qs_b[i]);
            H(qs_a[i]);
        }
    }

    // Walk operator A = W * (I tensor CCNOT) * W
    operation q_walk_op_A(qs_a : Qubit[], qs_b : Qubit[], qs_tmp : Qubit) : Unit is Adj + Ctl {
        let nbit = Length(qs_a);
        q_walk_op_W(qs_a, qs_b);
        for i in 0 .. nbit - 1 {
            CCNOT(qs_a[i], qs_b[i], qs_tmp);
        }
    }

    // M operator: apply the sparse matrix oracle
    operation q_walk_op_M(matrix_A : q_matrix_1_sparse_oracle, qs_a : Qubit[], qs_b : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        matrix_A!(qs_a, qs_b, qs_weight);
    }

    // ============================================================
    // T gate simulation via walk operators
    // ============================================================

    // T gate simulation: SWAP * exp(-i*t) via walk operators
    operation q_walk_simulation_C_T(qs_a : Qubit[], qs_b : Qubit[], qs_controls : Qubit[], t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_a);
        let angle = 2.0 * t;
        use qs_tmp = Qubit[1];
        let qs_bit = qs_tmp[0];
        q_walk_op_A(qs_a, qs_b, qs_bit);
        (Controlled Rz)(qs_controls, (angle, qs_bit));
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_bit);
    }

    operation q_walk_simulation_C_SWAP(qs_controls : Qubit[], qs_a : Qubit[], qs_b : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_C_T(qs_a, qs_b, qs_controls, t);
    }

    // T gate without control (uncontrolled version)
    operation q_walk_simulation_T(qs_a : Qubit[], qs_b : Qubit[], t : Double) : Unit is Adj + Ctl {
        let angle = 2.0 * t;
        use qs_tmp = Qubit[1];
        let qs_bit = qs_tmp[0];
        q_walk_op_A(qs_a, qs_b, qs_bit);
        Rz(angle, qs_bit);
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_bit);
    }

    operation q_walk_simulation_SWAP(qs_a : Qubit[], qs_b : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_T(qs_a, qs_b, t);
    }

    // ============================================================
    // Float rotation operations (F_p, F_n, sF)
    // ============================================================

    // Positive float rotation F_p
    operation q_walk_simulation_F_p(qs_weight : Qubit[], t : Double, n_bits_float : Int) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        for i in 0 .. nbit - 1 {
            let fi = IntAsDouble(i);
            let ff = IntAsDouble(n_bits_float);
            let g = 2.0 ^ (fi - ff);
            let angle = t * g;
            Rz(angle, qs_weight[i]);
        }
    }

    // Negative float rotation F_n
    operation q_walk_simulation_F_n(qs_weight : Qubit[], t : Double, n_bits_float : Int) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        for i in 0 .. nbit - 1 {
            let fi = IntAsDouble(i);
            let ff = IntAsDouble(n_bits_float);
            let g = 2.0 ^ (fi - ff);
            let angle = 0.0 - (t * g);
            Rz(angle, qs_weight[i]);
        }
    }

    // sF rotation: controlled rotation on weight qubits conditioned on sign bit
    operation q_walk_simulation_sF(qs_weight : Qubit[], t : Double, n_bits_float : Int, Rp : Pauli) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        for i in 0 .. nbit - 2 {
            let fi = IntAsDouble(i);
            let ff = IntAsDouble(n_bits_float);
            let g = 2.0 ^ (fi - ff);
            let angle = 2.0 * (t * g);
            (Controlled R)([qs_weight[i]], (Rp, angle, qs_sign));
        }
    }

    // ============================================================
    // T gate with rotations
    // ============================================================

    // T gate with sF rotation (float-weighted)
    operation q_walk_simulation_T_sF(qs_a : Qubit[], qs_b : Qubit[], qs_control : Qubit, qs_weight : Qubit[], n_bits_float : Int, t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        q_walk_op_A(qs_a, qs_b, qs_sign);
        q_walk_simulation_sF(qs_weight, t, n_bits_float, PauliZ);
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_sign);
    }

    // T gate with R rotation (simple version)
    operation q_walk_simulation_T_R(Rp : Pauli, qs_a : Qubit[], qs_b : Qubit[], qs_weight : Qubit[], t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        q_walk_op_A(qs_a, qs_b, qs_sign);
        let angle = 2.0 * t;
        R(Rp, angle, qs_sign);
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_sign);
    }

    // T gate with sF rotation, controlled version
    operation q_walk_simulation_C_T_R_sF(qs_controls : Qubit[], Rp : Pauli, qs_a : Qubit[], qs_b : Qubit[], qs_weight : Qubit[], n_bits_float : Int, t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        q_walk_op_A(qs_a, qs_b, qs_sign);
        (Controlled q_walk_simulation_sF)(qs_controls, (qs_weight, t, n_bits_float, Rp));
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_sign);
    }

    // Controlled T gate with R rotation
    operation q_walk_simulation_C_T_R(qs_controls : Qubit[], Rp : Pauli, qs_a : Qubit[], qs_b : Qubit[], qs_weight : Qubit[], t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        q_walk_op_A(qs_a, qs_b, qs_sign);
        let angle = 2.0 * t;
        (Controlled R)(qs_controls, (Rp, angle, qs_sign));
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_sign);
    }

    // T gate with R + sF rotation (float-weighted)
    operation q_walk_simulation_T_R_sF(Rp : Pauli, qs_a : Qubit[], qs_b : Qubit[], qs_weight : Qubit[], n_bits_float : Int, t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_weight);
        let qs_sign = qs_weight[nbit - 1];
        q_walk_op_A(qs_a, qs_b, qs_sign);
        q_walk_simulation_sF(qs_weight, t, n_bits_float, Rp);
        (Adjoint q_walk_op_A)(qs_a, qs_b, qs_sign);
    }

    // ============================================================
    // Matrix type lookup
    // ============================================================

    // Matrix type lookup: (Pauli, nbit_float, nbit_weight, t_sign)
    function q_walk_matrix_type(type : Int) : (Pauli, Int, Int, Double) {
        let p = [PauliZ, PauliY];
        let nbit_float = q_com_real_nbit_float();
        // type: 0=bool, 1=integer, 2=real, 3=imagebool, 4=imageinteger, 5=imagereal
        let types = [
            (p[0], 0, 1, 1.0),
            (p[0], 0, 4, 1.0),
            (p[0], nbit_float, 8, 1.0),
            (p[1], 0, 1, -1.0),
            (p[1], 0, 4, -1.0),
            (p[1], nbit_float, 8, -1.0)
        ];
        return types[type];
    }

    // ============================================================
    // Core 1-sparse matrix walk simulation
    // ============================================================

    operation q_walk_simulation_matrix_1_sparse_core(matrix_type : Int, matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_state);
        let (Rp, nbit_float, nbit_weight, t_sign) = q_walk_matrix_type(matrix_type);
        use qs_tmp = Qubit[nbit + nbit_weight];
        let qs_b = qs_tmp[0 .. nbit - 1];
        let qs_weight = qs_tmp[nbit .. nbit + nbit_weight - 1];
        let qs_a = qs_state;
        let time = t_sign * t;
        q_walk_op_M(matrix_A, qs_a, qs_b, qs_weight);
        q_walk_simulation_T_R_sF(Rp, qs_a, qs_b, qs_weight, nbit_float, time);
        (Adjoint q_walk_op_M)(matrix_A, qs_a, qs_b, qs_weight);
    }

    // Controlled 1-sparse matrix walk simulation
    operation q_walk_simulation_C_matrix_1_sparse_core(qs_controls : Qubit[], matrix_type : Int, matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        let nbit = Length(qs_state);
        let (Rp, nbit_float, nbit_weight, t_sign) = q_walk_matrix_type(matrix_type);
        use qs_tmp = Qubit[nbit + nbit_weight];
        let qs_b = qs_tmp[0 .. nbit - 1];
        let qs_weight = qs_tmp[nbit .. nbit + nbit_weight - 1];
        let qs_a = qs_state;
        let time = t_sign * t;
        q_walk_op_M(matrix_A, qs_a, qs_b, qs_weight);
        q_walk_simulation_C_T_R_sF(qs_controls, Rp, qs_a, qs_b, qs_weight, nbit_float, time);
        (Adjoint q_walk_op_M)(matrix_A, qs_a, qs_b, qs_weight);
    }

    // ============================================================
    // Type-specific 1-sparse matrix simulations
    // ============================================================

    operation q_walk_simulation_matrix_1_sparse_bool(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(0, matrix_A, qs_state, t);
    }

    operation q_walk_simulation_matrix_1_sparse_integer(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(1, matrix_A, qs_state, t);
    }

    operation q_walk_simulation_matrix_1_sparse_real(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(2, matrix_A, qs_state, t);
    }

    operation q_walk_simulation_matrix_1_sparse_imagebool(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(3, matrix_A, qs_state, t);
    }

    operation q_walk_simulation_matrix_1_sparse_imageinteger(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(4, matrix_A, qs_state, t);
    }

    operation q_walk_simulation_matrix_1_sparse_imagereal(matrix_A : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(5, matrix_A, qs_state, t);
    }

    // ============================================================
    // Complex matrix simulation (real + imaginary)
    // ============================================================

    operation q_walk_simulation_matrix_1_sparse_complex(matrix_A_real : q_matrix_1_sparse_oracle, matrix_A_image : q_matrix_1_sparse_oracle, qs_state : Qubit[], t : Double, N : Int) : Unit is Adj + Ctl {
        let nbit = Length(qs_state);
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            q_walk_simulation_matrix_1_sparse_real(matrix_A_real, qs_state, dt);
            q_walk_simulation_matrix_1_sparse_imagereal(matrix_A_image, qs_state, dt);
        }
    }

    // ============================================================
    // Type dispatchers
    // ============================================================

    operation q_walk_simulation_matrix_1_sparse_type(matrix_type : Int, matrix : q_matrix_1_sparse_oracle, qs_u : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_matrix_1_sparse_core(matrix_type, matrix, qs_u, t);
    }

    operation q_walk_simulation_C_matrix_1_sparse_type(qs_controls : Qubit[], matrix_type : Int, matrix : q_matrix_1_sparse_oracle, qs_u : Qubit[], t : Double) : Unit is Adj + Ctl {
        q_walk_simulation_C_matrix_1_sparse_core(qs_controls, matrix_type, matrix, qs_u, t);
    }
}