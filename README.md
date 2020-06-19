# QBLAS
Quantum BLAS.   License: GPL v3.

An open source quantum basic linear algebra and quantum simulation library.

Developed with Q#.

Version: v_0.2.0,      Release note: (./Release.md)

Released on GitHub from 11.15, 2019.


Q# is a new high-level quantum-focused programming language developed by Microsoft. Ref https://docs.microsoft.com/en-us/quantum/language/?view=qsharp-preview.

[Introduction]

Quantum exponential acceleration algorithms will greatly accelerate various computational and machine learning tasks[1].
The library help you run quantum basic linear algebra and quantum simulation algorithms on a quntum computer.The basic linear algebra part contains vector inner product[10,5], HHL matrix eigenvalue decomposition[4,6], fourier transform[8], Quantum phase estimation and other algorithms.
The quantum simulation part contains sparse matrix quantum walk simulation[7], density matrix exponentiation simulation[2,6] and Trotter decomposition simulation[3].

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

    1. Install ".Net Core SDK 2.1" (https://dotnet.microsoft.com/download/dotnet-core/2.1)

        For Ubuntu x64 : 
            1) Firstly download from (https://dotnet.microsoft.com/download/dotnet-core/thank-you/sdk-2.1.806-linux-x64-binaries)
            2) Then run shell command to install dotnet-sdk:
                    mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-2.1.806-linux-x64.tar.gz -C $HOME/dotnet
            3) Set environment variable: 
                    export DOTNET_ROOT=$HOME/dotnet
                    export PATH=$PATH:$HOME/dotnet

    2. Install Q# Library: Microsoft.Quantum.Development.Kit 0.3.1811.203-preview; Microsoft.Quantum.Canon 0.3.1811.203-preview

			dotnet add package Microsoft.Quantum.Development.Kit --version 0.6.1905.301
			dotnet add package Microsoft.Quantum.Canon --version 0.6.1905.301
		or
			cd into test directory, run "dotnet clean"

    3. Test it, cd into test directory:

            dotnet run 


References:

Review(Quantum machine learning, 2017, https://www.nature.com/articles/nature23474)

[1]	Jacob Biamonte, Peter Wittek, Nicola Pancotti, Patrick Rebentrost, Nathan Wiebe, and Seth Lloyd, “Quantum machine learning,” Nature (London) 549, 195–202 (2017), arXiv:1611.09347 [quant-ph].

[2]	S. Lloyd, M. Mohseni, and P. Rebentrost, “Quantum principal component analysis,” Nature
Physics 10, 631–633 (2014).

[3]	Seth Lloyd, “Universal quantum simulators,” Science 273, 1073 (1996).

[4]	Aram W. Harrow, Avinatan Hassidim, and Seth Lloyd, “Quantum algorithm for linear systems of equations,” Phys. Rev. Lett. 103, 150502 (2009).

[5]	X.-D. Cai, D. Wu, Z.-E. Su, M.-C. Chen, X.-L. Wang, Li Li, N.-L. Liu, C.-Y. Lu, and J.-W.
Pan, “Entanglement-based machine learning on a quantum computer,” Phys. Rev. Lett. 114,
110504 (2015).

[6]	Leonard Wossnig, Zhikuan Zhao, and Anupam Prakash, “Quantum Linear System Algorithm for Dense Matrices,” Phys. Rev. Lett. 120, 050502 (2018), arXiv:1704.06174 [quant-ph].

[7]	Andrew M. Childs, Richard Cleve, Enrico Deotto, Edward Farhi, Sam Gutmann, and Daniel A. Spielman, “Exponential algorithmic speedup by quantum walk,” eprint arXiv:quantph/0209131 , quant–ph/0209131 (2002).

[8]	Graeme Ahokas, “Improved algorithms for approximate quantum fourier transforms and sparse hamiltonian simulations,” (2004).

[9]	Patrick Rebentrost, Adrian Steffens, Iman Marvian, and Seth Lloyd, “Quantum singularvalue decomposition of nonsparse low-rank matrices,” Phys. Rev. A 97, 012327 (2018).

[10]	Seth Lloyd, Masoud Mohseni, and Patrick Rebentrost, “Quantum algorithms for supervised and unsupervised machine learning,” arXiv e-prints , arXiv:1307.0411 (2013), arXiv:1307.0411
[quant-ph].

[11]  Vittorio Giovannetti, Seth Lloyd,  and Lorenzo Maccone, “Quantum random access memory,”Phys. Rev. Lett.100, 160501 (2008).

[12]  Vittorio Giovannetti, Seth Lloyd,   and Lorenzo Maccone, “Architectures for a quantum ran-dom access memory,” Phys. Rev. A78, 052310 (2008).12

[13]  Chong F T, Franklin D, Martonosi M. “Programming languages and compiler design for realistic quantum hardware”. Nature, 2017, 549:180
