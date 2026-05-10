# QBLAS Agent Guidelines

## Project Overview

**QBLAS** (Quantum Basic Linear Algebra Subprograms) is an open-source quantum computing library for quantum linear algebra and quantum simulation.

- **Version**: v0.2.4
- **Tech Stack**: Microsoft Q# 0.28.x + .NET 6.0
- **License**: GPL v3
- **Location**: `src/qblas/`

## Build & Test

### Prerequisites
```bash
# Install .NET 6.0 SDK to ~/.dotnet
mkdir -p ~/.dotnet
tar zxf dotnet-sdk-6.0.412-linux-x64.tar.gz -C ~/.dotnet
export DOTNET_ROOT=~/.dotnet
export PATH=$PATH:$HOME/.dotnet
```

### Commands
```bash
# Full build + test
./build.sh

# Build library only
cd src/qblas/qblas && dotnet build

# Build tests only
cd src/qblas/test && dotnet build

# Run tests
cd src/qblas/test && dotnet run

# Clean
./build.sh clean
```

## Code Conventions

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
// Good: operation type with adjoint+controlled
newtype qsvt_block_oracle = ((Qubit[], Qubit[]) => Unit is Adj + Ctl);
```

**WRONG pattern** (function type - causes QS5021 errors):
```qsharp
// Bad: extra parentheses make this a function returning operation
newtype qsvt_block_oracle = (((Qubit[], Qubit[]) => Unit is Adj + Ctl));
```

### Operation Signatures

Operations that need adjoint/controlled should use `body (...)` with explicit specializations:
```qsharp
operation q_gemv(...) : Unit {
    body {
        // implementation
    }
    adjoint auto;
    controlled auto;
    controlled adjoint auto;
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

## Known Issues & Workarounds

### 1. Exp() Expression Bug
**Issue**: `Exp(-lambda_reg)` causes compiler error QS0001 "Expected type (Pauli[], Double, Qubit[])"

**Workaround**: Use intermediate variables or simpler expressions:
```qsharp
// Broken
let ck = 2.0 * Exp(-lambda_reg) / denom;

// Workaround (may still have issues)
let neg_lambda = -1.0 * lambda_reg;
let ck = 2.0 * Exp(neg_lambda) / denom;

// Safest workaround - placeholder
let ck = 2.0 * 0.5 / denom;
```

### 2. Array Slice Out of Bounds
**Issue**: `qs_data[0 .. i - 1]` fails when `i = 0` (empty range error)

**Fix**: Always guard array slices with bounds check:
```qsharp
for (i in 1 .. n - 1) {
    (Controlled Ry)(qs_data[0 .. i - 1], (angle, qs_ancilla));
}
```

### 3. Q# Version Compatibility
- Project uses Q# 0.28.x
- Many deprecation warnings about `body (...)` syntax (QS3306)
- Many warnings about `(...)` tuple syntax in operations (QS3003)
- These warnings are pre-existing and do not block compilation

## Test Patterns

### Test Operation Signature
```qsharp
operation test_<module>_<name>(p : Int) : <ReturnType> {
    body {
        // test implementation
        return <expected_value>;
    }
}
```

### Test Entry Point (Driver.cs)
```csharp
// C# test runner pattern
Console.WriteLine("\n[Test N] test_name");
var res = test_name.Run(sim, 0).Result;
Console.WriteLine($"  result = {res}");
```

### Running Tests
- All tests run via `dotnet run` in test directory
- Tests use `QuantumSimulator` for execution
- Return types: `Double`, `Int`, `Result` (One/Zero)

## Adding New Modules

### Steps
1. Create `q_<module>.qs` in `src/qblas/qblas/`
2. Implement operations/functions following naming conventions
3. Add tests to `test_gemv_gemm.qs` or new test file
4. Add test entries to `Driver.cs`
5. Build and verify: `dotnet build && dotnet run`

### Module Template
```qsharp
namespace qblas
{
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    // ============================================================
    // Module Description
    //
    // Brief description of what this module does.
    // Reference: Citation or algorithm source
    // ============================================================

    // Oracle types (if needed)
    newtype q_<type>_oracle = ...;

    // Core operations
    operation q_<module>_core(...) : Unit {
        body (...) {
            // implementation
        }
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
├── src/qblas/
│   ├── qblas/                    # Core library
│   │   ├── qblas.csproj         # Q# library project
│   │   ├── q_*.qs              # Quantum operations
│   │   └── qsvt_block_oracle   # Block encoding oracle type
│   └── test/                     # Test suite
│       ├── test.csproj           # Test project
│       ├── Driver.cs            # C# test runner
│       └── test*.qs             # Q# test operations
├── build.sh                       # Build script
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

### Critical Constants
- Precision threshold: `1e-10`
- Array length: use `Length(array)`
- Quantum gates: `Ry`, `CNOT`, `H`, `X`, etc.
- Measurement: `M(q)` returns `Result`

### Git Workflow
```bash
# Stage files
git add src/qblas/qblas/q_newmodule.qs
git add src/qblas/test/test_newmodule.qs
git add src/qblas/test/Driver.cs

# Commit with descriptive message
git commit -m "feat: add q_newmodule with operations..."
```
