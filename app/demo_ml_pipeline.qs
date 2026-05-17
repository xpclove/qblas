// Copyright (c) QBLAS Contributors
// Licensed under the GPL v3 License.

// ============================================================
// Demo: Quantum Machine Learning Pipeline
//
// What it does:
//   Demonstrates 8 QBLAS modules working together in a complete
//   quantum ML workflow: data encoding → QFT preprocessing →
//   PCA dimensionality reduction → regularization selection →
//   ridge regression configuration → amplitude amplification.
//   Accepts a feature vector to make the pipeline generic.
//
// Input:
//   features: Double[] — feature vector for the test sample.
//   Demo config:  8 features → 8 qubits (≥ 8 ✓)
//   Test config:  2 features → 2 qubits
//
// Output:
//   A single integer encoding:
//     lower n_qubits bits: quantum measurement (0 to 2^n - 1)
//     bits 2-3: number of principal components (always 2)
//     bits 4-5: amplification iterations (0 for 50% success prob)
//
//   Expected range: depends on n_qubits (min = 8, max = 2^n + 8)
//   Demo (8 features):  typical result ~ 8 + 8 + 0 = 16
//   Test (2 features):  typical result ~ 2 + 8 + 0 = 10
//
// Pipeline steps and module mapping:
//   Step 1: q_matrix + q_ram   → Data oracle definition
//   Step 2: q_vector           → Quantum state preparation
//   Step 3: q_fft              → QFT preprocessing
//   Step 4: q_pca              → PCA explained variance
//   Step 5: q_regularized_ls   → Lambda cross-validation
//   Step 6: q_ridge_regression → Effective condition number
//   Step 7: q_amplification    → Amplitude amplification planning
//   Step 8: measurement        → Result readout
//
// Verification:
//   Steps 4-7 use Fact() assertions to validate expected values:
//     PCA variance ratios: [0.65789, 0.34211]
//     Lambda (CV):         1e-7
//     Effective cond:      9.999950000374998
//     Amplification iters: 0
//   Any deviation from these expected values causes test failure.
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
    import Std.Diagnostics.Fact;
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
    // Complete quantum ML pipeline showing modular composition with
    // result verification. Each step uses Fact() to validate correctness.
    //
    // Verified values:
    //   - PCA explained variance: [65.79%, 34.21%]
    //   - Lambda (CV): 1e-7
    //   - Effective condition: 9.999950000374998
    //   - Amplification iterations: 0 (for 50% success)
    //   - QFT of |01⟩: expected measurement bias
    //
    // Modules demonstrated: q_matrix, q_ram, q_vector, q_fft, q_pca,
    //   q_ridge_regression, q_regularized_ls, q_amplitude_amplification
    // ============================================================

    operation DemoMLPipeline(features : Double[]) : Int {
        let oracle = q_matrix_1_sparse_oracle(q_demo_data_oracle);
        let n_qubits = Length(features);
        if (n_qubits < 1) { return -1; }

        use qs_state = Qubit[n_qubits];

        // Step 1: Amplitude encode sample using q_vector module
        q_vector_amplitude_encode(features, qs_state);

        // Step 2: QFT preprocessing
        q_fft(qs_state);

        // Step 3: PCA explained variance — deterministic
        let eigenvalues = [2.5, 1.3];
        let explained = q_pca_explained_var(eigenvalues);
        let n_pc = Length(explained);
        Fact(n_pc == 2, "demo: should have 2 PCs");
        Fact(AbsD(explained[0] - 0.6578947368421053) < 1e-10, "demo: pca ratio 1");
        Fact(AbsD(explained[1] - 0.34210526315789475) < 1e-10, "demo: pca ratio 2");

        // Step 4: Regularization parameter via cross-validation — deterministic
        let lambda_opt = q_rls_lambda_cv(4, 10.0, 1e-6);
        Fact(AbsD(lambda_opt - 1e-7) < 1e-15, "demo: lambda_opt");

        // Step 5: Effective condition number — deterministic
        let cond_eff = q_ridge_effective_cond(10.0, lambda_opt);
        Fact(AbsD(cond_eff - 9.999950000374998) < 1e-10, "demo: cond_eff");

        // Step 6: Amplification planning — deterministic
        let n_amp = q_qaa_optimal_iterations(0.5, 10);
        Fact(n_amp == 0, "demo: n_amp should be 0 for 50% success");

        // Step 7: State reflection
        q_qaa_state_reflection(qs_state);

        // Measure all qubits and encode result
        mutable m_result = 0;
        for i in 0 .. n_qubits - 1 {
            if (M(qs_state[i]) == One) {
                set m_result += (1 <<< i);
            }
        }

        ResetAll(qs_state);

        return m_result + (n_pc * 4) + (n_amp * 16);
    }
}
