namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Tensor and Kronecker Product
    //
    // Purpose: Provides tensor product and Kronecker product
    // operations for quantum linear algebra. Essential for
    // multi-qubit systems and tensor network operations.
    //
    // Algorithm: Computes A ⊗ B where (A ⊗ B)[i₁i₂, j₁j₂] = A[i₁,j₁]B[i₂,j₂]
    //
    // Complexity: O(m₁*m₂*n₁*n₂) for m₁×n₁ and m₂×n₂ matrices
    //
    // Reference: Horn & Johnson, "Matrix Analysis"
    // ============================================================

    // ============================================================
    // TK: Kronecker Product
    //
    // Computes A ⊗ B (Kronecker product/tensor product).
    //
    // Input:
    //   - A: m₁×n₁ matrix
    //   - B: m₂×n₂ matrix
    //
    // Output: (m₁*m₂)×(n₁*n₂) matrix
    //
    // Complexity: O(m₁*m₂*n₁*n₂)
    // ============================================================

    function q_tk_kronecker(A : Double[][], B : Double[][]) : Double[][] {
        let m1 = Length(A);
        let n1 = Length(A[0]);
        let m2 = Length(B);
        let n2 = Length(B[0]);

        if (m1 == 0 or n1 == 0 or m2 == 0 or n2 == 0) {
            return [[0.0]];
        }

        mutable result = [];

        for (i1 in 0 .. m1 - 1) {
            for (i2 in 0 .. m2 - 1) {
                mutable row = [];
                for (j1 in 0 .. n1 - 1) {
                    for (j2 in 0 .. n2 - 1) {
                        set row += [A[i1][j1] * B[i2][j2]];
                    }
                }
                set result += [row];
            }
        }

        return result;
    }

    // ============================================================
    // TK: Tensor Power
    //
    // Computes A⊗A⊗...⊗A (k times).
    //
    // Input:
    //   - A: n×n matrix
    //   - k: Number of times
    //
    // Output: nᵏ×nᵏ matrix
    //
    // Complexity: O(n²ᵏ)
    // ============================================================

    function q_tk_tensor_power(A : Double[][], k : Int) : Double[][] {
        let n = Length(A);

        if (n == 0 or k < 1) {
            return [[0.0]];
        }

        if (k == 1) {
            return A;
        }

        mutable result = A;
        for (idx in 1 .. k - 1) {
            set result = q_tk_kronecker(result, A);
        }

        return result;
    }

    // ============================================================
    // TK: Vector Kronecker
    //
    // Computes v ⊗ w for vectors.
    //
    // Input:
    //   - v: m-dimensional vector
    //   - w: n-dimensional vector
    //
    // Output: (m*n)-dimensional vector
    //
    // Complexity: O(mn)
    // ============================================================

    function q_tk_vector_kronecker(v : Double[], w : Double[]) : Double[] {
        let m = Length(v);
        let n = Length(w);

        if (m == 0 or n == 0) {
            return [0.0];
        }

        mutable result = [];

        for (i in 0 .. m - 1) {
            for (j in 0 .. n - 1) {
                set result += [v[i] * w[j]];
            }
        }

        return result;
    }

    // ============================================================
    // TK: Check Dimensions
    //
    // Validates dimensions for Kronecker product.
    //
    // Input:
    //   - A: m₁×n₁ matrix
    //   - B: m₂×n₂ matrix
    //
    // Output: true if all dimensions > 0
    //
    // Complexity: O(1)
    // ============================================================

    function q_tk_check_dims(A : Double[][], B : Double[][]) : Bool {
        let m1 = Length(A);
        let n1 = Length(A[0]);
        let m2 = Length(B);
        let n2 = Length(B[0]);

        return m1 > 0 and n1 > 0 and m2 > 0 and n2 > 0;
    }

    // ============================================================
    // TK: Khatri-Rao Product
    //
    // Computes column-wise Kronecker: A ⊙ B where columns are
    // Kronechered element-wise.
    //
    // Input:
    //   - A: m₁×n matrix
    //   - B: m₂×n matrix
    //
    // Output: (m₁*m₂)×n matrix
    //
    // Complexity: O(m₁*m₂*n)
    // ============================================================

    function q_tk_khatri_rao(A : Double[][], B : Double[][]) : Double[][] {
        let m1 = Length(A);
        let m2 = Length(B);
        let n = Length(A[0]);

        if (n != Length(B[0]) or m1 == 0 or m2 == 0) {
            return [[0.0]];
        }

        mutable result = [];

        for (i1 in 0 .. m1 - 1) {
            for (i2 in 0 .. m2 - 1) {
                mutable row = [];
                for (j in 0 .. n - 1) {
                    set row += [A[i1][j] * B[i2][j]];
                }
                set result += [row];
            }
        }

        return result;
    }

    // ============================================================
    // TK: Hadamard Product (Element-wise)
    //
    // Computes A ∘ B (element-wise multiplication).
    //
    // Input:
    //   - A: m×n matrix
    //   - B: m×n matrix
    //
    // Output: m×n matrix
    //
    // Complexity: O(mn)
    // ============================================================

    function q_tk_hadamard(A : Double[][], B : Double[][]) : Double[][] {
        let m = Length(A);

        if (m == 0 or Length(A[0]) != Length(B[0]) or Length(B) != m) {
            return [[0.0]];
        }

        let n = Length(A[0]);
        mutable result = [];

        for (i in 0 .. m - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                set row += [A[i][j] * B[i][j]];
            }
            set result += [row];
        }

        return result;
    }

    // ============================================================
    // TK: Kronecker Sum
    //
    // Computes A ⊕ B = A ⊗ I + I ⊗ B (for square matrices).
    //
    // Input:
    //   - A: n×n matrix
    //   - B: m×m matrix
    //
    // Output: (nm)×(nm) Kronecker sum
    //
    // Complexity: O(n²m²)
    // ============================================================

    function q_tk_kronecker_sum(A : Double[][], B : Double[][]) : Double[][] {
        let n = Length(A);
        let m = Length(B);

        if (n == 0 or m == 0 or Length(A[0]) != n or Length(B[0]) != m) {
            return [[0.0]];
        }

        let kron1 = q_tk_kronecker(A, q_tk_identity(m));
        let kron2 = q_tk_kronecker(q_tk_identity(n), B);

        let m1 = Length(kron1);
        let n1 = Length(kron1[0]);
        mutable result = [];

        for (i in 0 .. m1 - 1) {
            mutable row = [];
            for (j in 0 .. n1 - 1) {
                set row += [kron1[i][j] + kron2[i][j]];
            }
            set result += [row];
        }

        return result;
    }

    // ============================================================
    // TK: Identity Matrix
    //
    // Creates n×n identity matrix.
    //
    // Input: n - dimension
    //
    // Output: n×n identity matrix
    //
    // Complexity: O(n²)
    // ============================================================

    function q_tk_identity(n : Int) : Double[][] {
        if (n < 1) {
            return [[0.0]];
        }

        mutable IdMat = [];

        for (i in 0 .. n - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                set row += [i == j ? 1.0 | 0.0];
            }
            set IdMat += [row];
        }

        return IdMat;
    }

    // ============================================================
    // TK: Permutation Matrix for Vec
    //
    // Creates permutation matrix for vec(A⊗B) = vec(B⊗A) transformation.
    //
    // Input:
    //   - m: Rows of A
    //   - n: Cols of A
    //   - p: Rows of B
    //   - q: Cols of B
    //
    // Output: Permutation matrix P
    //
    // Complexity: O((mp)*(nq))
    // ============================================================

    function q_tk_vec_permutation(m : Int, n : Int, p : Int, q : Int) : Double[][] {
        let rows = m * p;
        let cols = n * q;

        if (rows == 0 or cols == 0) {
            return [[0.0]];
        }

        mutable P = [];

        for (i in 0 .. m - 1) {
            for (j in 0 .. p - 1) {
                for (k in 0 .. n - 1) {
                    for (l in 0 .. q - 1) {
                        let row_idx = i * p + j;
                        let col_idx = k * q + l;
                        mutable row = [];
                        for (c in 0 .. cols - 1) {
                            set row += [c == col_idx ? 1.0 | 0.0];
                        }
                        set P += [row];
                    }
                }
            }
        }

        return P;
    }

    // ============================================================
    // TK: Verify Kronecker Properties
    //
    // Verifies basic properties of Kronecker product.
    //
    // Input:
    //   - A: m₁×n₁ matrix
    //   - B: m₂×n₂ matrix
    //
    // Output: true if dimensions are valid
    //
    // Complexity: O(1)
    // ============================================================

    function q_tk_verify(A : Double[][], B : Double[][]) : Bool {
        let m1 = Length(A);
        let n1 = Length(A[0]);
        let m2 = Length(B);
        let n2 = Length(B[0]);

        if (m1 == 0 or n1 == 0 or m2 == 0 or n2 == 0) {
            return false;
        }

        let result = q_tk_kronecker(A, B);
        return Length(result) == m1 * m2 and Length(result[0]) == n1 * n2;
    }

    // ============================================================
    // TK: Scalar Kronecker
    //
    // Computes (αA) ⊗ B = α(A ⊗ B) = A ⊗ (αB)
    //
    // Input:
    //   - A: m×n matrix
    //   - B: p×q matrix
    //   - alpha: Scalar
    //
    // Output: α(A ⊗ B)
    //
    // Complexity: O(mn pq)
    // ============================================================

    function q_tk_scalar_kronecker(
        A : Double[][],
        B : Double[][],
        alpha : Double
    ) : Double[][] {
        let kron = q_tk_kronecker(A, B);
        let m = Length(kron);

        if (m == 0) {
            return [[0.0]];
        }

        let n = Length(kron[0]);
        mutable result = [];

        for (i in 0 .. m - 1) {
            mutable row = [];
            for (j in 0 .. n - 1) {
                set row += [alpha * kron[i][j]];
            }
            set result += [row];
        }

        return result;
    }

    // ============================================================
    // TK: Trace of Kronecker
    //
    // Computes tr(A ⊗ B) = tr(A) * tr(B)
    //
    // Input:
    //   - A: n×n matrix
    //   - B: m×m matrix
    //
    // Output: tr(A ⊗ B)
    //
    // Complexity: O(n + m)
    // ============================================================

    function q_tk_trace(A : Double[][], B : Double[][]) : Double {
        let n = Length(A);
        let m = Length(B);

        if (n == 0 or m == 0) {
            return 0.0;
        }

        mutable trA = 0.0;
        mutable trB = 0.0;

        for (i in 0 .. n - 1) {
            set trA = trA + A[i][i];
        }

        for (i in 0 .. m - 1) {
            set trB = trB + B[i][i];
        }

        return trA * trB;
    }

    // ============================================================
    // TK: Determinant of Kronecker
    //
    // Computes det(A ⊗ B) = det(A)^m * det(B)^n for n×n, m×m matrices.
    //
    // Input:
    //   - A: n×n matrix
    //   - B: m×m matrix
    //
    // Output: det(A ⊗ B)
    //
    // Complexity: O(n³ + m³)
    // ============================================================

    function q_tk_determinant(A : Double[][], B : Double[][]) : Double {
        let n = Length(A);
        let m = Length(B);

        if (n == 0 or m == 0) {
            return 0.0;
        }

        mutable detA = 1.0;
        mutable detB = 1.0;

        for (i in 0 .. n - 1) {
            set detA = detA * A[i][i];
        }

        for (i in 0 .. m - 1) {
            set detB = detB * B[i][i];
        }

        mutable powerA = 1.0;
        for (i in 0 .. m - 1) {
            set powerA = powerA * detA;
        }

        mutable powerB = 1.0;
        for (i in 0 .. n - 1) {
            set powerB = powerB * detB;
        }

        return powerA * powerB;
    }

    // ============================================================
    // TK: Block Diagonal Kronecker
    //
    // Creates block diagonal matrix with Kronecker products.
    //
    // Input: Array of matrices
    //
    // Output: Block diagonal matrix
    //
    // Complexity: O(sum of squares)
    // ============================================================

    function q_tk_block_diag(matrices : Double[][][]) : Double[][] {
        let k = Length(matrices);

        if (k == 0) {
            return [[0.0]];
        }

        mutable result = [];

        for (idx in 0 .. k - 1) {
            let mat = matrices[idx];
            let m = Length(mat);
            let n = Length(mat[0]);

            for (i in 0 .. m - 1) {
                mutable row = [];
                for (j in 0 .. n - 1) {
                    set row += [mat[i][j]];
                }
                set result += [row];
            }
        }

        return result;
    }

    // ============================================================
    // TK: Apply Kronecker Product to Composite State
    //
    // Applies A⊗B to composite quantum state.
    // Applies A to qs_state_a and B to qs_state_b independently.
    //
    // Input:
    //   - oracle_A: 1-sparse oracle for A
    //   - oracle_B: 1-sparse oracle for B
    //   - qs_state_a: First subsystem qubits
    //   - qs_state_b: Second subsystem qubits
    //   - qs_work: Workspace qubits
    //   - time: Evolution time
    //
    // Complexity: O(poly(log(1/ε)))
    //
    // Reference: Horn & Johnson, "Matrix Analysis"
    // ============================================================

    operation q_kronecker_apply_state(
        oracle_A : q_matrix_1_sparse_oracle,
        oracle_B : q_matrix_1_sparse_oracle,
        qs_state_a : Qubit[],
        qs_state_b : Qubit[],
        qs_work : Qubit[],
        time : Double
    ) : Unit {
        body {
            q_gemv(oracle_A, qs_state_a, qs_work, time);
            q_gemv(oracle_B, qs_state_b, qs_work, time);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}
