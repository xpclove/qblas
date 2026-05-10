namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    operation q_qsvt_polynomial_transform(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        poly_coeffs : Double[],
        precision : Double
    ) : Unit {
        body (...) {
            oracle(qs_data, qs_ancilla);

            let poly_degree = Length(poly_coeffs);
            for (idx in 0 .. poly_degree - 1) {
                let coef = poly_coeffs[idx];
                if (AbsD(coef) > precision) {
                    let angle = 2.0 * ArcSin(AbsD(coef));
                    Ry(angle, qs_ancilla[0]);
                }
            }

            (Adjoint oracle)(qs_data, qs_ancilla);
        }
    }

    operation q_qsvt_inverse(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        condition_number : Double,
        precision : Double
    ) : Unit {
        body (...) {
            let epsilon = 1.0 / condition_number;
            let degree = Floor(Log(1.0 / precision) / Log(2.0 / epsilon));

            mutable coeffs = [];
            for (k in 0 .. degree) {
                mutable ck = 2.0 / IntAsDouble(k + 1);
                set coeffs += [ck];
            }

            q_qsvt_polynomial_transform(oracle, qs_data, qs_ancilla, coeffs, precision);
        }
    }

    operation q_qsvt_matrix_power(
        oracle : ((Qubit[], Qubit[]) => Unit is Adj + Ctl),
        qs_data : Qubit[],
        qs_ancilla : Qubit[],
        power : Int
    ) : Unit {
        body (...) {
            if (power > 0) {
                for (p in 0 .. power - 1) {
                    oracle(qs_data, qs_ancilla);
                }
            } elif (power < 0) {
                for (p in 0 .. -power - 1) {
                    (Adjoint oracle)(qs_data, qs_ancilla);
                }
            }
        }
    }

    operation q_qsvt_apply_diagonal(
        diag : Double[],
        qs : Qubit[]
    ) : Unit {
        body (...) {
            let n = Length(diag);
            let norm = Sqrt(SquaredNorm(diag));

            if (norm < 1e-10) {
                return ();
            }

            for (i in 0 .. n - 1) {
                let angle = 2.0 * ArcSin(AbsD(diag[i]) / norm);
                Ry(angle, qs[i]);
            }
        }
    }

    operation q_qsvt_amplitude_encode(
        data : Double[],
        qs : Qubit[]
    ) : Unit {
        body (...) {
            let n = Length(data);
            let norm = Sqrt(SquaredNorm(data));

            if (norm < 1e-10) {
                return ();
            }

            for (i in 0 .. n - 1) {
                let amp = data[i] / norm;
                if (AbsD(amp) > 1e-10) {
                    let angle = 2.0 * ArcSin(AbsD(amp));
                    Ry(angle, qs[i]);
                }
            }
        }
    }

    function q_qsvt_normalize_vector(v : Double[]) : Double[] {
        let n = Length(v);
        let norm = Sqrt(SquaredNorm(v));

        if (norm < 1e-10) {
            return v;
        }

        mutable result = [];
        for (x in v) {
            set result += [x / norm];
        }
        return result;
    }

    function q_qsvt_estimate_norm(matrix : Double[][], precision : Double) : Double {
        mutable max_row_norm = 0.0;

        for (row in matrix) {
            let row_norm = Sqrt(SquaredNorm(row));
            if (row_norm > max_row_norm) {
                set max_row_norm = row_norm;
            }
        }

        return max_row_norm;
    }

    function q_qsvt_check_dims(n_data : Int, n_ancilla : Int) : Bool {
        let n_bits = Floor(Log(IntAsDouble(n_data)) / Log(2.0)) + 1;
        return n_ancilla >= n_bits;
    }

    operation q_qsvt_with_qpe(
        U_A : (Int, Qubit[]) => Unit is Adj + Ctl,
        qs_state : Qubit[],
        qs_phase : Qubit[],
        poly_coeffs : Double[]
    ) : Unit {
        body (...) {
            q_phase_estimate_core(U_A, qs_state, qs_phase);

            for (coef in poly_coeffs) {
                if (AbsD(coef) > 1e-10) {
                    let angle = 2.0 * ArcSin(AbsD(coef));
                    Ry(angle, qs_phase[0]);
                }
            }

            (Adjoint q_phase_estimate_core)(U_A, qs_state, qs_phase);
        }
    }

    function q_qsvt_sqrt_coeffs(degree : Int) : Double[] {
        mutable coeffs = [];
        for (k in 0 .. degree) {
            mutable ck = 1.0;
            set coeffs += [ck];
        }
        return coeffs;
    }
}