#!/usr/bin/env python3
"""
QBLAS Full Test Runner for QDK v1.28.
Auto-discovers all test_* operations from .qs files.
"""

import re
import sys
import os
import glob

import qsharp


def load_qsharp():
    all_code = ''
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for d in ['src/qblas/qblas', 'src/qblas/test', 'app']:
        dirpath = os.path.join(repo, d)
        for f in sorted(os.listdir(dirpath)):
            if f.endswith('.qs'):
                all_code += open(os.path.join(dirpath, f)).read() + '\n'
    return all_code


def parse_tests():
    """Discover all test_* operations from .qs files."""
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tests = []
    seen = set()
    search_dirs = [
        os.path.join(repo, 'src', 'qblas', 'test'),
        os.path.join(repo, 'app')
    ]

    for test_dir in search_dirs:
        if not os.path.isdir(test_dir):
            continue
        for f in sorted(os.listdir(test_dir)):
            if not f.endswith('.qs'):
                continue
            content = open(os.path.join(test_dir, f)).read()
            for m in re.finditer(r'operation (test_\w+)\(', content):
                op = m.group(1)
                if op not in seen:
                    tests.append((f"{f}: {op}", op, 0))
                    seen.add(op)

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
