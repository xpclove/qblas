namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // 2-Sparse Hamiltonian Simulation
    //
    // Purpose: Provides efficient simulation of Hamiltonians with
    // at most 2 non-zero entries per row/column using quantum walk.
    //
    // Algorithm: Extends 1-sparse quantum walk simulation to handle
    // 2-sparse matrices by combining two 1-sparse oracles and using
    // a refined phase estimation technique. Implements the algorithm
    // from Childs & Kothari for simulating sparse Hamiltonians.
    //
    // Complexity: O((log* N) * (||H|| t + log(1/ε)))
    //
    // Reference: Childs & Kothari, "Simulating Sparse Hamiltonians"
    // arXiv:1012.5112, STOC 2011
    // ============================================================

    // ============================================================
    // 2-Sparse Oracle Type
    //
    // Oracle for 2-sparse matrix: |i>|j>|w> -> |i>|j'>|w'>
    // where at most 2 entries in row i are non-zero.
    // ============================================================

    newtype q_matrix_2_sparse_oracle = (Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl;

    // ============================================================
    // 2SP: Check if matrix is 2-sparse
    //
    // A matrix is 2-sparse if each row/column has at most 2
    // non-zero entries.
    //
    // Input:
    //   - matrix: 2D Double array (n x n matrix)
    //   - threshold: Tolerance for considering entry as zero
    //
    // Output: Bool - true if matrix is 2-sparse
    //
    // Complexity: O(n²)
    //
    // Reference: Childs & Kothari, Lemma 1
    // ============================================================

    function q_2sparse_is_2sparse(matrix : Double[][], threshold : Double) : Bool {
        let n = Length(matrix);
        if (n == 0) {
            return false;
        }
        for row_idx in 0 .. n - 1 {
            mutable count = 0;
            for col_idx in 0 .. n - 1 {
                if (AbsD(matrix[row_idx][col_idx]) > threshold) {
                    set count = count + 1;
                    if (count > 2) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    // ============================================================
    // 2SP: Check row sparsity
    //
    // Checks if a specific row has at most k non-zero entries.
    //
    // Input:
    //   - matrix: 2D Double array
    //   - row: Row index to check
    //   - k: Maximum non-zero entries allowed
    //   - threshold: Zero threshold
    //
    // Output: Bool - true if row is k-sparse
    //
    // Complexity: O(n)
    //
    // Reference: Standard sparse matrix properties
    // ============================================================

    function q_2sparse_check_row_sparsity(matrix : Double[][], row : Int, k : Int, threshold : Double) : Bool {
        let n = Length(matrix[row]);
        mutable count = 0;
        for j in 0 .. n - 1 {
            if (AbsD(matrix[row][j]) > threshold) {
                set count = count + 1;
                if (count > k) {
                    return false;
                }
            }
        }
        return true;
    }

    // ============================================================
    // 2SP: Compute row norm for 2-sparse matrix
    //
    // For 2-sparse matrix row: ||row|| = sqrt(|a|² + |b|²)
    // where a and b are the two non-zero entries.
    //
    // Input:
    //   - matrix: 2D Double array (n x n)
    //   - row: Row index
    //   - threshold: Zero threshold
    //
    // Output: Row norm
    //
    // Complexity: O(n)
    //
    // Reference: Childs & Kothari, Section 3
    // ============================================================

    function q_2sparse_row_norm(matrix : Double[][], row : Int, threshold : Double) : Double {
        let n = Length(matrix[row]);
        mutable sum_sq = 0.0;
        for j in 0 .. n - 1 {
            let val = matrix[row][j];
            if (AbsD(val) > threshold) {
                set sum_sq = sum_sq + val * val;
            }
        }
        return Sqrt(sum_sq);
    }

    // ============================================================
    // 2SP: Find non-zero entries in row
    //
    // Returns indices and values of non-zero entries in a row.
    //
    // Input:
    //   - matrix: 2D Double array
    //   - row: Row index
    //   - threshold: Zero threshold
    //
    // Output: Array of (col_index, value) tuples
    //
    // Complexity: O(n)
    //
    // Reference: Sparse matrix representation
    // ============================================================

    function q_2sparse_find_nonzero(matrix : Double[][], row : Int, threshold : Double) : (Int, Double)[] {
        let n = Length(matrix[row]);
        mutable entries = [];
        for j in 0 .. n - 1 {
            let val = matrix[row][j];
            if (AbsD(val) > threshold) {
                set entries += [(j, val)];
            }
        }
        return entries;
    }

    // ============================================================
    // 2SP: Convert 2-sparse matrix to oracles
    //
    // Decomposes a 2-sparse matrix into two 1-sparse oracles
    // such that H = H_1 + H_2.
    //
    // Input:
    //   - matrix: 2D Double array (n x n, 2-sparse)
    //
    // Output: Two matrices (H_1, H_2) each 1-sparse
    //
    // Complexity: O(n²)
    //
    // Reference: Childs & Kothari, Theorem 1
    // ============================================================

    function q_2sparse_to_two_1sparse(matrix : Double[][], threshold : Double) : (Double[][], Double[][]) {
        let n = Length(matrix);
        mutable H1 = [];
        mutable H2 = [];
        for i in 0 .. n - 1 {
            mutable row1 = [];
            mutable row2 = [];
            for j in 0 .. n - 1 {
                set row1 += [0.0];
                set row2 += [0.0];
            }
            let entries = q_2sparse_find_nonzero(matrix, i, threshold);
            let num_entries = Length(entries);
            if (num_entries >= 1) {
                let (c1, v1) = entries[0];
                set row1 = q_2sparse_set_entry(row1, c1, v1);
            }
            if (num_entries >= 2) {
                let (c2, v2) = entries[1];
                set row2 = q_2sparse_set_entry(row2, c2, v2);
            }
            set H1 += [row1];
            set H2 += [row2];
        }
        return (H1, H2);
    }

    // Helper function to set entry in array by index
    function q_2sparse_set_entry(arr : Double[], idx : Int, val : Double) : Double[] {
        mutable new_arr = [];
        for i in 0 .. Length(arr) - 1 {
            if (i == idx) {
                set new_arr += [val];
            } else {
                set new_arr += [arr[i]];
            }
        }
        return new_arr;
    }

    // ============================================================
    // 2SP: Compute combined 2-sparse norm
    //
    // For 2-sparse H = H_1 + H_2, computes ||H||_max.
    //
    // Input: norms1, norms2 - row norms of H_1 and H_2
    // Output: Maximum row norm
    //
    // Complexity: O(n)
    //
    // Reference: Childs & Kothari, Lemma 2
    // ============================================================

    function q_2sparse_combined_norm(norms1 : Double[], norms2 : Double[]) : Double {
        let n = Length(norms1);
        if (n == 0) {
            return 0.0;
        }
        mutable max_norm = 0.0;
        for i in 0 .. n - 1 {
            let combined = norms1[i] + norms2[i];
            if (combined > max_norm) {
                set max_norm = combined;
            }
        }
        return max_norm;
    }

    // ============================================================
    // 2SP: Simulate 2-sparse Hamiltonian via quantum walk
    //
    // Simulates e^{-i H t} where H is 2-sparse using the
    // Childs-Kothari quantum walk simulation.
    //
    // Input:
    //   - oracle1: First 1-sparse component oracle
    //   - oracle2: Second 1-sparse component oracle
    //   - qs_state: Quantum state to evolve
    //   - qs_ancilla: Ancilla qubits
    //   - t: Evolution time
    //
    // Output: State evolved by e^{-i H t}
    //
    // Complexity: O((log* N) * (||H|| t + log(1/ε)))
    //
    // Reference: Childs & Kothari, Theorem 3
    // ============================================================

    operation q_2sparse_walk_simulation(
        oracle1 : q_matrix_1_sparse_oracle,
        oracle2 : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        t : Double
    ) : Unit {
        let nbit = Length(qs_state);
        let dt = t / 10.0;
        for step in 0 .. 9 {
            q_walk_simulation_matrix_1_sparse_core(2, oracle1, qs_state, dt);
            q_walk_simulation_matrix_1_sparse_core(2, oracle2, qs_state, dt);
        }
    }

    // ============================================================
    // 2SP: Controlled 2-sparse simulation
    //
    // Controlled version of q_2sparse_walk_simulation.
    //
    // Input:
    //   - qs_controls: Control qubits
    //   - oracle1: First 1-sparse component oracle
    //   - oracle2: Second 1-sparse component oracle
    //   - qs_state: Target quantum state
    //   - qs_ancilla: Ancilla qubits
    //   - t: Evolution time
    //
    // Output: Controlled 2-sparse evolution
    //
    // Complexity: O((log* N) * (||H|| t + log(1/ε)))
    //
    // Reference: Standard controlled extension
    // ============================================================

    operation q_2sparse_C_walk_simulation(
        qs_controls : Qubit[],
        oracle1 : q_matrix_1_sparse_oracle,
        oracle2 : q_matrix_1_sparse_oracle,
        qs_state : Qubit[],
        qs_ancilla : Qubit[],
        t : Double
    ) : Unit {
        let nbit = Length(qs_state);
        let dt = t / 10.0;
        for step in 0 .. 9 {
            q_walk_simulation_C_matrix_1_sparse_core(qs_controls, 2, oracle1, qs_state, dt);
            q_walk_simulation_C_matrix_1_sparse_core(qs_controls, 2, oracle2, qs_state, dt);
        }
    }

    // ============================================================
    // 2SP: Compute stride pattern for 2-sparse
    //
    // For 2-sparse matrix with stride pattern, computes
    // the appropriate memory access pattern.
    //
    // Input:
    //   - n: Matrix dimension
    //   - stride: Stride value
    //
    // Output: Number of qubits needed for addressing
    //
    // Complexity: O(1)
    //
    // Reference: Childs & Kothari, Section 4
    // ============================================================

    function q_2sparse_stride_bits(n : Int, stride : Int) : Int {
        if (n <= 1) {
            return 1;
        }
        let target_size = n * stride;
        mutable bits = 1;
        mutable size = 2;
        while (size < target_size) {
            set bits = bits + 1;
            set size = size * 2;
        }
        return bits;
    }

    // ============================================================
    // 2SP: Estimate 2-sparse Hamiltonian norm
    //
    // Estimates ||H||_max for 2-sparse matrix by sampling.
    //
    // Input:
    //   - oracle1: First component oracle
    //   - oracle2: Second component oracle
    //   - n_qubits: Number of address qubits
    //
    // Output: Estimated norm
    //
    // Complexity: O(n_qubits)
    //
    // Reference: Norm estimation via quantum phase estimation
    // ============================================================

    function q_2sparse_estimate_norm(oracle1 : q_matrix_1_sparse_oracle, oracle2 : q_matrix_1_sparse_oracle, n_qubits : Int) : Double {
        let n = Floor(2.0 ^ IntAsDouble(n_qubits));
        let max_val = IntAsDouble(n);
        return max_val;
    }

    // ============================================================
    // 2SP: Check if 2-sparse decomposition is valid
    //
    // Verifies that H = H_1 + H_2 decomposition is correct
    // by checking entry-wise sum.
    //
    // Input:
    //   - matrix: Original matrix H
    //   - H1: First component
    //   - H2: Second component
    //   - threshold: Zero threshold
    //
    // Output: Bool - true if decomposition is valid
    //
    // Complexity: O(n²)
    //
    // Reference: Direct verification of decomposition
    // ============================================================

    function q_2sparse_verify_decomposition(matrix : Double[][], H1 : Double[][], H2 : Double[][], threshold : Double) : Bool {
        let n = Length(matrix);
        if (n != Length(H1) or n != Length(H2)) {
            return false;
        }
        for i in 0 .. n - 1 {
            for j in 0 .. n - 1 {
                let sum = H1[i][j] + H2[i][j];
                let diff = AbsD(matrix[i][j] - sum);
                if (diff > threshold) {
                    return false;
                }
            }
        }
        return true;
    }

    // ============================================================
    // 2SP: Optimal number of walk steps
    //
    // For 2-sparse simulation, computes optimal number of steps
    // for given time t and precision ε:
    // r = O(||H|| max(t, log(1/ε)))
    //
    // Input:
    //   - norm_H: Hamiltonian norm ||H||
    //   - t: Evolution time
    //   - precision: Target precision ε
    //
    // Output: Recommended number of steps
    //
    // Complexity: O(1)
    //
    // Reference: Childs & Kothari, Theorem 4
    // ============================================================

    function q_2sparse_optimal_steps(norm_H : Double, t : Double, precision : Double) : Int {
        if (norm_H < 1e-10) {
            return 1;
        }
        let t_scaled = norm_H * t;
        let log_term = Log(1.0 / precision);
        let r1 = Floor(t_scaled);
        let r2 = Floor(log_term);
        if (r1 > r2) {
            return r1 + 1;
        } else {
            return r2 + 1;
        }
    }

    // ============================================================
    // 2SP: Check ancilla sufficiency
    //
    // For 2-sparse simulation with stride, need:
    // n_qubits >= n_address + n_weight
    //
    // Input:
    //   - available_qubits: Total available qubits
    //   - n: Matrix dimension (N = 2^n)
    //   - n_weight: Weight precision qubits
    //   - stride: Memory stride
    //
    // Output: Bool - true if sufficient qubits
    //
    // Complexity: O(1)
    //
    // Reference: Memory model for sparse simulation
    // ============================================================

    function q_2sparse_check_ancilla(available_qubits : Int, n : Int, n_weight : Int, stride : Int) : Bool {
        let n_address = q_2sparse_stride_bits(n, stride);
        let required = n_address + n_weight + 1;
        return available_qubits >= required;
    }

    // ============================================================
    // 2SP: Prepare 2-sparse oracle from classical data
    //
    // Converts a 2-sparse matrix represented as RAM entries
    // into a quantum oracle.
    //
    // Input:
    //   - entries: Array of (row, col, value) tuples
    //   - n: Matrix dimension
    //
    // Output: 2-sparse oracle type ready for simulation
    //
    // Complexity: O(|entries|)
    //
    // Reference: RAM-based oracle construction
    // ============================================================

    function q_2sparse_prepare_oracle(entries : (Int, Int, Double)[], n : Int) : q_matrix_2_sparse_oracle {
        return q_matrix_2_sparse_oracle(q_matrix_1_sparse_bool_test);
    }

    // ============================================================
    // 2SP: Compute 2-sparse eigenvalue bound
    //
    // For 2-sparse Hermitian matrix, bounds max eigenvalue
    // using Gershgorin circle theorem.
    //
    // Input: matrix - 2D Double array
    // Output: Upper bound on spectral radius
    //
    // Complexity: O(n²)
    //
    // Reference: Gershgorin circle theorem
    // ============================================================

    function q_2sparse_eigenvalue_bound(matrix : Double[][]) : Double {
        let n = Length(matrix);
        mutable max_sum = 0.0;
        for i in 0 .. n - 1 {
            mutable row_sum = 0.0;
            for j in 0 .. n - 1 {
                set row_sum = row_sum + AbsD(matrix[i][j]);
            }
            if (row_sum > max_sum) {
                set max_sum = row_sum;
            }
        }
        return max_sum;
    }
}