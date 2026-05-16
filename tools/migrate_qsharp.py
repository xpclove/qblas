#!/usr/bin/env python3
"""
Q# Syntax Migration Tool: QDK 0.28.x -> QDK 1.x (Rust/Python)

Transforms body { ... } adjoint auto; patterns to inline style.

Pattern 1 (with adjoint auto):
    operation Foo(x : Int) : Unit {
        body {                              <- REMOVE this line
            // code                          <- UN-INDENT by 4 spaces
        }                                   <- REMOVE this line (body closing brace)
        adjoint auto;                       <- REMOVE these 3 lines
        controlled auto;
        controlled adjoint auto;
    }

  =>
    operation Foo(x : Int) : Unit is Adj + Ctl {
        // code
    }

Pattern 2 (plain body, no adjoint):
    operation Foo(x : Int) : Unit {
        body {                              <- REMOVE this line
            // code                          <- UN-INDENT
        }                                   <- REMOVE
    }

  =>
    operation Foo(x : Int) : Unit {
        // code
    }

Usage: python3 tools/migrate_qsharp.py [--dry-run] [files...]
"""

import os
import re
import sys


def find_body_blocks(lines):
    """Find body { ... } [adjoint auto] patterns with correct brace matching."""
    blocks = []
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.rstrip()

        # Match: [indent]body[...]{  (with optional ...)
        m = re.match(r'^(\s*)body\s*(\(\.\.\.\))?\s*\{\s*$', stripped)
        if not m:
            i += 1
            continue

        body_indent = m.group(1)
        body_start = i

        # Find matching closing } of body block via brace depth
        body_end = None
        depth = 1
        for j in range(i + 1, len(lines)):
            for c in lines[j]:
                if c == '{':
                    depth += 1
                elif c == '}':
                    depth -= 1
            if depth == 0:
                body_end = j
                break

        if body_end is None:
            i += 1
            continue

        # Check for adjoint auto; / controlled auto; / controlled adjoint auto; after body_end
        adjoint_lines = []
        k = body_end + 1
        while k < len(lines) and re.match(
            r'^\s*(adjoint auto|controlled auto|controlled adjoint auto);\s*$',
            lines[k].rstrip(),
        ):
            adjoint_lines.append(k)
            k += 1

        has_adjoint = len(adjoint_lines) > 0

        # Find the operation's opening '{' line before body_start.
        # Walk backwards from body_start. The operation's { is on a line that
        # ends with '{' at a shallower indent than body_indent.
        # We look for the FIRST line ending with '{' that is at body_indent - 4 (or less).
        # Actually, the simplest: find the first '{' line at a shallower indent.
        op_brace_line = None
        for b in range(body_start - 1, -1, -1):
            l = lines[b].rstrip()
            if not l:  # blank
                continue
            # Check if this line contains an opening { at a shallower level
            if '{' in l:
                # Compute the indent of the { on this line
                line_indent = len(lines[b]) - len(lines[b].lstrip())
                # The { in the operation signature is at operation indent (4)
                # body_indent is at 8. So op indent should be <= body_indent - 4
                if line_indent <= len(body_indent) - 4:
                    op_brace_line = b
                    break
            # Stop if we hit a function/operation declaration (no brace yet)
            if re.match(r'^\s*(operation|function)\s', l):
                break

        blocks.append({
            'body_start': body_start,
            'body_end': body_end,
            'adjoint_lines': adjoint_lines,
            'has_adjoint': has_adjoint,
            'body_indent': body_indent,
            'op_brace_line': op_brace_line,
        })

        # Advance past everything we consumed
        if adjoint_lines:
            i = adjoint_lines[-1] + 1
        else:
            i = body_end + 1

    return blocks


def add_is_adj_to_header(lines, op_brace_line, body_indent):
    """
    Add 'is Adj + Ctl' to the operation header line (the one with the opening {).
    Works for both single-line and multi-line signatures.
    """
    if op_brace_line is None:
        return False

    line = lines[op_brace_line]
    stripped = line.rstrip()

    # Don't modify if already has is Adj
    if 'is Adj' in stripped:
        return False

    # Check if this line ends with '{'
    # It could be: "    ) : Unit {"  or  "    operation Foo() : Unit {"
    if stripped.endswith('{'):
        # Insert ' is Adj + Ctl' before the opening brace
        new_line = stripped[:-1].rstrip() + ' is Adj + Ctl {'
        lines[op_brace_line] = new_line + '\n' if line.endswith('\n') else new_line
        return True

    return False


def transform_file(filepath, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    blocks = find_body_blocks(lines)

    if not blocks:
        return False

    n_adj = sum(1 for b in blocks if b['has_adjoint'])
    n_plain = sum(1 for b in blocks if not b['has_adjoint'])
    print(f"  {os.path.basename(filepath)}: {len(blocks)} body blocks "
          f"({n_adj} with adjoint, {n_plain} plain)")

    # Process blocks from last to first (preserve line numbers)
    for block in reversed(blocks):
        body_start = block['body_start']
        body_end = block['body_end']
        adjoint_lines = block['adjoint_lines']
        has_adjoint = block['has_adjoint']
        op_brace_line = block['op_brace_line']

        # Body content (between body { and its closing })
        body_content = lines[body_start + 1:body_end]

        # Un-indent by removing 4 spaces from each content line
        unindented = []
        for l in body_content:
            if l.startswith('    '):
                unindented.append(l[4:])
            elif l.strip() == '':
                unindented.append(l)
            else:
                # Already at correct level; keep as-is
                unindented.append(l)

        # Add is Adj + Ctl to operation header line
        if has_adjoint and op_brace_line is not None:
            add_is_adj_to_header(lines, op_brace_line, block['body_indent'])

        # Compute replacement range: from body_start through last adjoint line
        if adjoint_lines:
            replace_end = adjoint_lines[-1] + 1
        else:
            replace_end = body_end + 1

        # Replace: body line + content + closing brace + adjoint lines
        #           with: unindented content
        lines[body_start:replace_end] = unindented

    new_content = '\n'.join(lines)

    if new_content == content:
        return False

    if dry_run:
        return True

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

    print(f"Q# Syntax Migration Tool (dry_run={dry_run})")
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
