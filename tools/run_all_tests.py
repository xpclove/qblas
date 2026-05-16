#!/usr/bin/env python3
"""
QBLAS Full Test Runner for QDK v1.28.
Runs all 316 tests from Driver.cs.
"""

import re
import sys
import os
import glob

import qsharp


def load_qsharp():
    all_code = ''
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for d in ['src/qblas/qblas', 'src/qblas/test']:
        dirpath = os.path.join(repo, d)
        for f in sorted(os.listdir(dirpath)):
            if f.endswith('.qs'):
                all_code += open(os.path.join(dirpath, f)).read() + '\n'
    return all_code


def parse_tests():
    """Extract all test labels and Run calls from Driver.cs."""
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    path = os.path.join(repo, 'src', 'qblas', 'test', 'Driver.cs')
    lines = open(path).read().split('\n')

    tests = []
    cur_label = None

    for i, line in enumerate(lines):
        # Capture label
        m = re.search(r'Console\.WriteLine\((.*)\)', line)
        if m:
            txt = m.group(1).strip('"').strip('@').strip('$')
            cur_label = txt

        # Extract Run calls: var resN = test_op.Run(sim, arg).Result;
        # Also handles: test_op.Run(sim, varName).Result;
        m = re.search(r'var r\w+ = (\w+)\.Run\(sim, (\w+)\)\.Result', line)
        if m:
            op_name = m.group(1)
            arg_str = m.group(2)
            try:
                arg = int(arg_str)
            except ValueError:
                arg = 0  # Variable arguments treated as 0
            tests.append((cur_label or op_name, op_name, arg))

        # Handle for-loop multi-value: run with loop variable
        # Pattern: for (int i = 0; i < N; i++) { var res = op.Run(sim, i).Result; }
        m = re.search(r'for\s*\(int\s+(\w+)\s*=\s*(\d+);\s*\w+\s*<\s*(\d+)', line)
        if m:
            loop_var, start, end = m.group(1), int(m.group(2)), int(m.group(3))
            # Check next lines for Run call
            for j in range(i + 1, min(i + 4, len(lines))):
                m2 = re.search(r'var r\w+ = (\w+)\.Run\(sim, (\w+)\)\.Result', lines[j])
                if m2:
                    op_name = m2.group(1)
                    for val in range(start, end):
                        tests.append((
                            f"{cur_label or op_name} ({loop_var}={val})",
                            op_name, val
                        ))
                    break

    return tests


def main():
    print("QBLAS Full Test Runner (QDK v1.28)")
    print("=" * 60)

    qsharp.init()

    print("\nLoading Q# files...")
    code = load_qsharp()
    print(f"  {len(code)} chars")

    print("Compiling...")
    try:
        qsharp.eval(code)
        print("  COMPILE OK")
    except Exception as e:
        print(f"  COMPILE FAILED: {e}")
        return 1

    tests = parse_tests()
    print(f"\nFound {len(tests)} test calls in Driver.cs")
    print("\n" + "=" * 60)
    print("Running Tests...")
    print("=" * 60)

    passed = 0
    failed = 0
    prev_label = None

    for label, op_name, arg in tests:
        # Deduplicate consecutive same-label tests
        display_label = label if label != prev_label else ""
        prev_label = label

        try:
            result = qsharp.eval(f"Quantum.test.{op_name}({arg})")
            if display_label:
                print(f"\n[{display_label}]")
            print(f"  {op_name}({arg}) = {result}")
            passed += 1
        except Exception as e:
            err_msg = str(e).split('\n')[0][:80]
            if display_label:
                print(f"\n[{display_label}]")
            print(f"  {op_name}({arg}) = ERROR: {err_msg}")
            failed += 1
            if failed >= 20:
                print("\nToo many failures, aborting.")
                break

    print("\n" + "=" * 60)
    print(f"Results: {passed} passed, {failed} failed out of {passed + failed}")
    print("=" * 60)
    return 0 if failed == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
