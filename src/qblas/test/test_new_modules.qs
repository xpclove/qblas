namespace Quantum.test
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open qblas;

    operation test_cg_residual_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_cg_residual_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_cg_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let b_norm = 1.0;
            let eps = 1e-6;
            return q_cg_converged(r_norm, b_norm, eps) ? 1 | 0;
        }
    }

    operation test_cg_compute_beta(p : Int) : Double {
        body {
            let beta = q_cg_compute_beta(0.25, 1.0);
            return beta;
        }
    }

    operation test_cg_compute_alpha(p : Int) : Double {
        body {
            let alpha = q_cg_compute_alpha(0.5, 2.0);
            return alpha;
        }
    }

    operation test_lanczos_norm(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_lanczos_norm(v);
        }
    }

    operation test_lanczos_normalize(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 2.0];
            let n = q_lanczos_normalize(v);
            return IntAsDouble(Length(n));
        }
    }

    operation test_lanczos_alpha_compute(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_lanczos_alpha_compute(v);
        }
    }

    operation test_lanczos_beta_compute(p : Int) : Double {
        body {
            let v = [3.0, 4.0];
            return q_lanczos_beta_compute(v);
        }
    }

    operation test_lanczos_tridiag(p : Int) : Int {
        body {
            let alphas = [1.0, 2.0, 3.0];
            let betas = [0.5, 0.5];
            let mat = q_lanczos_tridiag(alphas, betas);
            return Length(mat);
        }
    }

    operation test_lanczos_eigenvalue_sum(p : Int) : Double {
        body {
            let eigenvalues = [1.0, 2.0, 3.0];
            return q_lanczos_eigenvalue_sum(eigenvalues);
        }
    }

    operation test_krylov_residual_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_krylov_residual_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_krylov_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let init_norm = 1.0;
            let eps = 1e-6;
            return q_krylov_converged(r_norm, init_norm, eps) ? 1 | 0;
        }
    }

    operation test_krylov_norm_sq(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_krylov_norm_sq(v);
        }
    }

    operation test_krylov_inner_product(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            let w = [0.5, 1.0, 1.5];
            return q_krylov_inner_product(v, w);
        }
    }

    operation test_gmres_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_gmres_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }

    operation test_gmres_converged(p : Int) : Int {
        body {
            let r_norm = 0.01;
            let init_norm = 1.0;
            let eps = 1e-6;
            return q_gmres_converged(r_norm, init_norm, eps) ? 1 | 0;
        }
    }

    operation test_gmres_hessenberg_size(p : Int) : Int {
        body {
            let (m, n) = q_gmres_hessenberg_size(5);
            return m;
        }
    }

    operation test_gd_norm(p : Int) : Double {
        body {
            let g = [1.0, 2.0, 3.0];
            return q_gd_norm(g);
        }
    }

    operation test_gd_converged(p : Int) : Int {
        body {
            let gradient = [0.001, 0.001, 0.001];
            let eps = 0.01;
            return q_gd_converged(gradient, eps) ? 1 | 0;
        }
    }

    operation test_gd_norm_sq(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_gd_norm_sq(v);
        }
    }

    operation test_newton_norm(p : Int) : Double {
        body {
            let v = [1.0, 2.0, 3.0];
            return q_newton_norm(v);
        }
    }

    operation test_newton_converged(p : Int) : Int {
        body {
            let gradient = [0.001, 0.001, 0.001];
            let delta = [0.0001, 0.0001, 0.0001];
            let eps = 0.01;
            return q_newton_converged(gradient, delta, eps) ? 1 | 0;
        }
    }

    operation test_pca_eigenvalue_norm(p : Int) : Double {
        body {
            let eigenvalues = [1.0, -2.0, 3.0];
            return q_pca_eigenvalue_norm(eigenvalues);
        }
    }

    operation test_pca_explained_var(p : Int) : Int {
        body {
            let eigenvalues = [4.0, 2.0, 2.0];
            let ratios = q_pca_explained_var(eigenvalues);
            return Length(ratios);
        }
    }

    operation test_pca_projection_matrix(p : Int) : Int {
        body {
            let eigenvalues = [4.0, 2.0, 2.0];
            let P = q_pca_projection_matrix(2, eigenvalues, 1.0);
            return Length(P);
        }
    }

    operation test_ridge_effective_cond(p : Int) : Double {
        body {
            let kappa = 10.0;
            let lambda = 0.1;
            return q_ridge_effective_cond(kappa, lambda);
        }
    }

    operation test_ridge_lambda_opt(p : Int) : Double {
        body {
            let kappa = 10.0;
            let n = 100;
            let d = 10;
            return q_ridge_lambda_opt(kappa, n, d);
        }
    }

    operation test_ridge_matrix_dim(p : Int) : Int {
        body {
            let A = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]];
            let (m, n) = q_ridge_matrix_dim(A);
            return m;
        }
    }

    operation test_trisol_is_triangular(p : Int) : Int {
        body {
            let A_lower = [[1.0, 0.0], [0.5, 1.0]];
            let is_lower = true;
            return q_trisol_is_triangular(A_lower, is_lower) ? 1 | 0;
        }
    }

    operation test_trisol_diagonal_nonzero(p : Int) : Int {
        body {
            let A = [[1.0, 0.0], [0.0, 1.0]];
            return q_trisol_diagonal_nonzero(A) ? 1 | 0;
        }
    }

    operation test_trisol_norm(p : Int) : Double {
        body {
            use qs = Qubit[4];
            let norm = q_trisol_norm(qs);
            ResetAll(qs);
            return norm;
        }
    }
}