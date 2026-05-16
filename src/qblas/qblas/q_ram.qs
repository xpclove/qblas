namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;
    import Std.Convert.*;

    newtype QBLAS_M_Weight = (Int, Int, Int);

    // ============================================================
    // Quantum RAM address preparation
    // ============================================================

    // Prepare address qubits to represent binary of address
    operation q_ram_addressing(qs_address : Qubit[], address : Int) : Unit is Adj + Ctl {
        let n_a = Length(qs_address);
        for j in 0 .. n_a - 1 {
            let bit = (address >>> j) &&& 1;
            if (bit == 0) {
                X(qs_address[j]);
            }
        }
    }

    // ============================================================
    // Data assignment operations
    // ============================================================

    // Assign integer data to qubit register (big-endian)
    operation q_ram_function_assignment_int(qs_data : Qubit[], data : Int) : Unit is Adj + Ctl {
        let n_d = Length(qs_data);
        for i in 0 .. n_d - 1 {
            let bit = (data >>> i) &&& 1;
            if (bit == 1) {
                X(qs_data[i]);
            }
        }
    }

    // Assign real (scaled integer) data to qubit register
    operation q_ram_function_assignment_real(qs_data : Qubit[], data : Int) : Unit is Adj + Ctl {
        let n_d = Length(qs_data);
        for i in 0 .. n_d - 1 {
            let bit = (data >>> i) &&& 1;
            if (bit == 1) {
                X(qs_data[i]);
            }
        }
    }

    // ============================================================
    // Quantum RAM loading (coherent data lookup)
    // ============================================================

    // Load RAM[address] → qs_data for all addresses (coherent superposition)
    operation q_ram_load(RAM : Int[], qs_address : Qubit[], qs_data : Qubit[]) : Unit is Adj + Ctl {
        let N_RAM = Length(RAM);
        for i in 0 .. N_RAM - 1 {
            q_ram_addressing(qs_address, i);
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data, RAM[i]));
            (Adjoint q_ram_addressing)(qs_address, i);
        }
    }

    // Load pairs of integers for complex amplitude loading
    operation q_ram_loads(RAM : (Int, Int)[], qs_address : Qubit[], qs_data : Qubit[][]) : Unit is Adj + Ctl {
        let N_RAM = Length(RAM);
        for i in 0 .. N_RAM - 1 {
            let (data_0, data_1) = RAM[i];
            q_ram_addressing(qs_address, i);
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data[0], data_0));
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data[1], data_1));
            (Adjoint q_ram_addressing)(qs_address, i);
        }
    }

    // ============================================================
    // Specialized QRAM call operations
    // ============================================================

    // Boolean weight QRAM call: loads (next_address, weight) from RAM
    operation q_ram_call_bool(RAM : QBLAS_M_Weight[], qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let N_RAM = Length(RAM);
        for i in 0 .. N_RAM - 1 {
            let (address, next_address, weight) = RAM[i]!;
            q_ram_addressing(qs_address, address);
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data, next_address));
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_weight, weight));
            (Adjoint q_ram_addressing)(qs_address, address);
        }
    }

    // Integer weight QRAM call
    operation q_ram_call_integer(RAM : QBLAS_M_Weight[], qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let N_RAM = Length(RAM);
        for i in 0 .. N_RAM - 1 {
            let (address, next_address, weight) = RAM[i]!;
            q_ram_addressing(qs_address, address);
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data, next_address));
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_weight, weight));
            (Adjoint q_ram_addressing)(qs_address, address);
        }
    }

    // Real weight QRAM call (scaled integer representation)
    operation q_ram_call_real(RAM : QBLAS_M_Weight[], qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let N_RAM = Length(RAM);
        for i in 0 .. N_RAM - 1 {
            let (address, next_address, weight) = RAM[i]!;
            q_ram_addressing(qs_address, address);
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_data, next_address));
            (Controlled q_ram_function_assignment_int)(qs_address, (qs_weight, weight));
            (Adjoint q_ram_addressing)(qs_address, address);
        }
    }

    // ============================================================
    // Angle-based QRAM loading
    // ============================================================

    // Load real-valued angles for QPE
    operation q_ram_load_real_angle(RAM : Int[], qs_address : Qubit[], qs_data : Qubit[]) : Unit is Adj + Ctl {
        q_ram_load(RAM, qs_address, qs_data);
    }

    // Load complex angles (real + imaginary parts)
    operation q_ram_load_complex_angle(RAM : (Int, Int)[], qs_address : Qubit[], qs_v_r : Qubit[], qs_v_i : Qubit[]) : Unit is Adj + Ctl {
        q_ram_loads(RAM, qs_address, [qs_v_r, qs_v_i]);
    }

    // ============================================================
    // Swap matrix QRAM (SwapA operation)
    // ============================================================

    // QRAM for SwapA matrix: RAM[i][j] → SWAP[j*N+i][i*N+j]
    operation q_ram_call_SwapA(RAM : Int[][], qs_address : Qubit[], qs_data : Qubit[], qs_weight : Qubit[]) : Unit is Adj + Ctl {
        let n_a = Length(qs_address);
        let n_d = Length(qs_data);
        let N = 2 ^ (n_a / 2);
        for j in 0 .. N - 1 {
            for i in 0 .. N - 1 {
                let address = j * N + i;
                let next_address = i * N + j;
                let weight = RAM[i][j];
                q_ram_addressing(qs_address, address);
                (Controlled q_ram_function_assignment_int)(qs_address, (qs_data, next_address));
                (Controlled q_ram_function_assignment_int)(qs_address, (qs_weight, weight));
                (Adjoint q_ram_addressing)(qs_address, address);
            }
        }
    }

    // ============================================================
    // Lambda reciprocal QRAM (for HHL/SVD algorithms)
    // ============================================================

    // QRAM for 1/lambda rotation: loads reciprocal of eigenvalue for phase rotation
    operation q_ram_call_lamda_rcp(qs_address : Qubit[], qs_weight : Qubit[], lambda_div : Double) : Unit is Adj + Ctl {
        let n_a = Length(qs_address);
        for i in 0 .. (2 ^ n_a) - 1 {
            q_ram_addressing(qs_address, i);
            if (i > 0) {
                if (i >= 2 ^ (n_a - 1)) {
                    // Negative number in two's complement
                    let lambda = IntAsDouble(i - 2 ^ n_a) * lambda_div;
                    if (lambda <= -1.0) {
                        let angle = 2.0 * ArcSin(1.0 / lambda);
                        (Controlled Ry)(qs_address, (angle, qs_weight[0]));
                    }
                } else {
                    let lambda = IntAsDouble(i) * lambda_div;
                    if (lambda >= 1.0) {
                        let angle = 2.0 * ArcSin(1.0 / lambda);
                        (Controlled Ry)(qs_address, (angle, qs_weight[0]));
                    }
                }
            }
            (Adjoint q_ram_addressing)(qs_address, i);
        }
    }
}