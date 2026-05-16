#!/usr/bin/env python3
"""D1: Add Fact() assertions to classical tests in test_gemv_gemm.qs + test_vector.qs."""

import re, os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Expected values: (file, test_name, type, expected, tolerance)
ENTRIES = [
    # === SVD (classical) ===
    ("test_gemv_gemm.qs", "test_svd_estimate_condition", "Dbl", 8.0, 1e-10),
    ("test_gemv_gemm.qs", "test_svd_sort_descending", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_svd_filter", "Int", 2, 0),
    ("test_gemv_gemm.qs", "test_svd_normalize", "Int", 4, 0),
    # === HHL (classical) ===
    ("test_gemv_gemm.qs", "test_hhl_check_solution", "Int", 0, 0),
    # === QSVT (classical) ===
    ("test_gemv_gemm.qs", "test_qsvt_normalize_vector", "Int", 4, 0),
    ("test_gemv_gemm.qs", "test_qsvt_check_dims", "Int", 1, 0),
    # === RLS (classical) ===
    ("test_gemv_gemm.qs", "test_q_rls_lambda_cv", "Dbl", 2e-05, 1e-10),
    ("test_gemv_gemm.qs", "test_q_rls_check_lambda", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_q_rls_effective_condition", "Dbl", 9.166666666666666, 1e-10),
    # === BE (classical) ===
    ("test_gemv_gemm.qs", "test_q_be_compute_scaling", "Dbl", 1.118033988749895, 1e-10),
    ("test_gemv_gemm.qs", "test_q_be_check_sparsity", "Int", 1, 0),
    # === Pseudoinverse (classical) ===
    ("test_gemv_gemm.qs", "test_pseudoinverse_coeffs", "Dbl", 4.0, 1e-10),
    ("test_gemv_gemm.qs", "test_pseudoinverse_check", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_pseudoinverse_effective_condition", "Dbl", 11.11111111111111, 1e-10),
    # === Chebyshev (classical) ===
    ("test_gemv_gemm.qs", "test_chebyshev_polynomials", "Dbl", 4.0, 1e-10),
    ("test_gemv_gemm.qs", "test_chebyshev_coefficients", "Dbl", 5.0, 1e-10),
    ("test_gemv_gemm.qs", "test_chebyshev_map", "Dbl", 0.5, 1e-10),
    ("test_gemv_gemm.qs", "test_chebyshev_error_bound", "Dbl", 0.1875, 1e-10),
    ("test_gemv_gemm.qs", "test_chebyshev_select_degree", "Int", 1, 0),
    # === Matrix trace (classical) ===
    ("test_gemv_gemm.qs", "test_matrix_trace_power", "Int", 1, 0),
    # === Eigenvalue filter (classical) ===
    ("test_gemv_gemm.qs", "test_eigenvalue_filter_lowpass", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_eigenvalue_filter_highpass", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_eigenvalue_filter_bandpass", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_eigenvalue_filter_verify", "Int", 0, 0),
    # === GEMM dims (classical) ===
    ("test_gemv_gemm.qs", "test_gemm_check_dims", "Int", 4, 0),
    # === Vector (classical) ===
    ("test_vector.qs", "test_vectors_inner", "Int", 1, 0),
    # === Vector (deterministic quantum) ===
    ("test_vector.qs", "test_creat", "Int", 0, 0),
    ("test_vector.qs", "test_vector_inner", "Int", 1, 0),
    # === D2: Deterministic quantum tests (result consistent across runs) ===
    ("test_gemv_gemm.qs", "test_gemv_diagonal", "Dbl", 0.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemv_iterated", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemv_batch", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_gemm_iterated", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemm_block", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemm_diag_general", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemm_transpose_a", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemm_transpose_b", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_gemm_batch", "Int", 3, 0),
    ("test_gemv_gemm.qs", "test_hhl_enhanced_rotation", "Dbl", 0.0, 1e-10),
    ("test_gemv_gemm.qs", "test_hhl_multiprecision", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_qsvt_apply_diagonal", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_qsvt_amplitude_encode", "Dbl", 1.0, 1e-10),
    ("test_gemv_gemm.qs", "test_q_be_diagonal", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_q_be_householder", "Int", 1, 0),
    ("test_gemv_gemm.qs", "test_q_be_tridiagonal", "Int", 1, 0),
    # === D2: Quantum tests with wider tolerance ===
    ("test_gemv_gemm.qs", "test_1_sparse_bool", "Dbl", 1.0, 0.1),
    ("test_gemv_gemm.qs", "test_1_sparse_integer", "Dbl", 1.0, 0.1),
    # === D2: HHL tests in test_hhl.qs ===
    ("test_hhl.qs", "test_swap_simulation", "Dbl", 1.0, 0.1),
    # === D2: tests in test_hhl.qs ===
    ("test_gemv_gemm.qs", "test_hhl_filtered", "Int", 0, 0),
]


def process_file(filepath, test_dir, entries):
    full_path = os.path.join(test_dir, filepath)
    with open(full_path, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    modified = 0
    has_import = any('Std.Diagnostics.Fact' in l for l in lines)
    
    for test_name, typ, exp_val, tol in entries:
        # Find the test operation
        found_idx = -1
        for i, line in enumerate(lines):
            if f'operation {test_name}(' in line:
                found_idx = i
                break
        
        if found_idx < 0:
            print(f"  SKIP {test_name}: not found")
            continue
        
        # Check if already has Fact
        block = '\n'.join(lines[found_idx:found_idx+20])
        if 'Fact(' in block:
            print(f"  SKIP {test_name}: already has Fact")
            continue
        
        # Find the return statement
        depth = 0
        in_body = False
        for i in range(found_idx, len(lines)):
            for c in lines[i]:
                if c == '{': depth += 1
                elif c == '}': depth -= 1
            if depth == 0 and in_body:
                break
            if '{' in lines[i]:
                in_body = True
                j = i + 1
                # Look for return
                while j < len(lines) and j < i + 15:
                    ret_m = re.match(r'^(\s*)return\s+(.+);', lines[j])
                    if ret_m:
                        indent = ret_m.group(1)
                        ret_expr = ret_m.group(2)
                        
                        if typ == 'Int':
                            fact = f'{indent}let _r = {ret_expr};'
                            fact += f'\n{indent}Fact(_r == {exp_val}, "{test_name}");'
                            fact += f'\n{indent}return _r;'
                        else:
                            fact = f'{indent}let _r = {ret_expr};'
                            fact += f'\n{indent}Fact(AbsD(_r - {exp_val}) < {tol}, "{test_name}");'
                            fact += f'\n{indent}return _r;'
                        
                        lines[j] = fact
                        modified += 1
                        break
                    j += 1
                break
    
    # Add import for Fact if needed
    if modified > 0 and not has_import:
        for i, line in enumerate(lines):
            if 'import Std.Math.*;' in line:
                lines.insert(i + 1, '    import Std.Diagnostics.Fact;')
                break
    
    new_content = '\n'.join(lines)
    with open(full_path, 'w') as f:
        f.write(new_content)
    
    return modified


def main():
    test_dir = os.path.join(REPO, 'src', 'qblas', 'test')
    
    # Group entries by file
    by_file = {}
    for filepath, test_name, typ, exp_val, tol in ENTRIES:
        by_file.setdefault(filepath, []).append((test_name, typ, exp_val, tol))
    
    total = 0
    for filepath, entries in by_file.items():
        n = process_file(filepath, test_dir, entries)
        print(f'{filepath}: {n} tests enhanced')
        total += n
    
    print(f'\nTotal: {total} tests enhanced')


if __name__ == '__main__':
    main()
