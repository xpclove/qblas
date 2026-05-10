namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Singular Value Decomposition (SVD) and Eigenvalue Decomposition (EVD)
    // Uses QPE for matrix eigendecomposition
    // ============================================================

    // Lambda reciprocal rotation for SVD (same as HHL)
    operation q_md_rotation_lamda_rcp(qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // Matrix decomposition core using QPE
    operation q_md_core(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            q_phase_estimate_core(U_A, qs_u, qs_phase);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // SVD: density matrix simulation yields eigenvalues = singular values
    operation q_svd(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            q_md_core(U_A, qs_u, qs_phase, qs_r);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }

    // EVD: QPE yields matrix eigenvalues
    // qs_u: eigenstate, qs_phase: eigenvalue, qs_r: rotation qubit
    operation q_evd(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        body {
            q_md_core(U_A, qs_u, qs_phase, qs_r);
        }
        adjoint auto;
        controlled auto;
        controlled adjoint auto;
    }
}