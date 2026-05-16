#!/usr/bin/env python3
"""Fix using (...) { ... } -> use ...; pattern, properly handling scope braces."""

import re
import sys

def fix_using_in_file(filepath, dry_run=False):
    with open(filepath) as f:
        lines = f.readlines()

    # Find all opening braces and their positions
    # using must be at start of line (possibly with indentation)
    changes = 0
    i = 0
    while i < len(lines):
        line = lines[i]
        m = re.match(r'^(\s*)using\s*\((\w+)\s*=\s*Qubit\[(\d+)\]\s*\)\s*\{\s*$', line)
        if m:
            indent = m.group(1)
            var_name = m.group(2)
            size = m.group(3)
            
            # Replace: using (var = Qubit[N]) {
            # With:    { use var = Qubit[N];
            lines[i] = f"{indent}{{ use {var_name} = Qubit[{size}];\n"
            
            # Now we need to find the matching closing '}' at the same indent level
            # The using block has its own closing }. We add an opening {,
            # so the existing } stays as the scope closer.
            
            changes += 1
            if not dry_run:
                print(f"  Fixed using at line {i+1}")
            
            # Skip to the closing brace by tracking depth
            depth = 1  # the '{' we added counts
            j = i + 1
            found_close = False
            while j < len(lines):
                # Don't count braces in comments
                stripped = lines[j].strip()
                if stripped.startswith('//'):
                    j += 1
                    continue
                for c in lines[j]:
                    if c == '{':
                        depth += 1
                    elif c == '}':
                        depth -= 1
                        if depth == 0:
                            found_close = True
                            break
                if found_close:
                    break
                j += 1
            
            if found_close:
                # The closing '}' at lines[j] is now the closer for our added '{'
                # It should stay as-is
                pass
            
            i = j
        
        i += 1

    if changes == 0:
        return False

    if dry_run:
        print(f"  {filepath}: {changes} using blocks to fix")
        return True

    with open(filepath, 'w') as f:
        f.writelines(lines)
    print(f"  {filepath}: {changes} using blocks fixed")
    return True

def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        sys.argv.remove('--dry-run')
    
    files = sys.argv[1:] if len(sys.argv) > 1 else []
    if not files:
        print("Usage: python3 tools/fix_using.py [--dry-run] file1.qs [file2.qs ...]")
        return 1
    
    changed = 0
    for f in files:
        if fix_using_in_file(f, dry_run):
            changed += 1
    print(f"\nFiles changed: {changed}/{len(files)}")
    return 0

if __name__ == '__main__':
    sys.exit(main())
