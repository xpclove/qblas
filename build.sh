#!/bin/bash
# QBLAS Build & Test Script (QDK v1.28)
# Usage: ./build.sh [clean|test]

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Try Python 3.11 for QDK v1.28 compatibility
PYTHON=""
for p in python3.11 python3.10 python3; do
    if command -v $p &>/dev/null; then
        if $p -c "import qsharp" 2>/dev/null; then
            PYTHON=$p
            break
        fi
    fi
done

if [ -z "$PYTHON" ]; then
    echo "Error: qsharp (QDK v1.28) Python package not found."
    echo "Install: pip install qsharp"
    exit 1
fi

echo "Using: $PYTHON ($($PYTHON -c 'import qsharp; print(qsharp.__version__)'))"

if [ "$1" == "clean" ]; then
    echo "Clean complete (no build artifacts to remove)."
    exit 0
fi

echo ""
echo "=== Compiling & Running QBLAS Tests ==="
$PYTHON "$PROJECT_ROOT/tools/run_all_tests.py"

echo ""
echo "=== Build and Test Complete ==="