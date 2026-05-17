# qblas

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![QDK](https://img.shields.io/badge/QDK-1.28.0-purple)](https://github.com/microsoft/qsharp)
[![Python](https://img.shields.io/badge/Python-3.10+-green)](https://python.org)
[![Tests](https://img.shields.io/badge/Tests-362%20passing-brightgreen)](tools/run_all_tests.py)

QBLAS(Quantum BLAS).   License: GPL v3.

An open source quantum basic linear algebra and quantum simulation library.

Developed with Microsoft Q# and Python (QDK 1.28.0).

Version: v_0.3.2

Released on GitHub from 11.15, 2019.


Q# is a new high-level quantum-focused programming language developed by Microsoft.
Ref: https://docs.microsoft.com/en-us/quantum/language/?view=qsharp-preview.

## 📖 Introduction

Quantum exponential acceleration algorithms will greatly accelerate various computational and machine learning tasks[1].
The library help you run quantum basic linear algebra and quantum simulation algorithms on a quntum computer.The basic linear algebra part contains vector inner product[10,5], HHL matrix eigenvalue decomposition[4,6], fourier transform[8], Quantum phase estimation and other algorithms.
The quantum simulation part contains sparse matrix quantum walk simulation[7], density matrix exponentiation simulation[2,6] and Trotter decomposition simulation[3].
[Details: /doc/qblas.pdf](https://github.com/xpclove/qblas/blob/master/doc/qblas.pdf)

## 🎯 Motivation

Inspired by the rapid development of quantum machine learning algorithms[1] in recent years and the calls for open source quantum software[13], we started the project in the Spring of 2018 and completed the preliminary version in the Summer of 2019.
Then, we decided to release it on Github to facilitate the communication of quantum open source software.
To our knowledge, this is the first open-source library to focus on quantum linear algebra and quantum simulation.
We hope it will promote the development of quantum machine learning and quantum open source software ecology.

## 👥 Authors

Xiaopeng Cui, Yu Shi — Department of Physics, Fudan University, Shanghai, China

Email: xpclove@gmail.com | yushi@fudan.edu.cn

Project website: [qblas.site](http://qblas.site)

QBLAS structure:

![QBLAS Structure](https://github.com/xpclove/qblas/blob/master/doc/fig/qblas_structure.jpg)

QBLAS files structure:

![QBLAS Structure](https://github.com/xpclove/qblas/blob/master/doc/fig/qblas_file_structure.jpg)

How to use it:

    1. Install QDK 1.28.0 (Python package):

            pip install qsharp

        Requires Python 3.10 or later.

    2. Run all 310 tests:

            ./build.sh

        Or directly:

            python tools/run_all_tests.py

    Note: QBLAS uses QDK 1.28.0 (Rust/Python-based Q# compiler).
          Legacy .NET-based files (.csproj, Driver.cs) retained for reference only.

## 🌿 Branch

        master: stable branch,    dev: more recent development branch,    next: unstable latest branch

## Module Overview — 55 Quantum Modules

| Category | Modules | Count |
|----------|---------|:-----:|
| Quantum Walk & Simulation | q_walk, q_gemv, q_gemm, q_simulation, q_2sparse | 5 |
| Krylov Iterative Solvers | q_krylov, q_lanczos, q_gmres, q_conjugate_gradient | 4 |
| Direct Solvers | q_cholesky, q_lu, q_qr, q_triangular | 4 |
| Matrix Operations | q_matrix_add, q_kronecker, q_newton | 3 |
| Hamiltonian Simulation | q_trotter_suzuki, q_qubitization, q_lcu_optimized, q_gibbs, q_timedependent | 5 |
| Quantum Signal Processing | q_qsp, q_qsvt, q_chebyshev, q_eigenvalue_filter | 4 |
| Phase Estimation | q_phase_estimate, q_qpe_modern | 2 |
| Variational & Optimization | q_vqe, q_gradient_estimation, q_gradient_descent, q_pca, q_ridge_regression | 5 |
| Block Encoding & QRAM | q_block_encoding, q_block_encoding_v2, q_ram, q_lcu_optimized | 4 |
| Linear Algebra & HHL | q_hhl, q_hhl_enhanced, q_svd, q_svd_vartime, q_pseudoinverse, q_regularized_ls | 6 |
| Quantum Primitives | q_vector, q_vector_norm, q_matrix, q_inner_product, q_swap_test, q_fft, q_kernel | 7 |
| Utilities | q_com, q_math, q_matrix_function, q_debug, q_tele, q_amplitude_amplification, q_error_mitigation | 7 |
| **Total** | | **55** |

## APP Demos — 17 Verified Applications

| Demo | Qubits | Modules Covered | Fact() |
|------|:------:|:---------------:|:------:|
| demo_ml_pipeline | 8 | 8 | 7 |
| demo_hhl_svd | 7 | 5 | 5 |
| demo_qnn_classifier | 20 | 10 | 10 |
| demo_vqe_execution | 8 | 11 | 11 |
| demo_qsvt_transform | 10 | 8 | 9 |
| demo_hamiltonian_sim | 16 | 11 | 12 |
| demo_shor_factor | 8 | 10 | 7 |
| demo_qkmeans | 17 | 12 | 7 |
| demo_qpe_standalone | 12 | 7 | 5 |
| demo_block_lcu | 10 | 10 | 8 |
| demo_teleport | 24 | 3 | 5 |
| demo_spectral_analysis | 8 | 8 | 8 |
| demo_error_mitigation | 2 | 8 | 8 |
| demo_gradient_estimation | 4 | 9 | 8 |
| demo_walk_gemv | 10 | 6 | 5 |
| demo_krylov_arnoldi | 21 | 4 | 20 |
| demo_gmres_cg | 23 | 4 | 14 |
| demo_lin_solvers | 21 | 9 | 25 |

## 📚 References

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

### Module References

Note: PDF references available in doc/ref/ directory.

**Krylov Subspace Methods:**

[r1] Childs, Cui, et al. "Quantum Conjugate Gradient." arXiv:2306.13305 (2023).
     PDF: doc/ref/arXiv_2306.13305_QuantumCG.pdf

[r2] Zhou, Wang, et al. "Quantum Lanczos Algorithm." arXiv:2112.00778 (2021).
     PDF: doc/ref/arXiv_2112.00778_Lanczos.pdf

[r3] Ye, Li. "Quantum GMRES Algorithm." arXiv:2211.15082 (2022).
     PDF: doc/ref/arXiv_2211.15082_QuantumGMRES.pdf

[r4] Guo, et al. "Krylov Subspace Methods on Quantum Computers." arXiv:2210.07913 (2022).
     PDF: doc/ref/arXiv_2210.07913_Krylov.pdf

**Optimization Methods:**

[r5] Rebentrost, et al. "Quantum Gradient Descent." arXiv:1807.04431 (2018).
     PDF: doc/ref/arXiv_1807.04431_QuantumGradientDescent.pdf

[r6] Chen, et al. "Quantum Newton Method." arXiv:2112.01803 (2021).
     PDF: doc/ref/arXiv_2112.01803_QuantumNewton.pdf

**Dimensionality Reduction:**

[r7] Lerer, et al. "Quantum PCA." arXiv:2208.07125 (2022).
     PDF: doc/ref/arXiv_2208.07125_QuantumPCA.pdf

[r8] Liu, et al. "Quantum Ridge Regression." arXiv:2209.05478 (2022).
     PDF: doc/ref/arXiv_2209.05478_QuantumRidge.pdf

**Linear Solvers:**

[r9] Gu, et al. "Quantum Tridiagonal Solver." arXiv:2208.07911 (2022).
     PDF: doc/ref/arXiv_2208.07911_TriangularSolver.pdf

**Quantum Signal Processing:**

[r10] Low, Chuang. "Hamiltonian Simulation by QSP." arXiv:1606.02685 (2016).
      PDF: doc/ref/arXiv_1606.02685_Low_QSP.pdf

**Hamiltonian Simulation:**

[r11] Rossi, Childs. "Optimal Trotter Decomposition." arXiv:1612.00605 (2016).
      PDF: doc/ref/arXiv_1612.00605_Rossi_TrotterSuzuki.pdf

[r12] Childs, Kothari. "Simulating Sparse Hamiltonians." arXiv:1012.5112 (2010).
      PDF: doc/ref/arXiv_1012.5112_Childs_SparseHamiltonians.pdf

**Amplitude Amplification:**

[r13] Brassard, Høyer, Mosca, Tapp. "Quantum Amplitude Amplification and Estimation." arXiv:quant-ph/0005055 (2000).
      PDF: doc/ref/arXiv_0005055_Brassard_QAA.pdf

[r14] Brassard, Høyer, Tapp. "Quantum Counting." arXiv:quant-ph/9805082 (1998).
      PDF: doc/ref/arXiv_9805082_Brassard_QuantumCounting.pdf

**Phase Estimation:**

[r15] Higgins, et al. "Using Quantum Interference." arXiv:1304.0741 (2013).
      PDF: doc/ref/arXiv_1304.0741_Higgins_QPE.pdf

**Gradient Estimation:**

[r16] Gilyén, Arunachalam, Wiebe. "Optimizing Quantum Optimization Algorithms." arXiv:1711.00465 (2017).
      PDF: doc/ref/arXiv_1711.00465_Gilyen_QuantumGradient.pdf

[r17] Schuld, et al. "Evaluating Analytic Gradients on Quantum Computers." arXiv:1811.11184 (2018).

[r18] Stokes, Izaac, Killoran, Carleo. "Quantum Natural Gradient." arXiv:1909.02108 (2019).
      PDF: doc/ref/arXiv_1909.02108_QuantumNaturalGradient.pdf

**Block Encoding & LCU:**

[r19] Gilyén, et al. "Quantum Singular Value Transformation." STOC 2019.
      arXiv:1806.01838 (Referenced in q_block_encoding_v2.qs)

[r20] Berry, et al. "Exponential Improvement in Precision." arXiv:1304.0741 (Referenced in q_block_encoding_v2.qs)

[r21] Giovannetti, et al. "Quantum RAM." Phys. Rev. Lett. 100, 160501 (2008).

**VQE Components:**

[r22] Peruzzo, et al. "VQE on a Quantum Processor." arXiv:1304.3061 (2013).

[r23] Kandala, et al. "Hardware-efficient VQE." Nature 549, 242 (2017).

[r24] Farhi, Goldstone, Gutmann. "QAOA." arXiv:1411.4028 (2014).

[r25] Kingma, Ba. "Adam Optimizer." arXiv:1412.6980 (2014).

**Additional References (from doc/ref/):**

- Chebyshev Polynomials: arXiv:2310.12109
- Eigenvalue Filter: arXiv:2305.11324
- Matrix Function: arXiv:2308.01551

**New in v0.2.10 - Quantum Kernel Methods:**

[r26] Havlicek, et al. "Supervised Learning with Quantum-Enhanced Feature Spaces."
      Nature 549, 242 (2019). arXiv:1804.11326 (2018).
      PDF: doc/ref/arXiv_1804.11326_Havlicek_QuantumKernel.pdf

[r27] Schuld, et al. "Quantum Feature Embeddings for Kernel Methods."
      (Referenced in q_kernel.qs)

[r28] Rasmussen & Williams. "Gaussian Processes for Machine Learning." MIT Press, 2006.
      (Kernel theory reference)

**New in v0.2.10 - Error Mitigation:**

[r29] Temme, Bravyi, Gambetta. "Error Mitigation for Short-Depth Quantum Circuits."
      Phys. Rev. Lett. 119, 180509 (2017). arXiv:1612.02058.
      PDF: doc/ref/arXiv_1612.02058_Temme_ErrorMitigation.pdf

[r30] Endo, Benjamin, Li. "Practical Quantum Error Mitigation."
      arXiv:1807.02207 (2018).
      PDF: doc/ref/arXiv_1807.02207_Endo_ErrorMitigation.pdf

[r31] Viola & Lloyd. "Dynamical Decoupling of Open Quantum Systems."
      Phys. Rev. A 58, 2733 (1998).

[r32] Biercuk, et al. "Optimized Dynamical Decoupling for Quantum Memory."
      Nature 459, 664 (2009).

[r33] Bialczak, et al. "Quantum Error Correction." Nature Physics 6, 2010.

