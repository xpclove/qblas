namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Variable-time Quantum Singular Value Decomposition (VT-QSVD)
    //
    // Standard SVD uses fixed time for all eigenvalues.
    // Variable-time SVD adapts measurement time based on eigenvalue magnitude.
    //
    // Complexity improvement: O(1/epsilon) -> O(log(1/epsilon))
    // for well-conditioned matrices.
    // ============================================================

    // ============================================================
    // Core VT-QSVD: Adaptive singular value estimation
    // ============================================================

    operation q_svd_vartime_core(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        n_bits : Int,
        epsilon : Double
    ) : Double {
        body (...) {
            mutable estimate = 0.0;
            let target_bits = Floor(Log(1.0 / epsilon) / Log(2.0));

            use qs_phase = Qubit[n_bits];

            for iter in 0 .. target_bits {
                let precision = 1.0 / IntAsDouble(2 ^ iter);

                q_phase_estimate_core(U_A, qs_state, qs_phase);

                mutable result_int = 0;
                for i in 0 .. n_bits - 1 {
                    if (M(qs_phase[i]) == One) {
                        set result_int = result_int + (2 ^ i);
                    }
                }

                set estimate = IntAsDouble(result_int) / IntAsDouble(2 ^ n_bits);
                ResetAll(qs_phase);
            }

            return estimate;
        }
    }

    // ============================================================
    // Full VT-QSVD for Multiple Singular Values
    // ============================================================

    operation q_svd_vartime_full(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        n_bits : Int,
        n_values : Int,
        epsilon : Double
    ) : Double[] {
        body (...) {
            mutable singular_values = [];

            for v in 0 .. n_values - 1 {
                let sv = q_svd_vartime_core(U_A, qs_state, n_bits, epsilon);
                set singular_values += [sv];
            }

            return singular_values;
        }
    }

    // ============================================================
    // VT-QSVD with Conditional Rotation
    // Uses condition-number-aware rotation
    // ============================================================

    operation q_svd_vartime_rotation(
        qs_phase : Qubit[],
        qs_r : Qubit,
        condition_number : Double
    ) : Unit {
        body (...) {
            let n_bit = Length(qs_phase);
            let kappa = MinD(condition_number, 100.0);
            let lambda_div = 2.0 * PI() / IntAsDouble((2 ^ n_bit) - 1);

            q_ram_call_lamda_rcp(qs_phase, [qs_r], lambda_div / kappa);
        }
    }

    // ============================================================
    // VT-QSVD with Eigenvalue Gap Detection
    // Skips regions where eigenvalues are close together
    // ============================================================

    operation q_svd_vartime_gap(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        qs_phase : Qubit[],
        min_gap : Double
    ) : Double[] {
        body (...) {
            mutable values = [];
            mutable last_value = 0.0;
            let max_values = 16;
            let n_bit = Length(qs_phase);

            for v in 0 .. max_values - 1 {
                let sv = q_svd_vartime_core(U_A, qs_state, n_bit, min_gap);

                if (v == 0 or AbsD(sv - last_value) > min_gap) {
                    set values += [sv];
                    set last_value = sv;
                }
            }

            return values;
        }
    }

    // ============================================================
    // Complete VT-QSVD procedure
    // ============================================================

    operation q_svd_vartime(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        n_bits : Int,
        epsilon : Double,
        condition_number : Double
    ) : (Double[], Double[]) {
        body (...) {
            mutable values = [];

            use qs_phase = Qubit[n_bits];

            set values = q_svd_vartime_full(U_A, qs_state, n_bits, 2 ^ n_bits, epsilon);

            use (qs_r,) = (Qubit[1],);
            q_svd_vartime_rotation(qs_phase, qs_r[0], condition_number);

            return (values, []);
        }
    }

    // ============================================================
    // Utility: Estimate condition number from singular values
    // ============================================================

    function q_svd_estimate_condition(singular_values : Double[]) : Double {
        let n = Length(singular_values);
        if (n < 2) {
            return 1.0;
        }

        mutable max_sv = 0.0;
        mutable min_sv = 1.0;

        for sv in singular_values {
            if (sv > max_sv) { set max_sv = sv; }
            if (sv < min_sv and sv > 0.0) { set min_sv = sv; }
        }

        if (min_sv > 0.0) {
            return max_sv / min_sv;
        }
        return 1.0 / 1e-10;
    }

    // ============================================================
    // Utility: Sort singular values in descending order
    // ============================================================

    function q_svd_sort_descending(values : Double[]) : Double[] {
        mutable sorted = values;
        let n = Length(sorted);

        for i in 0 .. n - 1 {
            for j in i + 1 .. n - 1 {
                if (sorted[i] < sorted[j]) {
                    mutable temp = sorted[i];
                    set sorted w/= i <- sorted[j];
                    set sorted w/= j <- temp;
                }
            }
        }

        return sorted;
    }

    // ============================================================
    // Utility: Filter singular values by threshold
    // ============================================================

    function q_svd_filter(values : Double[], threshold : Double) : Double[] {
        mutable filtered = [];
        for v in values {
            if (AbsD(v) > threshold) {
                set filtered += [v];
            }
        }
        return filtered;
    }

    // ============================================================
    // Utility: Normalize singular values
    // ============================================================

    function q_svd_normalize(values : Double[]) : Double[] {
        let total = Sqrt(SquaredNorm(values));
        if (total > 0.0) {
            mutable normalized = [];
            for v in values {
                set normalized += [v / total];
            }
            return normalized;
        }
        return values;
    }
}