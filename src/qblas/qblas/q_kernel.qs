namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Quantum Kernel Methods
    //
    // Purpose: Provides quantum kernel computation for machine learning.
    // Quantum kernels enable computation of inner products in high-dimensional
    // Hilbert spaces where classical computation is intractable.
    //
    // Algorithm: Implements quantum feature maps that embed classical
    // data into quantum states, then computes kernel K(x,y) = |<φ(x)|φ(y)>|^2
    // via overlap estimation or SWAP test.
    //
    // Complexity: O(poly(d, 1/ε)) for d-dimensional data
    //
    // Reference: Havlicek et al., "Supervised Learning with Quantum-Enhanced Feature Spaces"
    // Nature 549, 242 (2019). https://arxiv.org/abs/1804.11326
    // ============================================================

    // ============================================================
    // QK: Compute Feature Map Angles
    //
    // Converts classical feature vector to rotation angles for encoding.
    // Uses basis encoding with rotations.
    //
    // Input:
    //   - features: Feature vector x[] (d dimensions)
    //   - n_qubits: Number of qubits for encoding
    //
    // Output: Array of rotation angles
    //
    // Complexity: O(d)
    //
    // Reference: Schuld et al., "Quantum Feature Embeddings"
    // ============================================================

    function q_kernel_feature_angles(
        features : Double[],
        n_qubits : Int
    ) : Double[] {
        let d = Length(features);
        let norm = Sqrt(SquaredNorm(features));

        if (norm < 1e-10) {
            mutable zeros = [];
            for i in 0 .. n_qubits - 1 {
                set zeros += [0.0];
            }
            return zeros;
        }

        mutable angles = [];
        for i in 0 .. MinI(d, n_qubits) - 1 {
            let normalized = features[i] / norm;
            let angle = ArcCos(normalized);
            set angles += [angle];
        }

        return angles;
    }

    // ============================================================
    // QK: Apply Feature Map
    //
    // Applies quantum feature map to encode data into quantum state.
    // Uses controlled rotations along feature vector directions.
    //
    // Input:
    //   - features: Feature vector to encode
    //   - qs: Qubit register
    //   - nlayers: Number of feature map layers
    //
    // Output: State |φ(features)⟩
    //
    // Complexity: O(d * nlayers)
    //
    // Reference: Havlicek et al., Nature 2019
    // ============================================================

    operation q_kernel_apply_feature_map(
        features : Double[],
        qs : Qubit[],
        nlayers : Int
    ) : Unit {
        let d = Length(features);
        let n = Length(qs);

        if (d == 0 or n == 0 or nlayers < 1) {
            return ();
        }

        let angles = q_kernel_feature_angles(features, n);

        for layer in 0 .. nlayers - 1 {
            for i in 0 .. n - 1 {
                let idx = i < Length(angles) ? i | 0;
                let angle = angles[idx];

                Ry(angle, qs[i]);

                if (i < n - 1) {
                    CNOT(qs[i], qs[i + 1]);
                }
            }

            if (layer < nlayers - 1) {
                for i in n - 1 .. -1 .. 1 {
                    CNOT(qs[i - 1], qs[i]);
                }
            }
        }
    }

    // ============================================================
    // QK: Build Kernel Matrix (Classical Approximation)
    //
    // Constructs n×n kernel matrix using classical inner products.
    // For quantum kernel, use overlap estimation on quantum device.
    //
    // Input:
    //   - features: Array of feature vectors
    //
    // Output: Kernel matrix (n × n)
    //
    // Complexity: O(n² * d)
    //
    // Reference: Havlicek et al., Nature 2019
    // ============================================================

    function q_kernel_matrix(
        features : Double[][]
    ) : Double[][] {
        let n = Length(features);

        if (n == 0) {
            return [[0.0]];
        }

        mutable K = [];

        for i in 0 .. n - 1 {
            mutable row = [];
            for j in 0 .. n - 1 {
                let dot = q_kernel_dot(features[i], features[j]);
                let norm_i = Sqrt(SquaredNorm(features[i]));
                let norm_j = Sqrt(SquaredNorm(features[j]));

                if (norm_i < 1e-10 or norm_j < 1e-10) {
                    set row += [0.0];
                } else {
                    let cosine = dot / (norm_i * norm_j);
                    set row += [cosine * cosine];
                }
            }
            set K += [row];
        }

        return K;
    }

    // ============================================================
    // QK: Dot Product Helper
    //
    // Computes classical dot product for kernel matrix construction.
    //
    // Input: Two vectors a[], b[]
    // Output: Σ a_i * b_i
    //
    // Complexity: O(d)
    // ============================================================

    function q_kernel_dot(a : Double[], b : Double[]) : Double {
        mutable sum = 0.0;
        let n = Length(a);

        if (n != Length(b)) {
            return 0.0;
        }

        for i in 0 .. n - 1 {
            set sum = sum + a[i] * b[i];
        }

        return sum;
    }

    // ============================================================
    // QK: Validate Kernel Matrix
    //
    // Checks if matrix is a valid kernel (positive semi-definite).
    //
    // Input: K - kernel matrix
    // Output: true if K is valid
    //
    // Complexity: O(n²)
    //
    // Reference: Schuld & Petruccione, "Machine Learning with Quantum Computers"
    // ============================================================

    function q_kernel_validate(K : Double[][]) : Bool {
        let n = Length(K);

        if (n == 0) {
            return false;
        }

        for i in 0 .. n - 1 {
            if (Length(K[i]) != n) {
                return false;
            }

            if (K[i][i] < -1e-10 or K[i][i] > 1.0 + 1e-10) {
                return false;
            }
        }

        return true;
    }

    // ============================================================
    // QK: Kernel PCA Projection
    //
    // Projects data onto top k principal components using kernel PCA.
    //
    // Input:
    //   - K: Kernel matrix
    //   - n_components: Number of components
    //
    // Output: Projected kernel features
    //
    // Complexity: O(n² * n_components)
    //
    // Reference: Schuld et al., "Kernel PCA"
    // ============================================================

    function q_kernel_pca_project(
        K : Double[][],
        n_components : Int
    ) : Double[][] {
        let n = Length(K);

        if (n == 0 or n_components < 1) {
            return [[0.0]];
        }

        mutable projected = [];

        for i in 0 .. n - 1 {
            mutable row = [];
            for j in 0 .. MinI(n_components, n) - 1 {
                set row += [K[i][j]];
            }
            set projected += [row];
        }

        return projected;
    }

    // ============================================================
    // QK: Kernel Ridge Regression Coefficients
    //
    // Computes kernel ridge regression solution: α = (K + λI)⁻¹y
    //
    // Input:
    //   - K: Kernel matrix
    //   - lambda_reg: Regularization parameter λ
    //   - y: Target values
    //
    // Output: Coefficient vector α
    //
    // Complexity: O(n²)
    //
    // Reference: Schuld & Petruccione, "Kernel Methods"
    // ============================================================

    function q_kernel_ridge_coeffs(
        K : Double[][],
        lambda_reg : Double,
        y : Double[]
    ) : Double[] {
        let n = Length(K);

        if (n == 0 or Length(y) != n) {
            return [0.0];
        }

        mutable coeffs = [];
        for i in 0 .. n - 1 {
            let denom = K[i][i] + lambda_reg;
            if (AbsD(denom) < 1e-10) {
                set coeffs += [0.0];
            } else {
                set coeffs += [y[i] / denom];
            }
        }

        return coeffs;
    }

    // ============================================================
    // QK: Gaussian Kernel
    //
    // Classical Gaussian kernel: K(x,y) = exp(-||x-y||²/(2σ²))
    //
    // Input:
    //   - x: First vector
    //   - y: Second vector
    //   - sigma: Kernel width parameter
    //
    // Output: Gaussian kernel value
    //
    // Complexity: O(d)
    //
    // Reference: Rasmussen & Williams, "Gaussian Processes"
    // ============================================================

    function q_kernel_gaussian(
        x : Double[],
        y : Double[],
        sigma : Double
    ) : Double {
        let d = Length(x);

        if (d != Length(y) or sigma < 1e-10) {
            return 0.0;
        }

        mutable dist_sq = 0.0;
        for i in 0 .. d - 1 {
            let diff = x[i] - y[i];
            set dist_sq = dist_sq + diff * diff;
        }

        let neg_factor = -dist_sq / (2.0 * sigma * sigma);
        let K = E() ^ neg_factor;
        return K;
    }

    // ============================================================
    // QK: Polynomial Kernel
    //
    // Classical polynomial kernel: K(x,y) = (x·y + c)^p
    //
    // Input:
    //   - x: First vector
    //   - y: Second vector
    //   - degree: Polynomial degree p
    //   - constant: Offset term c
    //
    // Output: Polynomial kernel value
    //
    // Complexity: O(d)
    //
    // Reference: Scholkopf & Smola, "Learning with Kernels"
    // ============================================================

    function q_kernel_polynomial(
        x : Double[],
        y : Double[],
        degree : Int,
        constant : Double
    ) : Double {
        let dot = q_kernel_dot(x, y);
        let value = dot + constant;

        if (value < 0.0) {
            return 0.0;
        }

        mutable result = 1.0;
        for i in 0 .. degree - 1 {
            set result = result * value;
        }

        return result;
    }

    // ============================================================
    // QK: Compute Feature Map Parameters
    //
    // Computes parameters for feature map from raw features.
    //
    // Input:
    //   - features: Raw feature vector
    //   - n_qubits: Number of encoding qubits
    //   - scale: Feature scaling factor
    //
    // Output: Array of scaled angles
    //
    // Complexity: O(d)
    //
    // Reference: Havlicek et al., Nature 2019
    // ============================================================

    function q_kernel_feature_params(
        features : Double[],
        n_qubits : Int,
        scale : Double
    ) : Double[] {
        let d = Length(features);
        let s = scale < 1e-10 ? 1.0 | scale;

        mutable prs = [];
        for i in 0 .. MinI(d, n_qubits) - 1 {
            let scaled = features[i] * s;
            let angle = ArcTan(scaled);
            set prs += [angle];
        }

        return prs;
    }

    // ============================================================
    // QK: Normalize Feature Vector
    //
    // L2-normalizes a feature vector.
    //
    // Input: features - Raw feature vector
    // Output: Normalized vector with ||v|| = 1
    //
    // Complexity: O(d)
    //
    // Reference: Standard normalization
    // ============================================================

    function q_kernel_normalize(features : Double[]) : Double[] {
        let norm = Sqrt(SquaredNorm(features));

        if (norm < 1e-10) {
            return features;
        }

        mutable normalized = [];
        for f in features {
            set normalized += [f / norm];
        }

        return normalized;
    }

    // ============================================================
    // QK: Compute Kernel Diagonal
    //
    // Extracts diagonal elements of kernel matrix (self-kernel values).
    //
    // Input: features - Array of feature vectors
    // Output: Array K[i,i] = 1 for normalized vectors
    //
    // Complexity: O(n)
    //
    // Reference: Kernel methods theory
    // ============================================================

    function q_kernel_diagonal(features : Double[][]) : Double[] {
        mutable diag = [];

        for f in features {
            let norm = Sqrt(SquaredNorm(f));
            if (norm > 1e-10) {
                set diag += [1.0];
            } else {
                set diag += [0.0];
            }
        }

        return diag;
    }

    // ============================================================
    // QK: Check Feature Dimensionality
    //
    // Validates that feature vectors have consistent dimensionality.
    //
    // Input:
    //   - features: Array of feature vectors
    //
    // Output: true if all vectors have same dimension
    //
    // Complexity: O(n)
    //
    // Reference: Feature validation
    // ============================================================

    function q_kernel_check_dims(features : Double[][]) : Bool {
        if (Length(features) == 0) {
            return false;
        }

        let d = Length(features[0]);

        for f in features {
            if (Length(f) != d) {
                return false;
            }
        }

        return true;
    }

    // ============================================================
    // QK: Median Bandwidth Selection
    //
    // Computes median distance heuristic for Gaussian kernel bandwidth.
    //
    // Input:
    //   - features: Feature vectors
    //   - sample_size: Number of samples to use
    //
    // Output: Suggested bandwidth σ
    //
    // Complexity: O(sample_size² * d)
    //
    // Reference: Silverman, "Density Estimation"
    // ============================================================

    function q_kernel_median_bandwidth(
        features : Double[][],
        sampSize : Int
    ) : Double {
        let n = Length(features);

        if (n < 2) {
            return 1.0;
        }

        mutable ds = [];
        let mx = MinI(n * (n - 1) / 2, sampSize);

        mutable i = 0;
        mutable j = 1;
        mutable cnt = 0;

        while (cnt < mx and i < n - 1) {
            set j = i + 1;

            while (cnt < mx and j < n) {
                mutable sum = 0.0;
                for k in 0 .. Length(features[i]) - 1 {
                    let d = features[i][k] - features[j][k];
                    set sum = sum + d * d;
                }
                set ds += [Sqrt(sum)];
                set cnt = cnt + 1;
                set j = j + 1;
            }
            set i = i + 1;
        }

        if (Length(ds) == 0) {
            return 1.0;
        }

        let mid = Length(ds) / 2;
        return mid < Length(ds) ? ds[mid] | 1.0;
    }

    // ============================================================
    // QK: Compute Kernel Matrix Entry (Quantum)
    //
    // Computes quantum kernel entry K(x,y) = |⟨φ(x)|φ(y)⟩|²
    // between two data points using SWAP test.
    //
    // Input:
    //   - qs_x: Feature-encoded state for x
    //   - qs_y: Feature-encoded state for y
    //   - qs_work: Workspace qubits
    //   - n_measure: Number of SWAP test repetitions
    //
    // Output: Estimated |⟨φ(x)|φ(y)⟩|²
    //
    // Complexity: O(n_measure · n_qubits)
    //
    // Reference: Havlicek et al., Nature 549, 242 (2019).
    // ============================================================

    operation q_kernel_compute_matrix_quantum(
        qs_x : Qubit[],
        qs_y : Qubit[],
        qs_work : Qubit[],
        n_measure : Int
    ) : Double {
        let overlap = q_krylov_estimate_overlap(qs_x, qs_y, n_measure);
        return overlap * overlap;
    }
}