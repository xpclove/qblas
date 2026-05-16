namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Singular Value Decomposition (SVD) and Eigenvalue Decomposition (EVD)
    // Uses QPE for matrix eigendecomposition
    // ============================================================

//
// Reference: Lloyd, Mohseni & Rebentrost, "Quantum Singular Value Decomposition"
// (2014). https://arxiv.org/abs/1804.03915
// Uses QPE-based eigenvalue estimation from Harrow et al. (2009).
// ============================================================

    // Lambda reciprocal rotation for SVD (same as HHL)
    operation q_md_rotation_lamda_rcp(qs_phase : Qubit[], qs_r : Qubit) : Unit is Adj + Ctl {
        q_hhl_rotation_lamda_rcp(qs_phase, qs_r);
    }

    // Matrix decomposition core using QPE
    operation q_md_core(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        q_phase_estimate_core(U_A, qs_u, qs_phase);
    }

    // SVD: density matrix simulation yields eigenvalues = singular values
    operation q_svd(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        q_md_core(U_A, qs_u, qs_phase, qs_r);
    }

    // EVD: QPE yields matrix eigenvalues
    // qs_u: eigenstate, qs_phase: eigenvalue, qs_r: rotation qubit
    operation q_evd(U_A : (Int, Qubit[]) => Unit is Adj + Ctl, qs_u : Qubit[], qs_phase : Qubit[], qs_r : Qubit) : Unit {
        q_md_core(U_A, qs_u, qs_phase, qs_r);
    }
}