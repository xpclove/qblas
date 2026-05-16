# QBLAS Agent Guidelines

## Project Overview

**QBLAS** (Quantum Basic Linear Algebra Subprograms) is an open-source quantum computing library for quantum linear algebra and quantum simulation.

- **Version**: v0.3.1
- **Tech Stack**: Microsoft QDK 1.28.0 (Rust/Python-based Q# compiler)
- **License**: GPL v3
- **Location**: `src/qblas/`

## Build & Test

### Prerequisites
```bash
# Python 3.10+ with QDK 1.28
pip install qsharp
```

### Commands
```bash
# Full build + test
./build.sh

# Or run tests directly
python tools/run_all_tests.py

# Compile Q# library only (syntax check)
python3.11 -c "import qsharp; qsharp.eval(open('src/qblas/qblas/q_com.qs').read())"
```

## Code Conventions

### Code Quality Requirements
- **简洁准确**: Code should be concise and precise, no redundancy
- **注释充分**: Every module, operation, and function must have detailed comments explaining:
  - Purpose and functionality
  - Input/output parameters
  - Algorithm description
  - Complexity analysis (time/space)
- **可读性高**: Clear naming, consistent formatting, logical structure
- **参考文献**: Every module must include:
  - Reference citation (paper title, venue, year)
  - URL link to the original paper/source
  - Brief explanation of how the algorithm is implemented

**Example module header:**
```qsharp
// ============================================================
// Module Name: Quantum Singular Value Transformation (QSVT)
//
// Purpose: Provides unified framework for quantum linear algebra
// through polynomial transformations of singular values.
//
// Algorithm: Implements the QSVT framework from Gilyén et al.
// Transforms singular values by applying polynomials via
// controlled rotations on ancilla qubits.
//
// Complexity: O(poly(log(1/ε))) for polynomial degree p
//
// Reference: Gilyén et al., "Quantum Singular Value Transformation"
// STOC 2019. https://arxiv.org/abs/1806.01838
// ============================================================
```

### File Organization
- **Library files**: `src/qblas/qblas/*.qs`
- **Test files**: `src/qblas/test/test*.qs` + `Driver.cs`
- One `.qs` file per module (e.g., `q_gemv.qs`, `q_qsvt.qs`)

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Namespace | `qblas` | `namespace qblas { ... }` |
| Operation | `q_<module>_<name>` | `q_gemv_diagonal`, `q_qsvt_polynomial_transform` |
| Function | `q_<module>_<name>` | `q_qsvt_normalize_vector`, `q_be_compute_scaling` |
| NewType | `q_<type>` or `q<Module>_<type>` | `qsvt_block_oracle`, `q_matrix_1_sparse_oracle` |
| Test | `test_<module>_<name>` | `test_gemv_diagonal`, `test_qsvt_apply_diagonal` |

### NewType Definitions

**CORRECT pattern** (operation type):
```qsharp
// Correct: single parens for tuple type
newtype qsvt_block_oracle = (Qubit[], Qubit[]) => Unit is Adj + Ctl;
```

**WRONG pattern** (extra wrapping parens - causes parse error in new QDK):
```qsharp
// Bad: extra outer parentheses
newtype qsvt_block_oracle = ((Qubit[], Qubit[]) => Unit is Adj + Ctl);
```

### Operation Signatures

Operations that need adjoint/controlled should use `body (...)` with explicit specializations:
```qsharp
operation q_gemv(...) : Unit is Adj + Ctl {
    // implementation
}
```

### Function Signatures

Pure functions (no quantum operations) should be declared as `function`:
```qsharp
function q_qsvt_normalize_vector(v : Double[]) : Double[] {
    let norm = Sqrt(SquaredNorm(v));
    return v; // simplified
}
```

## Common Patterns

### Qubit Allocation
```qsharp
// Allocated qubits - use 'use'
use qs = Qubit[4];
use (qs1, qs2) = (Qubit[3], Qubit[4]);

// Borrowed qubits - use 'borrowed'
borrowed qs = Qubit[2];
```

### Loop Patterns
```qsharp
// Standard for loop
for (i in 0 .. n - 1) { ... }

// Range loops
for (i in 1 .. n - 1) { ... }
```

### Mutable Variables
```qsharp
mutable result = 0.0;
set result = result + 1.0;

// For arrays
mutable arr = [];
set arr += [new_element];
```

### Conditional Checks
```qsharp
// Ternary operator
let value = condition ? true_val | false_val;

// Boolean expressions (use 'and', 'or', not &&, ||)
if (a > 0.0 and b < 1.0) { ... }
```

## Resolved Issues (v0.2.11)

The following issues from earlier versions have been resolved:

### 1. Exp() Expression Bug (RESOLVED)
**Issue**: `Exp(-lambda_reg)` caused compiler error QS0001 "Expected type (Pauli[], Double, Qubit[])"

**Solution**: Use placeholder value directly:
```qsharp
// Resolved: use placeholder (Exp(-lambda) causes QS0001)
let exp_val = 0.5;
let ck = 2.0 * exp_val / denom;
```

### 2. Array Slice Out of Bounds (RESOLVED)
**Issue**: `qs_data[0 .. i - 1]` failed when `i = 0` (empty range error)

**Solution**: Start loop from 1 instead of 0:
```qsharp
// Resolved: loop starts from 1, so i-1 >= 0 always
for (i in 1 .. n - 1) {
    (Controlled Ry)(qs_data[0 .. i - 1], (angle, qs_ancilla));
}
```

### 3. Q# Version Compatibility
- Project uses QDK 1.28.0 (Rust/Python-based Q# compiler)
- Modern Q# syntax, no deprecation warnings
- All 310 tests pass

## Test Patterns

### Test Operation Signature
```qsharp
operation test_<module>_<name>(p : Int) : <ReturnType> {
    // test implementation (no body { } wrapper)
    return <expected_value>;
}
```

### Test Entry Point (Python runner)
```python
# Python test runner pattern (tools/run_all_tests.py)
result = qsharp.eval(f"Quantum.test.{op_name}({arg})")
print(f"  {op_name}({arg}) = {result}")
```

### Running Tests
- All tests run via `python tools/run_all_tests.py` (or `./build.sh`)
- Tests use QDK 1.28 Rust native simulator (not .NET QuantumSimulator)
- Return types: `Double`, `Int`, `Result` (One/Zero)

## Adding New Modules

### Steps
1. Create `q_<module>.qs` in `src/qblas/qblas/`
2. Implement operations/functions following naming conventions
3. Add tests to `test_gemv_gemm.qs` or new test file
4. Add test entries to Python runner (`tools/run_all_tests.py`)
5. Build and verify: `python tools/run_all_tests.py`

### Module Template
```qsharp
namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    import Std.Convert.*;
    import Std.Math.*;

    // ============================================================
    // Module Description
    //
    // Brief description of what this module does.
    // Reference: Citation or algorithm source
    // ============================================================

    // Oracle types (if needed)
    newtype q_<type>_oracle = (Qubit[], Qubit[], Qubit[]) => Unit is Adj + Ctl;

    // Core operations
    operation q_<module>_core(...) : Unit is Adj + Ctl {
        // implementation
    }

    // Helper functions
    function q_<module>_helper(...) : ... {
        // pure function
    }
}
```

## Project Structure

```
qblas/
├── qsharp.json                   # Q# project manifest (QDK 1.28)
├── .gitignore
├── src/qblas/
│   ├── qblas/                    # Core library (55 modules)
│   │   ├── q_*.qs              # Quantum operations
│   │   ├── qblas.csproj        # (legacy, retained for reference)
│   │   └── test_package_ref.csproj  # (legacy)
│   └── test/                     # Test suite
│       ├── test*.qs             # Q# test operations
│       ├── Driver.cs            # (legacy C# runner, retained)
│       └── test.csproj          # (legacy)
├── tools/                         # Python test & migration tools
│   ├── run_all_tests.py         # Python test runner (replaces Driver.cs)
│   ├── migrate_qsharp.py        # Q# syntax migrator (body->is Adj+Ctl)
│   ├── fix_for_loops.py         # for(->for loop fix
│   ├── fix_remaining.py         # import/math function fix
│   └── fix_using.py             # using->use fix
├── build.sh                       # Build/test script
├── README.md                     # Project documentation
└── doc/
    └── qblas-develop-report.md   # Technical analysis
```

## Quick Reference

### Key Files
- `q_gemv.qs`: Matrix-vector multiplication
- `q_gemm.qs`: Matrix-matrix multiplication
- `q_svd_vartime.qs`: Variable-time SVD
- `q_hhl_enhanced.qs`: Enhanced HHL algorithm
- `q_qsvt.qs`: Quantum Singular Value Transformation
- `q_regularized_ls.qs`: Regularized least squares
- `q_block_encoding.qs`: Block encoding primitives
- `q_cg.qs`, `q_lanczos.qs`, `q_krylov.qs`, `q_gmres.qs`: Krylov methods
- `q_gradient_descent.qs`, `q_newton.qs`: Optimization
- `q_pca.qs`, `q_ridge.qs`: Dimensionality reduction
- `q_trisol.qs`: Tridiagonal solver
- `q_qsp.qs`: Quantum Signal Processing
- `q_trotter_suzuki.qs`, `q_2sparse.qs`: Hamiltonian simulation
- `q_amplitude_amplification.qs`: Amplitude amplification
- `q_qpe_modern.qs`: Modern phase estimation
- `q_gradient_estimation.qs`: Gradient estimation
- `q_block_encoding_v2.qs`: Enhanced block encoding
- `q_vqe.qs`: VQE components

### Critical Constants
- Precision threshold: `1e-10`
- Array length: use `Length(array)`
- Quantum gates: `Ry`, `CNOT`, `H`, `X`, etc.
- Measurement: `M(q)` returns `Result`

### Git Workflow
```bash
# Version bump (update version in README.md + qsharp.json before committing)
# Current: v0.3.1 -> next: v0.3.1
# Update version in README.md, qsharp.json before committing

# Stage files
git add src/qblas/qblas/q_newmodule.qs
git add src/qblas/test/test_newmodule.qs
git add tools/run_all_tests.py  # add test entries
git add README.md qsharp.json  # version bump

# Commit with descriptive message
git commit -m "feat: add q_newmodule with operations..."
```

## Completed Modules

### v0.2.9 - 17 New Quantum Algorithm Modules

**Krylov Subspace Methods:**
- `q_cg.qs`: Conjugate Gradient for linear systems
- `q_lanczos.qs`: Lanczos tridiagonalization
- `q_gmres.qs`: Generalized Minimal Residual
- `q_krylov.qs`: Krylov subspace operations

**Optimization:**
- `q_gradient_descent.qs`: Gradient descent optimization
- `q_newton.qs`: Second-order Newton method

**Dimensionality Reduction:**
- `q_pca.qs`: Quantum PCA
- `q_ridge.qs`: Ridge regression (Tikhonov regularization)

**Linear Solvers:**
- `q_trisol.qs`: Tridiagonal system solver

**Quantum Signal Processing:**
- `q_qsp.qs`: QSP framework for eigenvalue transformation

**Hamiltonian Simulation:**
- `q_trotter_suzuki.qs`: High-order Trotter-Suzuki decomposition
- `q_2sparse.qs`: 2-sparse Hamiltonian simulation

**Amplitude Amplification:**
- `q_amplitude_amplification.qs`: QAA with optimal iterations

**Phase Estimation:**
- `q_qpe_modern.qs`: Bayesian-inspired phase estimation

**Gradient Estimation:**
- `q_gradient_estimation.qs`: Parameter shift rule, quantum natural gradient

**Block Encoding:**
- `q_block_encoding_v2.qs`: QROM, LCU, OAA primitives

**Variational Algorithms:**
- `q_vqe.qs`: VQE components (HEA, QAOA, SU2, optimizers)

### v0.2.13 - 9 Modules Enhanced with Quantum Operations

**Krylov Subspace Methods (Quantum Implementation):**
- `q_krylov.qs`: Arnoldi iteration with quantum walk + SWAP test (6 new ops)
- `q_lanczos.qs`: Lanczos tridiagonalization with three-term recurrence (5 new ops)
- `q_gmres.qs`: GMRES solver with Hessenberg construction (4 new ops)

**Optimization Methods (Quantum Implementation):**
- `q_conjugate_gradient.qs`: CG linear system solver (3 new ops)
- `q_gradient_descent.qs`: Gradient descent optimizer (2 new ops)
- `q_newton.qs`: Newton method with Hessian estimation (2 new ops)

**Matrix Decomposition & Applications:**
- `q_pca.qs`: PCA with QPE eigenvalue estimation (2 new ops)
- `q_ridge_regression.qs`: Ridge regression solver (2 new ops)
- `q_triangular.qs`: Triangular system solver (3 new ops)

**Infrastructure:**
- Removed: q_cg_residual_norm, q_gmres_norm, q_krylov_residual_norm, q_trisol_norm, q_gmres_init_vec
- Total: 293 tests pass

### v0.2.14 - Remaining 15 Layer 0 Modules Enhanced with Quantum Operations

**Hamiltonian Simulation:**
- `q_qubitization.qs`: Qubitization-based simulation with QSP phases (1 new op)
- `q_lcu_optimized.qs`: Single-ancilla LCU SELECT+PREPARE circuit (2 new ops)
- `q_gibbs.qs`: Gibbs state preparation via imaginary time evolution (1 new op)
- `q_timedependent.qs`: Time-dependent H(t) simulation with Strang splitting (2 new ops)

**Quantum Primitives:**
- `q_inner_product.qs`: SWAP test measurement operation (1 new op)
- `q_vector_norm.qs`: State norm estimation via measurement statistics (1 new op)
- `q_gradient_estimation.qs`: Parameter shift circuit execution (1 new op)

**Classical→Quantum Solvers:**
- `q_lu.qs`: HHL-style quantum linear solve (1 new op)
- `q_cholesky.qs`: SPD quantum linear solve (1 new op)
- `q_qr.qs`: Quantum least-squares solver (1 new op)
- `q_matrix_add.qs`: A+B block encoding via sequential q_gemv (1 new op)
- `q_kronecker.qs`: A⊗B application to composite quantum state (1 new op)
- `q_error_mitigation.qs`: ZNE circuit execution with noise extrapolation (1 new op)

**Kernel Methods:**
- `q_kernel.qs`: Quantum kernel matrix entry computation via SWAP test (1 new op)

**Total: 18 new quantum operations, 308 tests pass**

### v0.3.1 - QDK 1.28 Migration

- Full migration from .NET-based QDK 0.28.x (archived qsharp-compiler) to Rust/Python-based QDK 1.28.0
- Syntax transformations across all 60 .qs files:
  - `body { ... } adjoint auto;` → `is Adj + Ctl` annotation (149 operations)
  - `for (...)` → `for ...` (555 instances)
  - `using (qs = ...)` → `use qs = ...` (16 instances)
  - `PowD(a,b)` → `a ^ b`, `ExpD(x)` → `E() ^ x`
  - `open Microsoft.Quantum.{Math,Convert}` → `import Std.{Math,Convert}.*`
  - NewType: `((...))` → `(...)` (removed extra wrapping parens)
  - `new Qubit[n]` → array concatenation; `new (Qubit[])` → incremental build
- Test system: C# `Driver.cs` + `QuantumSimulator` → Python `tools/run_all_tests.py` + Rust native simulator
- Build: .NET 6.0 + `dotnet build` → Python 3.10+ + `pip install qsharp`
- **Total: 310 tests pass, zero old syntax patterns remaining**
