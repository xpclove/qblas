// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Hamiltonian Simulation Suite
//
// What it does:
//   Demonstrates QBLAS's Hamiltonian simulation modules
//   for Trotter decomposition, qubitization, Gibbs state
//   preparation, and time-dependent evolution planning.
//
// Input:
//   Hard-coded Hamiltonian norms [1.0, 2.0] for 2-term H,
//   spectral gap k=2.0, evolution time t=1.0, precision 0.01.
//
// Output:
//   Single integer encoding 8 test outcomes (bits 0-7).
//   Each bit = 1 when the corresponding module step passes.
//
// Pipeline steps and module mapping:
//   Step 1: q_trotter_suzuki     → Trotter step size
//   Step 2: q_trotter_suzuki     → Optimal steps
//   Step 3: q_trotter_suzuki     → Order validity
//   Step 4: q_trotter_suzuki     → Error bound
//   Step 5: q_trotter_suzuki     → Suzuki coefficients
//   Step 6: q_trotter_suzuki     → Ancilla check
//   Step 7: q_qubitization       → Query complexity
//   Step 8: q_qubitization       → Accuracy verification
//   Step 9: q_gibbs              → Beta computation
//   Step 10: q_gibbs             → Partition bound
//   Step 11: q_gibbs             → Free energy
//   Step 12: q_gibbs             → Temperature validity
//   Step 13: q_timedependent     → Discretization
//   Step 14: q_timedependent     → Step size
//   Step 15: q_timedependent     → Evolution verification
//   Step 16: q_timedependent     → Optimal order
//
// Verification:
//   All 16 steps have Fact() assertions with exact expected values.
//   Covers 4 simulation modules with 16 deterministic checks.
//
// Reference: Nielsen & Chuang Ch.4,
//            "Quantum Simulation" (2010)
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    import Std.Diagnostics.Fact;
    open qblas;

    operation DemoHamiltonianSim() : Int {
        mutable result = 0;

        // === Trotter-Suzuki ===

        // Step 1: Trotter step size (norms [1,2], total t=1, r=2)
        let step = q_trotter_step_size([1.0, 2.0], 1.0, 2);
        Fact(AbsD(step - 1.0) < 1e-10, "trotter_step_size");
        set result += 1;

        // Step 2: Optimal steps (norm_H=3, t=1, order=2, prec=0.01)
        let opt_steps = q_trotter_optimal_steps(3.0, 1.0, 2, 0.01);
        Fact(opt_steps == 3, "trotter_optimal_steps");
        set result += 2;

        // Step 3: Order validity (order=2 is valid)
        let valid_order = q_trotter_is_valid_order(2) ? 1 | 0;
        Fact(valid_order == 1, "trotter_is_valid_order");
        set result += 4;

        // Step 4: Error bound (norms [1,2], t=1, r=2, order=2)
        let err = q_trotter_error_bound([1.0, 2.0], 1.0, 2, 2);
        Fact(AbsD(err - 0.28125) < 1e-10, "trotter_error_bound");
        set result += 8;

        // Step 5: Suzuki 2 coefficients (3 terms)
        let coeffs = q_trotter_suzuki_2_coeffs(3);
        Fact(Length(coeffs) == 3, "trotter_suzuki_2_coeffs: length");
        set result += 16;

        // Step 6: Ancilla check (3 qubits, 2 data, 1 weight)
        let anc_ok = q_trotter_check_ancilla(3, 2, 1) ? 1 | 0;
        Fact(anc_ok == 1, "trotter_check_ancilla");
        set result += 32;

        // === Qubitization ===

        // Step 7: Query complexity (sparsity=3, h_max=2, t=1, prec=0.01)
        let queries = q_qubitization_query_complexity(3, 2.0, 1.0, 0.01);
        Fact(queries == 9, "qubitization_query_complexity");
        set result += 64;

        // Step 8: Accuracy (actual=1, target=1, h_max=2)
        let acc = q_qubitization_verify_accuracy(1.0, 1.0, 2.0);
        Fact(AbsD(acc - 0.0) < 1e-10, "qubitization_verify_accuracy");
        set result += 128;

        // === Gibbs State Preparation ===

        // Step 9: Beta (energy_scale=2, target_entropy=0.5)
        let beta = q_gibbs_compute_beta(2.0, 0.5);
        Fact(AbsD(beta - 4.0) < 1e-10, "gibbs_compute_beta");
        set result += 256;

        // Step 10: Partition bound (eigenvalues [1,2], beta=0.5)
        let part = q_gibbs_partition_bound([1.0, 2.0], 0.5);
        Fact(AbsD(part - 1.0) < 1e-10, "gibbs_partition_bound");
        set result += 512;

        // Step 11: Free energy (Z=2.0, temperature=1.0)
        let free = q_gibbs_free_energy(2.0, 1.0);
        Fact(AbsD(free - 0.0) < 1e-8, "gibbs_free_energy");
        set result += 1024;

        // Step 12: Temperature validity (T=1 is valid)
        let temp_ok = q_gibbs_is_valid_temperature(1.0) ? 1 | 0;
        Fact(temp_ok == 1, "gibbs_is_valid_temperature");
        set result += 2048;

        // === Time-Dependent Simulation ===

        // Step 13: Discretization (h_max=2, time_span=1, prec=0.01)
        let n_steps = q_timedep_discretize_steps(2.0, 1.0, 0.01);
        Fact(n_steps == 4, "timedep_discretize_steps");
        set result += 4096;

        // Step 14: Step size (time_span=1, num_steps=5)
        let dt = q_timedep_step_size(1.0, 5);
        Fact(AbsD(dt - 0.2) < 1e-10, "timedep_step_size");
        set result += 8192;

        // Step 15: Evolution verification (start=0, end=1, h_max=2)
        let evolve_ok = q_timedep_verify_evolution(0.0, 1.0, 2.0) ? 1 | 0;
        Fact(evolve_ok == 1, "timedep_verify_evolution");
        set result += 16384;

        // Step 16: Optimal order (prec=0.01, time_span=1)
        let best_order = q_timedep_optimal_order(0.01, 1.0);
        Fact(best_order == 1, "timedep_optimal_order");
        set result += 32768;

        return result;
    }
}
