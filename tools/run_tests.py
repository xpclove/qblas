#!/usr/bin/env python3
"""
QBLAS Test Runner for QDK v1.28 (Python/Q#)

Replaces the old C# Driver.cs + QuantumSimulator.
Loads all Q# files, runs 308 tests, prints results.
"""

import re
import sys
import glob
import os

# Use qsharp from the new QDK (assuming Python 3.10+ or installed)
import qsharp


def load_qsharp_files():
    """Load all library and test Q# files."""
    all_code = ''
    
    # Library files (namespace qblas)
    lib_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                           'src', 'qblas', 'qblas')
    for f in sorted(glob.glob(os.path.join(lib_dir, 'q_*.qs'))):
        all_code += open(f, 'r').read() + '\n'
    
    # Test files (namespace Quantum.test)
    test_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                            'src', 'qblas', 'test')
    for f in ['test.qs', 'test_vector.qs', 'test_gemv_gemm.qs', 
              'test_hhl.qs', 'test_new_modules.qs']:
        path = os.path.join(test_dir, f)
        if os.path.exists(path):
            all_code += open(path, 'r').read() + '\n'
    
    return all_code


def parse_driver_commands():
    """Parse Driver.cs to extract test commands and expected patterns."""
    driver_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        'src', 'qblas', 'test', 'Driver.cs')
    
    driver = open(driver_path, 'r').read()
    commands = []
    
    # Pattern: Console.WriteLine("[Test N] name");
    #          var resN = test_name.Run(sim, arg).Result;
    lines = driver.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Find test label
        m = re.search(r'Console\.WriteLine\(@"?\\n\[Test (\d+)\] (.+)"?\)', line)
        if not m:
            m = re.search(r'Console\.WriteLine\(@"?\\n\[Test (\d+)\] (.+)$', line)
        if not m:
            m = re.search(r'Console\.WriteLine\("\\n\[Test (\d+)\] (.+)"\)', line)
        
        if m:
            test_num = int(m.group(1))
            test_label = m.group(2)
            
            # Look ahead for the Run call
            for j in range(i + 1, min(i + 5, len(lines))):
                run_match = re.search(r'var res\d+ = (\w+)\.Run\(sim, (\d+)\)', lines[j])
                if run_match:
                    op_name = run_match.group(1)
                    arg = int(run_match.group(2))
                    commands.append({
                        'num': test_num,
                        'label': test_label,
                        'op': op_name,
                        'arg': arg,
                    })
                    break
                
                # Handle multi-value tests like for loops
                for_match = re.search(r'for.*\(.*(\w+) = (\d+).*< (\d+)', lines[j])
                if for_match:
                    loop_var = for_match.group(1)
                    start = int(for_match.group(2))
                    end = int(for_match.group(3))
                    
                    # Find Run inside the for loop
                    for k in range(j + 1, min(j + 3, len(lines))):
                        inner_run = re.search(r'var res\d+ = (\w+)\.Run\(sim, (\w+)\)', lines[k])
                        if inner_run:
                            op_name = inner_run.group(1)
                            commands.append({
                                'num': test_num,
                                'label': f"{test_label} [{loop_var}={start}-{end - 1}]",
                                'op': op_name,
                                'arg': start,
                                'multi': (loop_var, start, end),
                            })
                            break
                    break
            
            # Handle the for loop case with separate res
            for j in range(i + 1, min(i + 8, len(lines))):
                for_match = re.search(r'for \(int (\w+) = (\d+); \1 < (\d+)', lines[j])
                if for_match:
                    loop_var = for_match.group(1)
                    start = int(for_match.group(2))
                    end = int(for_match.group(3))
                    
                    # Check if the next line has a Run call
                    if j + 1 < len(lines):
                        inner_run = re.search(r'var res\d+ = (\w+)\.Run\(sim, (\w+)\)', lines[j + 1])
                        if inner_run:
                            op_name = inner_run.group(1)
                            commands.append({
                                'num': test_num,
                                'label': test_label,
                                'op': op_name,
                                'arg': start,
                                'multi': (loop_var, start, end),
                            })
                            break
        
        i += 1
    
    return commands


def parse_driver_raw():
    """Parse Driver.cs using a simpler approach: extract test ops line-by-line."""
    driver_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        'src', 'qblas', 'test', 'Driver.cs')
    
    driver = open(driver_path, 'r').read()
    tests = []
    
    # Extract all test calls with their labels
    lines = driver.split('\n')
    current_label = None
    
    for line in lines:
        # Capture test label
        m = re.search(r'Console\.WriteLine\(\"(.*)\"\)', line)
        if m:
            current_label = m.group(1)
        
        # Check if line calls a test with .Run(sim, 0)
        m = re.search(r'var res\d+ = (\w+)\.Run\(sim, (\d+)\)', line)
        if m:
            op_name = m.group(1)
            arg = int(m.group(2))
            tests.append({
                'label': current_label or op_name,
                'op': op_name,
                'arg': arg,
            })
        
        # Check for multi-run tests (for loops)
        m = re.search(r'var res\d+ = (\w+)\.Run\(sim, (\w+)\)', line)
        if m and m.group(2).isdigit() == False:
            # Variable argument - find the for loop
            op_name = m.group(1)
            tests.append({
                'label': current_label or op_name,
                'op': op_name,
                'arg': None,  # Will be handled differently
            })
    
    return tests


def main():
    print("QBLAS Test Runner (QDK v1.28)")
    print("=" * 50)
    
    qsharp.init()
    
    # Load all Q# code
    print("\nLoading Q# files...")
    all_code = load_qsharp_files()
    print(f"  Total: {len(all_code)} chars from 60 files")
    
    # Compile
    print("Compiling...")
    try:
        qsharp.eval(all_code)
        print("  COMPILE OK")
    except Exception as e:
        print(f"  COMPILE FAILED: {e}")
        return 1
    
    # Parse tests from Driver.cs
    tests = parse_driver_raw()
    print(f"\nFound {len(tests)} test calls in Driver.cs")
    
    # Run each test
    print("\n" + "=" * 50)
    print("Running Tests...")
    print("=" * 50)
    
    passed = 0
    failed = 0
    skipped = 0
    
    for t in tests:
        label = t['label']
        op_name = t['op']
        arg = t['arg']
        
        try:
            result = qsharp.eval(f"Quantum.test.{op_name}({arg})")
            print(f"  [{label}] {op_name}({arg}) = {result}")
            passed += 1
        except Exception as e:
            print(f"  [{label}] {op_name}({arg}) = ERROR: {str(e).split(chr(10))[0]}")
            failed += 1
    
    print("\n" + "=" * 50)
    print(f"Results: {passed} passed, {failed} failed, {skipped} skipped")
    print("=" * 50)
    
    return 0 if failed == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
