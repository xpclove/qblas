namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

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