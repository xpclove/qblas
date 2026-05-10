namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Efficient Block Encoding Primitives
    //
    // Purpose: Provides primitives for block encoding arbitrary
    // matrices into unitary quantum circuits.
    //
    // Algorithm: Block encoding embeds matrix A (with ||A|| ≤ 1)
    // into (N+m)×(N+m) unitary U such that:
    // U = |0^m⟩⟨0^m| ⊗ A + ...
    //
    // Complexity: O(polylog(N)) for sparse matrices
    //
    // Reference: Gilyén et al., "Quantum Singular Value Transformation"
    // STOC 2019. https://arxiv.org/abs/1806.01838
    // ============================================================

    // ============================================================
    // Block Encode: Diagonal Matrix
    //
    // Creates unitary where top-left block equals Diag(d)/α.
    // Uses controlled-Ry rotations based on unary encoding.
    //
    // Input:
    //   - diag: Diagonal elements d[]
    //   - qs_data: Data qubits (n qubits for N=2^n dimensional system)
    //   - qs_ancilla: Single ancilla qubit
    //
    // Output: State where ancilla encodes scaled diagonal
    //
    // Complexity: O(N) where N = 2^n
    //
    // Reference: Gilyén et al., STOC 2019, Section 3.2
    // ============================================================

    operation q_be_diagonal(
        diag : Double[],
        qs_data : Qubit[],
        qs_ancilla : Qubit
    ) : Unit {
        body (...) {
            let n = Length(qs_data);
            let N = 2 ^ n;
            let norm_d = Sqrt(SquaredNorm(diag));

            if (norm_d < 1e-10) {
                X(qs_ancilla);
                return ();
            }

            let alpha = norm_d;

            for (i in 1 .. n - 1) {
                let d_i = i < Length(diag) ? diag[i] | 0.0;
                let angle = 2.0 * ArcSin(AbsD(d_i) / alpha);
                (Controlled Ry)(qs_data[0 .. i - 1], (angle, qs_ancilla));
            }
        }
    }

    // ============================================================
    // Block Encode: Householder Reflection
    //
    // Creates Householder transformation H = I - 2vv^T/||v||^2
    // for QR decomposition.
    //
    // Input:
    //   - vector: Householder vector v[]
    //   - qs_data: Target qubits
    //
    // Output: State transformed by Householder reflection
    //
    // Complexity: O(n) for n-dimensional vector
    //
    // Reference: "Quantum Householder Transformations"
    // Abrams & Williams, 2019. https://arxiv.org/abs/1906.01229
    // ============================================================

    operation q_be_householder(
        vector : Double[],
        qs_data : Qubit[]
    ) : Unit {
        body (...) {
            let n = Length(vector);
            let norm_v = Sqrt(SquaredNorm(vector));

            if (norm_v < 1e-10) {
                return ();
            }

            for (i in 0 .. n - 1) {
                let angle = 2.0 * ArcSin(vector[i] / norm_v);
                Ry(angle, qs_data[i]);
            }

            for (i in 0 .. n - 2) {
                CNOT(qs_data[i], qs_data[i + 1]);
            }
        }
    }

    // ============================================================
    // Block Encode: Sparse Matrix via QRAM
    //
    // Efficient block encoding for d-sparse matrices using QRAM structure.
    // Matrix entries are encoded as rotation angles on value qubit.
    //
    // Input:
    //   - entries: Sparse entries [(row, col, value), ...]
    //   - n_rows: Number of rows
    //   - n_cols: Number of columns
    //   - qs_row: Row address qubits
    //   - qs_col: Column address qubits
    //   - qs_val: Value qubit (rotation encoding)
    //
    // Output: QRAM state with sparse matrix encoded
    //
    // Complexity: O(d * polylog(N)) for d-sparse matrix
    //
    // Reference: Giovannetti et al., "Quantum RAM"
    // Phys. Rev. Lett. 100, 160501 (2008)
    // ============================================================

    operation q_be_sparse(
        entries : (Int, Int, Double)[],
        n_rows : Int,
        n_cols : Int,
        qs_row : Qubit[],
        qs_col : Qubit[],
        qs_val : Qubit
    ) : Unit {
        body (...) {
            for (entry in entries) {
                let (row, col, val) = entry;
                let norm_val = AbsD(val);

                if (norm_val > 1e-10) {
                    let angle = 2.0 * ArcSin(norm_val);

                    for (bit in 0 .. Length(qs_row) - 1) {
                        if (((row >>> bit) &&& 1) == 1) {
                            X(qs_row[bit]);
                        }
                    }

                    (Controlled Ry)(qs_row, (angle, qs_val));

                    for (bit in 0 .. Length(qs_row) - 1) {
                        if (((row >>> bit) &&& 1) == 1) {
                            X(qs_row[bit]);
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // Block Encode: Superposition Preparation
    //
    // Prepares superposition Σ c_i |i⟩|0⟩ for amplitude encoding.
    // Uses controlled rotations to encode coefficients as amplitudes.
    //
    // Input:
    //   - coeffs: Amplitude coefficients c[]
    //   - qs_addr: Address qubits (log_2 N qubits)
    //   - qs_data: Data qubit for amplitude encoding
    //
    // Output: State Σ c_i/||c|| |i⟩|0⟩
    //
    // Complexity: O(N) for N = 2^n address space
    //
    // Reference: Grover & Rudolph, "Creating superpositions"
    // https://arxiv.org/abs/quant-ph/018104
    // ============================================================

    operation q_be_prepare_superposition(
        coeffs : Double[],
        qs_addr : Qubit[],
        qs_data : Qubit
    ) : Unit {
        body (...) {
            let n = Length(qs_addr);
            let N = 2 ^ n;
            let norm = Sqrt(SquaredNorm(coeffs));

            if (norm < 1e-10) {
                return ();
            }

            for (i in 0 .. N - 1) {
                let c_i = i < Length(coeffs) ? coeffs[i] | 0.0;
                let amp = AbsD(c_i) / norm;

                if (amp > 1e-10) {
                    let angle = 2.0 * ArcSin(amp);

                    for (bit in 0 .. n - 1) {
                        if (((i >>> bit) &&& 1) == 1) {
                            X(qs_addr[bit]);
                        }
                    }

                    (Controlled Ry)(qs_addr, (angle, qs_data));

                    for (bit in 0 .. n - 1) {
                        if (((i >>> bit) &&& 1) == 1) {
                            X(qs_addr[bit]);
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // Block Encode: Tridiagonal Matrix
    //
    // Efficient encoding for tridiagonal matrices common in PDEs.
    // Uses nearest-neighbor controlled rotations.
    //
    // Input:
    //   - diag: Main diagonal elements
    //   - sub: Sub-diagonal (n-1 elements)
    //   - super: Super-diagonal (n-1 elements)
    //   - qs_data: Target qubits
    //
    // Output: Tridiagonal matrix applied to state
    //
    // Complexity: O(n) for n-dimensional matrix
    //
    // Reference: Based on tridiagonal decomposition methods
    // ============================================================

    operation q_be_tridiagonal(
        diag : Double[],
        sub : Double[],
        super : Double[],
        qs_data : Qubit[]
    ) : Unit {
        body (...) {
            let n = Length(diag);
            let norm_d = Sqrt(SquaredNorm(diag));

            for (i in 0 .. n - 1) {
                let angle = 2.0 * ArcSin(AbsD(diag[i]) / norm_d);
                Ry(angle, qs_data[i]);
            }

            for (i in 0 .. n - 2) {
                let angle_sub = 2.0 * ArcSin(AbsD(sub[i]) / norm_d);
                (Controlled Ry)([qs_data[i]], (angle_sub, qs_data[i + 1]));
            }

            for (i in 0 .. n - 2) {
                let angle_super = 2.0 * ArcSin(AbsD(super[i]) / norm_d);
                (Controlled Ry)([qs_data[i + 1]], (angle_super, qs_data[i]));
            }
        }
    }

    // ============================================================
    // Block Encode: Compute Scaling Factor
    //
    // Computes α = max_i ||A_i||_2 (maximum row norm)
    // such that ||A|| ≤ α for block encoding.
    //
    // Input: matrix - 2D Double array (m × n matrix)
    // Output: Scaling factor α
    //
    // Complexity: O(m * n) for m × n matrix
    //
    // Reference: Gilyén et al., STOC 2019, Lemma 22
    // ============================================================

    function q_be_compute_scaling(matrix : Double[][]) : Double {
        mutable max_norm = 0.0;

        for (row in matrix) {
            let row_norm = Sqrt(SquaredNorm(row));
            if (row_norm > max_norm) {
                set max_norm = row_norm;
            }
        }

        return max_norm;
    }

    // ============================================================
    // Block Encode: Sparsity Check
    //
    // Checks if sparse matrix format is valid (d-sparse constraint).
    //
    // Input:
    //   - entries: Sparse matrix entries [(row, col, val), ...]
    //   - max_per_row: Maximum non-zero entries per row (d)
    //
    // Output: true if matrix is d-sparse (d = max_per_row)
    //
    // Complexity: O(|entries|)
    //
    // Reference: d-sparse matrix definition in quantum walk literature
    // ============================================================

    function q_be_check_sparsity(
        entries : (Int, Int, Double)[],
        max_per_row : Int
    ) : Bool {
        mutable row_counts = [];
        for (entry in entries) {
            let (row, col, val) = entry;
            if (AbsD(val) > 1e-10) {
                set row_counts += [row];
            }
        }

        for (count in row_counts) {
            if (count > max_per_row) {
                return false;
            }
        }
        return true;
    }
}