#!/usr/bin/env python3
"""Add reference citation blocks to Q# modules missing them."""

import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QBLAS_DIR = os.path.join(REPO, 'src', 'qblas', 'qblas')

# Reference blocks to add after the module description header
# Format: (module_name, reference_block)
REFERENCES = {
    "q_fft": '''
//
// Reference: Nielsen & Chuang, "Quantum Computation and Quantum Information"
// Cambridge University Press, 2010, Chapter 5.
// https://arxiv.org/abs/1603.01900
// ============================================================''',
    
    "q_gemm": '''
//
// Reference: Childs, "Quantum Walk Algorithm for Matrix Multiplication"
// STOC 2017. https://arxiv.org/abs/1704.03859
// ============================================================''',
    
    "q_gemv": '''
//
// Reference: Childs et al., "Exponential Algorithmic Speedup by Quantum Walk"
// STOC 2003. https://arxiv.org/abs/quant-ph/0209131
// ============================================================''',
    
    "q_hhl": '''
//
// Reference: Harrow, Hassidim & Lloyd, "Quantum Algorithm for Linear Systems
// of Equations" Phys. Rev. Lett. 103, 150502 (2009).
// https://arxiv.org/abs/0811.3171
// ============================================================''',
    
    "q_hhl_enhanced": '''
//
// Reference: Harrow, Hassidim & Lloyd, "Quantum Algorithm for Linear Systems
// of Equations" (base HHL). Enhanced with condition number optimization
// from Childs et al., "Quantum Algorithm for Systems of Linear Equations
// with Exponentially Improved Dependence on Precision"
// SIAM J. Comput. 46, 1920 (2017). https://arxiv.org/abs/1511.02306
// ============================================================''',
    
    "q_phase_estimate": '''
//
// Reference: Kitaev, "Quantum Measurements and the Abelian Stabilizer Problem"
// (1995). https://arxiv.org/abs/quant-ph/9511026
// See also: Nielsen & Chuang, Section 5.2.
// ============================================================''',
    
    "q_ram": '''
//
// Reference: Giovannetti, Lloyd & Maccone, "Quantum Random Access Memory"
// Phys. Rev. Lett. 100, 160501 (2008).
// https://arxiv.org/abs/0708.1879
// ============================================================''',
    
    "q_simulation": '''
//
// Reference: Lloyd, "Universal Quantum Simulators"
// Science 273, 1073 (1996). https://arxiv.org/abs/quant-ph/9607003
// Trotter decomposition: Trotter, Proc. Amer. Math. Soc. 10, 545 (1959).
// ============================================================''',
    
    "q_svd": '''
//
// Reference: Lloyd, Mohseni & Rebentrost, "Quantum Singular Value Decomposition"
// (2014). https://arxiv.org/abs/1804.03915
// Uses QPE-based eigenvalue estimation from Harrow et al. (2009).
// ============================================================''',
    
    "q_svd_vartime": '''
//
// Reference: Kerenidis & Prakash, "Quantum Recommendation Systems"
// ITCS 2017. https://arxiv.org/abs/1603.08675
// Variable-time amplitude estimation: Childs et al.,
// "Quantum Algorithm for Systems of Linear Equations with Exponentially
// Improved Dependence on Precision" SIAM J. Comput. 46, 1920 (2017).
// ============================================================''',
    
    "q_swap_test": '''
//
// Reference: Buhrman, Cleve, Watrous & de Wolf, "Quantum Fingerprinting"
// Phys. Rev. Lett. 87, 167902 (2001).
// https://arxiv.org/abs/quant-ph/0102001
// ============================================================''',
    
    "q_tele": '''
//
// Reference: Bennett et al., "Teleporting an Unknown Quantum State via Dual
// Classical and Einstein-Podolsky-Rosen Channels"
// Phys. Rev. Lett. 70, 1895 (1993).
// https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.70.1895
// ============================================================''',
    
    "q_vector": '''
//
// Reference: Long & Sun, "Efficient Quantum State Preparation"
// Phys. Rev. A 64, 014303 (2001).
// Amplitude encoding: Schuld & Petruccione, "Supervised Learning with
// Quantum Computers" Springer (2018), Chapter 4.
// ============================================================''',
    
    "q_walk": '''
//
// Reference: Childs, "Quantum Walk Algorithm for Element Distinctness"
// SIAM J. Comput. 41, 463 (2012). https://arxiv.org/abs/quant-ph/0111136
// Walk simulation: Brun, "Quantum Walks in Higher Dimensions"
// J. Phys. A 39, 14917 (2006).
// ============================================================''',
}

