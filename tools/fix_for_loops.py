#!/usr/bin/env python3
"""
Fix Q# for loop syntax: QDK 0.28.x -> QDK 1.x

Old: for (i in 0 .. n - 1) {
     for (i in 0 .. (nbit - 1) / 2) {
New: for i in 0 .. n - 1 {
     for i in 0 .. (nbit - 1) / 2 {

Usage: python3 tools/fix_for_loops.py [--dry-run] [files...]
"""

import os
import re
import sys


def find_matching_paren(s, start):
    """Find matching ) for ( at position start in string s."""
    depth = 1
    pos = start + 1
    while pos < len(s) and depth > 0:
        if s[pos] == '(':
            depth += 1
        elif s[pos] == ')':
            depth -= 1
        if depth > 0:
            pos += 1
    return pos if depth == 0 else -1


def fix_for_loops_in_file(content):
    """Fix all for (...) patterns line by line."""
    lines = content.split('\n')
    result = []

    for line in lines:
        # Find 'for(' or 'for (' 
        m = re.search(r'(\s*)for\s*\(', line)
        if not m:
            result.append(line)
            continue

        indent = m.group(1)
        start_pos = m.start() + len(m.group(0)) - 1  # position of '('
        
        # Find matching ')'
        close_pos = find_matching_paren(line, start_pos)
        
        if close_pos == -1:
            # Unclosed paren on this line - unlikely in QBLAS code
            result.append(line)
            continue
        
        # Extract the loop body (between parens)
        loop_body = line[start_pos + 1:close_pos]
        
        # Everything after the closing ')'
        after = line[close_pos + 1:]
        
        # Build new line
        new_line = f"{indent}for {loop_body}{after}"
        result.append(new_line)

    return '\n'.join(result)


def transform_file(filepath, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = fix_for_loops_in_file(content)

    if new_content == content:
        return False

    old_count = content.count('for (')
    new_count = new_content.count('for (')
    fixed = old_count - new_count
    msg = (f"  {os.path.basename(filepath)}: {fixed} for-loop fixes"
           if not dry_run else
           f"  {os.path.basename(filepath)}: {fixed} for-loop fixes (dry-run)")

    if dry_run:
        print(msg)
        return True

    print(msg)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    return True


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        sys.argv.remove('--dry-run')

    if len(sys.argv) < 2:
        repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        dirs = [
            os.path.join(repo_root, 'src', 'qblas', 'qblas'),
            os.path.join(repo_root, 'src', 'qblas', 'test'),
        ]
        files = []
        for d in dirs:
            if os.path.isdir(d):
                files.extend(
                    sorted(os.path.join(d, f) for f in os.listdir(d) if f.endswith('.qs'))
                )
    else:
        files = sys.argv[1:]

    print(f"For-loop Syntax Fix Tool (dry_run={dry_run})")
    print(f"Files to process: {len(files)}")
    print()

    changed = 0
    for filepath in files:
        try:
            if transform_file(filepath, dry_run):
                changed += 1
        except Exception as e:
            print(f"  ERROR {os.path.basename(filepath)}: {e}")
            import traceback
            traceback.print_exc()

    print(f"\nFiles changed: {changed}/{len(files)}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
