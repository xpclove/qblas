namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Math.*;
    import Std.Convert.*;

    function q_com_real_nbit_float() : Int {
        // Set the number of bits for real floating-point representation
        let nbit_float = 2;
        return nbit_float;
    }

    // Reverse all qubit orderings in the array
    operation q_com_swap_all(qs : Qubit[]) : Unit is Adj + Ctl {
        let nbit = Length(qs);
        for i in 0 .. (nbit - 1) / 2 {
            if (i != nbit - 1 - i) {
                SWAP(qs[i], qs[nbit - 1 - i]);
            }
        }
    }

    function q_com_convert_tuples_to_complexpolars(data : (Double, Double)[]) : ComplexPolar[] {
        // DoubleTuple[] to ComplexPolar[]
        let n = Length(data);
        mutable newdata = [ComplexPolar(0.0, 0.0), size = n];
        for i in 0 .. n - 1 {
            let (r, im) = data[i];
            set newdata w/= i <- ComplexPolar(r, im);
        }
        return newdata;
    }

    function q_com_convert_tupless_to_complexpolarss(data : (Double, Double)[][]) : ComplexPolar[][] {
        // DoubleTuple[][] to ComplexPolar[][]
        let n1 = Length(data);
        let n2 = Length(data[0]);
        mutable newdata = [[ComplexPolar(0.0, 0.0), size = n2], size = n1];
        for i in 0 .. n1 - 1 {
            mutable newdata_i = [ComplexPolar(0.0, 0.0), size = n2];
            for j in 0 .. n2 - 1 {
                let (r, im) = data[i][j];
                set newdata_i w/= j <- ComplexPolar(r, im);
            }
            set newdata w/= i <- newdata_i;
        }
        return newdata;
    }

    function q_com_convert_doubles_to_complexpolars(data : Double[]) : ComplexPolar[] {
        // Double[] to ComplexPolar[] - real values have zero imaginary part
        let n = Length(data);
        mutable newdata = [ComplexPolar(0.0, 0.0), size = n];
        for i in 0 .. n - 1 {
            set newdata w/= i <- ComplexPolar(data[i], 0.0);
        }
        return newdata;
    }

    function q_com_convert_ints_to_complexpolars(data : Int[]) : ComplexPolar[] {
        // Int[] to ComplexPolar[]
        let n = Length(data);
        mutable newdata = [ComplexPolar(0.0, 0.0), size = n];
        for i in 0 .. n - 1 {
            set newdata w/= i <- ComplexPolar(IntAsDouble(data[i]), 0.0);
        }
        return newdata;
    }

    function q_com_convert_doubless_to_complexpolarss(data : Double[][]) : ComplexPolar[][] {
        // Double[][] to ComplexPolar[][]
        let n1 = Length(data);
        let n2 = Length(data[0]);
        mutable newdata = [[ComplexPolar(0.0, 0.0), size = n2], size = n1];
        for i in 0 .. n1 - 1 {
            mutable newdata_i = [ComplexPolar(0.0, 0.0), size = n2];
            for j in 0 .. n2 - 1 {
                set newdata_i w/= j <- ComplexPolar(data[i][j], 0.0);
            }
            set newdata w/= i <- newdata_i;
        }
        return newdata;
    }

    function q_com_convert_doubles_to_angles(data : Double[]) : Int[] {
        // Double to rotation angle for rotation
        let n = Length(data);
        mutable newdata = [0, size = n];
        for i in 0 .. n - 1 {
            set newdata w/= i <- Floor(2.0 * ArcSin(data[i]) / PI() * 128.0);
        }
        return newdata;
    }

    function q_com_convert_tuples_to_angles(data : (Double, Double)[]) : (Int, Int)[] {
        // Polar (double, double) to rotation (angle, angle) for rotation
        let n = Length(data);
        mutable newdata = [(0, 0), size = n];
        for i in 0 .. n - 1 {
            let (data_r, data_i) = data[i];
            let angle_r = Floor(2.0 * ArcSin(data_r) / PI() * 128.0);
            let angle_i = Floor(data_i / PI() * 128.0);
            set newdata w/= i <- (angle_r, angle_i);
        }
        return newdata;
    }

    function q_com_array_join(qa : Qubit[], qb : Qubit[]) : Qubit[] {
        return qa + qb;
    }

    operation q_com_apply(op : (Qubit => Unit is Adj + Ctl), qs : Qubit[]) : Unit {
        for i in 0 .. Length(qs) - 1 {
            op(qs[i]);
        }
    }
}