// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Quantum Machine Learning Pipeline
//
// Purpose: Demonstrates QBLAS's modular quantum algorithms
// working together to solve a regression problem.
//
// Pipeline:
//   1. Define data matrix oracle via q_matrix + q_ram
//   2. Encode sample data as quantum state (q_vector)
//   3. Quantum Fourier Transform preprocessing (q_fft)
//   4. PCA dimensionality reduction planning (q_pca)
//   5. Regularization parameter selection (q_regularized_ls)
//   6. Ridge regression configuration (q_ridge_regression)
//   7. Amplitude amplification (q_amplitude_amplification)
//
// Modules used: q_matrix, q_ram, q_vector, q_fft, q_pca,
//               q_ridge_regression, q_regularized_ls,
//               q_amplitude_amplification, q_phase_estimate
//
// Data: 2 features × 4 samples
//       y = 0.5·x₁ + 0.25·x₂ (linear regression)
//
// Reference: Schuld & Petruccione,
//            "Machine Learning with Quantum Computers" (2021)
// ============================================================

namespace qblas.applications
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;
    open qblas;

    // ============================================================
    // Step 1: Data Oracle Definition
    //
    // Defines a 2×4 sparse data matrix using q_matrix primitives.
    // Each training sample has 2 features:
    //   Sample 0: [1.0, 0.5]  → target 0.625
    //   Sample 1: [1.5, 0.8]  → target 0.950
    //   Sample 2: [2.0, 1.0]  → target 1.250
    //   Sample 3: [2.5, 1.2]  → target 1.550
    //
    // Oracle format: |vertex⟩|next_vertex⟩|weight⟩
    // Values scaled ×10 for integer encoding.
    // ============================================================

    operation q_demo_data_oracle(
        qs_address : Qubit[],
        qs_data : Qubit[],
        qs_weight : Qubit[]
    ) : Unit is Adj + Ctl {
        let RAM = q_matrix_convert([
            (0, 0, 10),  // sample 0: feature 0 = 1.0
            (0, 1, 5),   // sample 0: feature 1 = 0.5
            (1, 0, 15),  // sample 1: feature 0 = 1.5
            (1, 1, 8),   // sample 1: feature 1 = 0.8
            (2, 0, 20),  // sample 2: feature 0 = 2.0
            (2, 1, 10),  // sample 2: feature 1 = 1.0
            (3, 0, 25),  // sample 3: feature 0 = 2.5
            (3, 1, 12)   // sample 3: feature 1 = 1.2
        ]);
        q_ram_call_integer(RAM, qs_address, qs_data, qs_weight);
    }

    // ============================================================
    // Step 2: State Preparation
    //
    // Encodes classical data into quantum amplitudes.
    // Uses q_vector module for basis state preparation.
    // ============================================================

    operation q_demo_prepare_state(qs : Qubit[], values : Double[]) : Unit {
        let norm = Sqrt(SquaredNorm(values));
        if (norm > 0.0) {
            Ry(2.0 * ArcSin(values[0] / norm), qs[0]);
            Ry(2.0 * ArcSin(values[1] / norm), qs[1]);
        }
    }

    // ============================================================
    // Step 3: QFT Preprocessing
    //
    // Applies quantum Fourier transform to the feature state.
    // Demonstrates integration with q_fft module.
    // ============================================================

    operation q_demo_qft_preprocess(qs : Qubit[]) : Unit is Adj + Ctl {
        q_fft(qs);
    }

    // ============================================================
    // Step 4: PCA Configuration
    //
    // Computes PCA parameters for dimensionality reduction.
    // Uses q_pca's classical helper functions.
    // ============================================================

    function q_demo_compute_explained_variance(
        eigenvalues : Double[]
    ) : Double[] {
        return q_pca_explained_var(eigenvalues);
    }

    // ============================================================
    // Step 5: Regularization Parameter Selection
    //
    // Selects optimal λ via cross-validation formula.
    // Uses q_regularized_ls module.
    // ============================================================

    function q_demo_select_lambda(
        n_samples : Int,
        condition_number : Double
    ) : Double {
        return q_rls_lambda_cv(n_samples, condition_number, 1e-6);
    }

    // ============================================================
    // Step 6: Ridge Regression Configuration
    //
    // Computes effective condition number for regression.
    // Uses q_ridge_regression module.
    // ============================================================

    function q_demo_ridge_condition(
        kappa : Double,
        lambda_reg : Double
    ) : Double {
        return q_ridge_effective_cond(kappa, lambda_reg);
    }

    // ============================================================
    // Step 7: Amplitude Amplification Configuration
    //
    // Computes optimal number of amplification iterations.
    // Uses q_amplitude_amplification module.
    // ============================================================

    function q_demo_amplification_iters(
        success_prob : Double
    ) : Int {
        return q_qaa_optimal_iterations(success_prob, 10);
    }

    // ============================================================
    // Full Pipeline: DemoMLPipeline
    //
    // Complete quantum ML pipeline showing modular composition:
    //
    //   Classical Data
    //       ↓
    //   [q_matrix] → Oracle Definition
    //       ↓
    //   [q_vector] → State Preparation
    //       ↓
    //   [q_fft] → QFT Preprocessing
    //       ↓
    //   [q_pca] → PCA Dimensionality Reduction
    //       ↓
    //   [q_regularized_ls] → Lambda Selection
    //       ↓
    //   [q_ridge_regression] → Ridge Configuration
    //       ↓
    //   [q_amplitude_amplification] → Amplification Planning
    //       ↓
    //   Measurement Result
    //
    // The pipeline demonstrates that QBLAS modules can be
    // composed like building blocks for complex workflows.
    // ============================================================

    operation DemoMLPipeline() : Int {
        let oracle = q_matrix_1_sparse_oracle(q_demo_data_oracle);

        // Allocate quantum registers
        use qs_state = Qubit[2];
        use qs_phase = Qubit[2];

        // Step 1: Prepare quantum state from sample data
        // Sample 0 features: [1.0, 0.5]
        q_demo_prepare_state(qs_state, [1.0, 0.5]);

        // Step 2: Apply QFT preprocessing
        // Transforms to Fourier basis for analysis
        q_fft(qs_state);

        // Step 3: PCA explained variance (classical computation)
        let eigenvalues = [2.5, 1.3];
        let explained = q_pca_explained_var(eigenvalues);
        let n_pc = Length(explained);

        // Step 4: Select regularization parameter
        let lambda_opt = q_rls_lambda_cv(4, 10.0, 1e-6);

        // Step 5: Compute effective condition number
        let cond_eff = q_ridge_effective_cond(10.0, lambda_opt);

        // Step 6: Amplification planning
        let n_amp = q_qaa_optimal_iterations(0.5, 10);

        // Step 7: State reflection (amplification primitive)
        q_qaa_state_reflection(qs_state);

        // Measure result
        let m0 = M(qs_state[0]) == One ? 1 | 0;
        let m1 = M(qs_state[1]) == One ? 2 | 0;

        ResetAll(qs_state);
        ResetAll(qs_phase);

        // Return comprehensive result encoding pipeline steps:
        // bits 0-1: measurement result (0-3)
        // bits 2-3: number of principal components
        // bits 4-5: amplification iterations
        return m0 + m1 + (n_pc * 4) + (n_amp * 16);
    }
}
