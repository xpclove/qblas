#!/usr/bin/env python3
"""
Apply remaining fixes for new QDK migration:
1. open Microsoft.Quantum.Math; -> import Std.Math.*;
2. open Microsoft.Quantum.Convert; -> import Std.Convert.*;
3. PowD(a, b) -> a ^ b
4. ExpD(x) -> E() ^ x
5. IntAsString/DoubleAsString -> $"{p}"

Usage: python3 tools/fix_remaining.py [--dry-run] [files...]
"""

import os
import re
import sys


def fix_file(filepath, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if not content.strip():
        return False

    original = content
    changes = []

    # 1. Fix import namespaces
    if 'open Microsoft.Quantum.Math;' in content:
        content = content.replace('open Microsoft.Quantum.Math;', 'import Std.Math.*;')
        changes.append('Math import')

    if 'open Microsoft.Quantum.Convert;' in content:
        content = content.replace('open Microsoft.Quantum.Convert;', 'import Std.Convert.*;')
        changes.append('Convert import')

    # 2. Fix PowD(a, b) -> a ^ b
    # Match: PowD(expr, expr)
    powd_count = len(re.findall(r'\bPowD\(', content))
    if powd_count > 0:
        # Use a function to handle nested parentheses
        def replace_powd(m):
            inner = m.group(1)
            # Find the comma that separates the two args (top-level)
            depth = 0
            comma_pos = -1
            for i, c in enumerate(inner):
                if c == '(':
                    depth += 1
                elif c == ')':
                    depth -= 1
                elif c == ',' and depth == 0:
                    comma_pos = i
                    break
            if comma_pos < 0:
                return f'({inner})'  # fallback
            base = inner[:comma_pos].strip()
            exp = inner[comma_pos + 1:].strip()
            # Add parens around base or exp if they contain operators
            if re.search(r'[+\-*/]', base) and not (base.startswith('(') and base.endswith(')')):
                base = f'({base})'
            if re.search(r'[+\-*/]', exp) and not (exp.startswith('(') and exp.endswith(')')):
                exp = f'({exp})'
            return f'{base} ^ {exp}'
        
        content = re.sub(r'\bPowD\(([^()]*(?:\([^()]*\)[^()]*)*)\)', replace_powd, content)
        changes.append(f'PowD fix ({powd_count})')

    # 3. Fix ExpD(x) -> E() ^ x
    expd_count = len(re.findall(r'\bExpD\(', content))
    if expd_count > 0:
        def replace_expd(m):
            arg = m.group(1).strip()
            if re.search(r'[+\-*/]', arg) and not (arg.startswith('(') and arg.endswith(')')):
                arg = f'({arg})'
            return f'E() ^ {arg}'
        
        content = re.sub(r'\bExpD\(([^()]*(?:\([^()]*\)[^()]*)*)\)', replace_expd, content)
        changes.append(f'ExpD fix ({expd_count})')

    # 4. Fix IntAsString -> string interpolation
    int_str_count = content.count('IntAsString(')
    if int_str_count > 0:
        content = re.sub(r'IntAsString\(([^()]*)\)', r'$"{\1}"', content)
        changes.append(f'IntAsString fix ({int_str_count})')

    # 5. Fix DoubleAsString -> string interpolation
    dbl_str_count = content.count('DoubleAsString(')
    if dbl_str_count > 0:
        content = re.sub(r'DoubleAsString\(([^()]*)\)', r'$"{\1}"', content)
        changes.append(f'DoubleAsString fix ({dbl_str_count})')

    if content == original:
        return False

    if dry_run:
        print(f"  {os.path.basename(filepath)}: {', '.join(changes)}")
        return True

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"  {os.path.basename(filepath)}: {', '.join(changes)}")
    return True


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        sys.argv.remove('--dry-run')

    if len(sys.argv) < 2:
        repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        dirs = [
            os.path.join(repo_root, 'src', 'qblas', 'qblas'),
        ]
        files = []
        for d in dirs:
            if os.path.isdir(d):
                files.extend(
                    sorted(os.path.join(d, f) for f in os.listdir(d) if f.endswith('.qs'))
                )
    else:
        files = sys.argv[1:]

    print(f"Remaining Fixes Tool (dry_run={dry_run})")
    print(f"Files to process: {len(files)}")
    print()

    changed = 0
    for filepath in files:
        try:
            if fix_file(filepath, dry_run):
                changed += 1
        except Exception as e:
            print(f"  ERROR {os.path.basename(filepath)}: {e}")
            import traceback
            traceback.print_exc()

    print(f"\nFiles changed: {changed}/{len(files)}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
