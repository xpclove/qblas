# qblas

QBLAS(Quantum BLAS).   License: GPL v3.

An open source quantum basic linear algebra and quantum simulation library.

Developed with Q#.

Version: v_0.2.9

Released on GitHub from 11.15, 2019.


Q# is a new high-level quantum-focused programming language developed by Microsoft.
Ref: https://docs.microsoft.com/en-us/quantum/language/?view=qsharp-preview.

[Introduction]

Quantum exponential acceleration algorithms will greatly accelerate various computational and machine learning tasks[1].
The library help you run quantum basic linear algebra and quantum simulation algorithms on a quntum computer.The basic linear algebra part contains vector inner product[10,5], HHL matrix eigenvalue decomposition[4,6], fourier transform[8], Quantum phase estimation and other algorithms.
The quantum simulation part contains sparse matrix quantum walk simulation[7], density matrix exponentiation simulation[2,6] and Trotter decomposition simulation[3].
[Details: /doc/qblas.pdf](https://github.com/xpclove/qblas/blob/master/doc/qblas.pdf)

[Motivation]

Inspired by the rapid development of quantum machine learning algorithms[1] in recent years and the calls for open source quantum software[13], we started the project in the Spring of 2018 and completed the preliminary version in the Summer of 2019.
Then, we decided to release it on Github to facilitate the communication of quantum open source software.
To our knowledge, this is the first open-source library to focus on quantum linear algebra and quantum simulation.
We hope it will promote the development of quantum machine learning and quantum open source software ecology.

Authors：
Xiaopeng Cui, Yu Shi. Department of Physics，Fudan University

Shanghai, China

Email: xpclove@gmail.com, yushi@fudan.edu.cn

Project website: http://qblas.site

QBLAS structure:

![QBLAS Structure](https://github.com/xpclove/qblas/blob/master/doc/fig/qblas_structure.jpg)

QBLAS files structure:

![QBLAS Structure](https://github.com/xpclove/qblas/blob/master/doc/fig/qblas_file_structure.jpg)

How to use it:

    1. Install ".NET SDK 6.0" (https://dotnet.microsoft.com/download/dotnet/6.0)

        For Ubuntu x64:
            1) Download from (https://dotnet.microsoft.com/download/dotnet/thank-you/sdk-6.0.412-linux-x64-binaries)
            2) Extract to $HOME/dotnet:
                    mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-6.0.412-linux-x64.tar.gz -C $HOME/dotnet
            3) Set environment variables:
                    export DOTNET_ROOT=$HOME/dotnet
                    export PATH=$PATH:$HOME/dotnet

    2. Build QBLAS:

            ./build.sh

    3. Test QBLAS:

            ./build.sh --test

    Note: Q# 0.28.x and .NET 6.0 are pre-configured in the build script.
          For manual control, set DOTNET_ROOT=~/.dotnet before running dotnet commands.

[Branch]

        master: stable branch,    dev: more recent development branch,    next: unstable latest branch

[new features - v0.2]

    QBLAS now includes high-priority quantum linear algebra primitives:

    GEMV (q_gemv.qs):
        Quantum matrix-vector multiplication using quantum walk simulation.
        Supports iterative refinement, batch operations, and sparse matrices.

    GEMM (q_gemm.qs):
        Quantum matrix-matrix multiplication with block-wise multiplication,
        iterative refinement, batch operations, and transpose variants.

    Variable-time SVD (q_svd_vartime.qs):
        Adaptive-precision singular value decomposition. Complexity improved
        from O(1/epsilon) to O(log(1/epsilon)) for well-conditioned matrices.
        Features: eigenvalue gap detection, condition number estimation.

    Enhanced HHL (q_hhl_enhanced.qs):
        Enhanced quantum linear system solver with preconditioning,
        multi-precision rotation, eigenvalue filtering, amplitude amplification,
        and dynamic decoupling.

[new features - v0.2.9]

    QBLAS v0.2.9 adds 17 new quantum algorithm modules for advanced
    linear algebra and quantum simulation:

    === Krylov Subspace Methods ===

    Conjugate Gradient (q_cg.qs):
        Quantum implementation of CG for solving linear systems Ax = b.
        Includes residual norm computation, convergence checking,
        beta and alpha calculations.

    Lanczos Algorithm (q_lanczos.qs):
        Tridiagonalization for Krylov subspace construction.
        Supports norm computation, eigenvector estimation, eigenvalue sums.

    GMRES (q_gmres.qs):
        Generalized Minimal Residual method for non-symmetric systems.
        Includes Hessenberg matrix construction and restart support.

    === Optimization Methods ===

    Gradient Descent (q_gradient_descent.qs):
        Quantum-accelerated gradient descent optimization.
        Norm computation, convergence checking, momentum support.

    Newton Method (q_newton.qs):
        Second-order optimization using Hessian information.
        Diagonal Hessian estimation for quantum natural gradient.

    === Dimensionality Reduction ===

    Quantum PCA (q_pca.qs):
        Quantum principal component analysis for dimensionality reduction.
        Eigenvalue ordering, explained variance computation, projection matrices.

    Ridge Regression (q_ridge.qs):
        Regularized least squares with Tikhonov regularization.
        Effective condition number estimation, optimal lambda selection.

    === Linear Solvers ===

    Tridiagonal Solver (q_trisol.qs):
        Efficient solver for tridiagonal systems common in PDEs.
        Triangular checks, diagonal non-zero validation.

    === Quantum Signal Processing ===

    QSP (q_qsp.qs):
        Quantum Signal Processing framework for eigenvalue transformation.
        Implements polynomial transformations via phase angle sequences.
        Supports symmetric phase sequences and Chebyshev polynomials.

    === Hamiltonian Simulation ===

    Trotter-Suzuki (q_trotter_suzuki.qs):
        High-order Trotter-Suzuki decomposition for Hamiltonian simulation.
        Supports orders 1, 2, 4 with optimal step size computation.
        Error bounds and decomposition length calculation.

    2-Sparse Simulation (q_2sparse.qs):
        Quantum walk simulation for matrices with at most 2 non-zero
        entries per row/column. Efficient stride-based encoding.

    === Amplitude Amplification ===

    QAA (q_amplitude_amplification.qs):
        Quantum Amplitude Amplification for quadratic speedup.
        Optimal iteration computation, fixed-point amplification,
        state reflection operators.

    === Phase Estimation ===

    Modern QPE (q_qpe_modern.qs):
        Bayesian-inspired phase estimation with adaptive precision.
        Includes variance reduction, optimal bit allocation,
        and eigenstate validation.

    === Gradient Estimation ===

    Quantum Gradient Estimation (q_gradient_estimation.qs):
        Parameter shift rule for evaluating analytic gradients of
        parameterized quantum circuits. Supports quantum natural gradient,
        Hessian estimation, and Adam optimization.

    === Block Encoding ===

    Enhanced Block Encoding v2 (q_block_encoding_v2.qs):
        Advanced block encoding primitives combining QROM (Quantum RAM),
        LCU (Linear Combination of Unitaries), and OAA (Oblivious
        Amplitude Amplification) for improved efficiency.

    === Variational Algorithms ===

    VQE Components (q_vqe.qs):
        Variational Quantum Eigensolver building blocks:
        - Hardware-Efficient Ansatz (HEA)
        - QAOA-style ansatz
        - SU(2) entangling ansatz
        - Parameter shift rule for gradients
        - Adam optimizer integration
        - Shot allocation for measurement

[References]

Review(Quantum machine learning, 2017, https://www.nature.com/articles/nature23474)

[1]	Jacob Biamonte, Peter Wittek, Nicola Pancotti, Patrick Rebentrost, Nathan Wiebe, and Seth Lloyd, "Quantum machine learning," Nature (London) 549, 195–202 (2017), arXiv:1611.09347 [quant-ph].

[2]	S. Lloyd, M. Mohseni, and P. Rebentrost, "Quantum principal component analysis," Nature
Physics 10, 631–633 (2014).

[3]	Seth Lloyd, "Universal quantum simulators," Science 273, 1073 (1996).

[4]	Aram W. Harrow, Avinatan Hassidim, and Seth Lloyd, "Quantum algorithm for linear systems of equations," Phys. Rev. Lett. 103, 150502 (2009).

[5]	X.-D. Cai, D. Wu, Z.-E. Su, M.-C. Chen, X.-L. Wang, Li Li, N.-L. Liu, C.-Y. Lu, and J.-W.
Pan, "Entanglement-based machine learning on a quantum computer," Phys. Rev. Lett. 114,
110504 (2015).

[6]	Leonard Wossnig, Zhikuan Zhao, and Anupam Prakash, "Quantum Linear System Algorithm for Dense Matrices," Phys. Rev. Lett. 120, 050502 (2018), arXiv:1704.06174 [quant-ph].

[7]	Andrew M. Childs, Richard Cleve, Enrico Deotto, Edward Farhi, Sam Gutmann, and Daniel A. Spielman, "Exponential algorithmic speedup by quantum walk," eprint arXiv:quantph/0209131 , quant–ph/0209131 (2002).

[8]	Graeme Ahokas, "Improved algorithms for approximate quantum fourier transforms and sparse hamiltonian simulations," (2004).

[9]	Patrick Rebentrost, Adrian Steffens, Iman Marvian, and Seth Lloyd, "Quantum singularvalue decomposition of nonsparse low-rank matrices," Phys. Rev. A 97, 012327 (2018).

[10]	Seth Lloyd, Masoud Mohseni, and Patrick Rebentrost, "Quantum algorithms for supervised and unsupervised machine learning," arXiv e-prints , arXiv:1307.0411 (2013), arXiv:1307.0411
[quant-ph].

[11]  Vittorio Giovannetti, Seth Lloyd,  and Lorenzo Maccone, "Quantum random access memory,"Phys. Rev. Lett.100, 160501 (2008).

[12]  Vittorio Giovannetti, Seth Lloyd,   and Lorenzo Maccone, "Architectures for a quantum ran-dom access memory," Phys. Rev. A78, 052310 (2008).12

[13]  Chong F T, Franklin D, Martonosi M. "Programming languages and compiler design for realistic quantum hardware". Nature, 2017, 549:180