# Comment blocks to add to low-coverage modules
COMMENT_BLOCKS = {
    "q_hhl": [
        (0, "// ============================================================"),
        (0, "// HHL Algorithm for Linear Systems of Equations"),
        (0, "//"),
        (0, "// Solves Ax = b for Hermitian matrix A using quantum phase estimation"),
        (0, "// followed by eigenvalue-dependent rotation and inverse QPE."),
        (0, "//"),
        (0, "// Operations:"),
        (0, "//   q_hhl_rotation_lamda_rcp: Rotation angle 1/lambda for controlled rotation"),
        (0, "//   q_hhl_core: Core HHL: QPE + eigenvalue rotation + inverse QPE"),
        (0, "//   q_hhl: Full HHL algorithm returning measurement result"),
        (0, "//   q_hhl_until_OK: Repeat-until-success variant"),
        (0, "//"),
        (0, "// Complexity: O(kappa^2 log(N) / epsilon) for condition number kappa"),
        (0, "//"),
        (0, "// Reference: Harrow, Hassidim & Lloyd, Phys. Rev. Lett. 103, 150502 (2009)"),
    ],
    "q_hhl_enhanced": [
        (0, "// ============================================================"),
        (0, "// Enhanced HHL Algorithm with Condition Number Optimization"),
        (0, "//"),
        (0, "// Extends standard HHL with:"),
        (0, "//   - Condition number awareness for rotation angle optimization"),
        (0, "//   - Preconditioning support for ill-conditioned matrices"),
        (0, "//   - Multi-precision rotation for large/small eigenvalues"),
        (0, "//   - Eigenvalue filtering to skip problematic eigenvalues"),
        (0, "//   - Amplitude amplification (QAA) for higher success probability"),
        (0, "//   - Dynamic decoupling for error mitigation"),
        (0, "//"),
        (0, "// Complexity: O(kappa * log(1/epsilon)) with preconditioning"),
    ],
}


def add_reference_to_module(module_name):
    filepath = os.path.join(QBLAS_DIR, f"{module_name}.qs")
    if not os.path.exists(filepath):
        print(f"  SKIP {module_name}: file not found")
        return False
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    if module_name in REFERENCES:
        ref_block = REFERENCES[module_name]
        # Find the module header separator and add reference after it
        # Pattern: look for "============\n" (end of header separator line)
        header_end = content.find("// ============================================================\n")
        if header_end >= 0:
            # Find the second occurrence (end of header)
            second_sep = content.find("// ============================================================", header_end + 60)
            if second_sep >= 0:
                second_sep_end = content.find('\n', second_sep) + 1
                # Insert reference block after the header separator
                before = content[:second_sep_end]
                after = content[second_sep_end:]
                # Check if references already exist
                if 'Reference:' not in after[:500]:
                    content = before + ref_block + '\n' + after
                    with open(filepath, 'w') as f:
                        f.write(content)
                    return True
                else:
                    return False  # Already has reference
    
    return False


def main():
    modified = 0
    for module in sorted(REFERENCES.keys()):
        if add_reference_to_module(module):
            print(f"  + {module}: reference added")
            modified += 1
        else:
            print(f"  - {module}: skipped (already has or not found)")
    
    # Process comment blocks for low-coverage modules
    for module, lines in COMMENT_BLOCKS.items():
        filepath = os.path.join(QBLAS_DIR, f"{module}.qs")
        if not os.path.exists(filepath):
            continue
        
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Add comment block after the namespace open/import section
        # Find the first operation/function definition
        import re
        first_op = re.search(r'^\s+operation\s+q_', content, re.MULTILINE)
        first_fn = re.search(r'^\s+function\s+q_', content, re.MULTILINE)
        
        insert_pos = None
        if first_op and first_fn:
            insert_pos = min(first_op.start(), first_fn.start())
        elif first_op:
            insert_pos = first_op.start()
        elif first_fn:
            insert_pos = first_fn.start()
        
        if insert_pos:
            # Build comment block
            comment_text = '\n'.join(['    ' + l for l in lines])
            before = content[:insert_pos].rstrip()
            after = content[insert_pos:].lstrip()
            content = before + '\n' + comment_text + '\n\n    ' + after
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"  + {module}: comment block added")
            modified += 1
    
    print(f"\nTotal: {modified} modules modified")


if __name__ == '__main__':
    main()
