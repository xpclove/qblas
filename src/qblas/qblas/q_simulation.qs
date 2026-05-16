namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum simulation: Trotter decomposition and density matrix evolution
    // ============================================================

//
// Reference: Lloyd, "Universal Quantum Simulators"
// Science 273, 1073 (1996). https://arxiv.org/abs/quant-ph/9607003
// Trotter decomposition: Trotter, Proc. Amer. Math. Soc. 10, 545 (1959).
// ============================================================

    // Controlled SWAP simulation via quantum walk
    operation q_simulation_C_swap(qs_controls : Qubit[], qs_a : Qubit[], qs_b : Qubit[], t : Double) : Unit {
        q_walk_simulation_C_SWAP(qs_controls, qs_a, qs_b, t);
    }

    // Controlled density matrix simulation: each rho_i swapped with sigma for dt
    operation q_simulation_C_densitymatrix(qs_controls : Qubit[], qs_rho : Qubit[][], qs_sigma : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            q_walk_simulation_C_SWAP(qs_controls, qs_rho[i], qs_sigma, dt);
        }
    }

    // Dispatch to quantum walk simulation by matrix type
    operation q_simulation_matrix_1_sparse_type(matrix_type : Int, matrix : q_matrix_1_sparse_oracle, qs_u : Qubit[], t : Double) : Unit {
        q_walk_simulation_matrix_1_sparse_core(matrix_type, matrix, qs_u, t);
    }

    // Controlled version of matrix type dispatch
    operation q_simulation_C_matrix_1_sparse_type(qs_controls : Qubit[], matrix_type : Int, matrix : q_matrix_1_sparse_oracle, qs_u : Qubit[], t : Double) : Unit {
        q_walk_simulation_C_matrix_1_sparse_core(qs_controls, matrix_type, matrix, qs_u, t);
    }

    // ============================================================
    // Trotter decomposition: apply each matrix in sequence
    // ============================================================

    operation q_simulation_Trotter(matrixs : q_matrix_1_sparse_oracle[], matrixs_type : Int[], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. Length(matrixs) - 1 {
            q_simulation_matrix_1_sparse_type(matrixs_type[i], matrixs[i], qs_u, dt);
        }
    }

    // Controlled Trotter decomposition
    operation q_simulation_C_Trotter(qs_controls : Qubit[], matrixs : q_matrix_1_sparse_oracle[], matrixs_type : Int[], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. Length(matrixs) - 1 {
            q_simulation_C_matrix_1_sparse_type(qs_controls, matrixs_type[i], matrixs[i], qs_u, dt);
        }
    }

    // ============================================================
    // Complex matrix simulation (real + imaginary parts)
    // ============================================================

    // Complex SwapA simulation (real + imaginary parts via Trotter)
    operation q_simulation_C_SwapA_complex(qs_controls : Qubit[], qs_SA_real : q_matrix_1_sparse_oracle, qs_SA_image : q_matrix_1_sparse_oracle, qs_u : Qubit[], dt : Double) : Unit {
        let nbit = Length(qs_u) / 2;
        let t = IntAsDouble(2 ^ nbit) * dt;
        q_simulation_C_Trotter(qs_controls, [qs_SA_real, qs_SA_image], [2, 5], qs_u, t, 1000);
    }

    // Complex matrix A simulation (controlled): prepares rho=|+> and simulates SwapA
    operation q_simulation_C_A_complex(qs_controls : Qubit[], qs_SA_real : q_matrix_1_sparse_oracle, qs_SA_image : q_matrix_1_sparse_oracle, qs_rhos : Qubit[][], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            for j in 0 .. Length(qs_rhos[i]) - 1 {
                H(qs_rhos[i][j]);
            }
            q_simulation_C_SwapA_complex(qs_controls, qs_SA_real, qs_SA_image, qs_u, dt);
        }
    }

    // SwapA type simulation (controlled)
    operation q_simulation_C_SwapA_type(qs_controls : Qubit[], type : Int, qs_SA : q_matrix_1_sparse_oracle, qs_u : Qubit[], dt : Double) : Unit {
        let nbit = Length(qs_u) / 2;
        let t = IntAsDouble(2 ^ nbit) * dt;
        q_simulation_C_matrix_1_sparse_type(qs_controls, type, qs_SA, qs_u, t);
    }

    // Matrix A type simulation (controlled): prepares rho=|+> and simulates SwapA
    operation q_simulation_C_A_type(qs_controls : Qubit[], type : Int, qs_SA : q_matrix_1_sparse_oracle, qs_rhos : Qubit[][], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            for j in 0 .. Length(qs_rhos[i]) - 1 {
                H(qs_rhos[i][j]);
            }
            let qs_ru = q_com_array_join(qs_rhos[i], qs_u);
            q_simulation_C_SwapA_type(qs_controls, type, qs_SA, qs_ru, dt);
        }
    }

    // ============================================================
    // Uncontrolled versions
    // ============================================================

    // SwapA type simulation (uncontrolled)
    operation q_simulation_SwapA_type(type : Int, qs_SA : q_matrix_1_sparse_oracle, qs_u : Qubit[], dt : Double) : Unit {
        let nbit = Length(qs_u) / 2;
        let t = IntAsDouble(2 ^ nbit) * dt;
        q_simulation_matrix_1_sparse_type(type, qs_SA, qs_u, t);
    }

    // Matrix A type simulation (uncontrolled)
    operation q_simulation_A_type(type : Int, qs_SA : q_matrix_1_sparse_oracle, qs_rhos : Qubit[][], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            for j in 0 .. Length(qs_rhos[i]) - 1 {
                H(qs_rhos[i][j]);
            }
            let qs_ru = q_com_array_join(qs_rhos[i], qs_u);
            q_simulation_SwapA_type(type, qs_SA, qs_ru, dt);
        }
    }

    // Complex SwapA simulation (uncontrolled)
    operation q_simulation_SwapA_complex(qs_SA_real : q_matrix_1_sparse_oracle, qs_SA_image : q_matrix_1_sparse_oracle, qs_u : Qubit[], dt : Double) : Unit {
        let nbit = Length(qs_u) / 2;
        let t = IntAsDouble(2 ^ nbit) * dt;
        q_walk_simulation_matrix_1_sparse_complex(qs_SA_real, qs_SA_image, qs_u, t, 1000);
    }

    // Complex matrix A simulation (uncontrolled)
    operation q_simulation_A_complex(qs_SA_real : q_matrix_1_sparse_oracle, qs_SA_image : q_matrix_1_sparse_oracle, qs_rhos : Qubit[][], qs_u : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            for j in 0 .. Length(qs_rhos[i]) - 1 {
                H(qs_rhos[i][j]);
            }
            q_simulation_SwapA_complex(qs_SA_real, qs_SA_image, qs_u, dt);
        }
    }

    // Density matrix simulation: each rho_i swapped with sigma for dt
    operation q_simulation_densitymatrix(qs_rho : Qubit[][], qs_sigma : Qubit[], t : Double, N : Int) : Unit {
        let dt = t / IntAsDouble(N);
        for i in 0 .. N - 1 {
            q_walk_simulation_SWAP(qs_rho[i], qs_sigma, dt);
        }
    }
}