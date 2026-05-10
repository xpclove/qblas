#!/bin/bash
# QBLAS Build Script
# Usage: ./build.sh [clean]

set -e

# Set .NET environment
export DOTNET_ROOT=~/.dotnet
export PATH=$HOME/.dotnet:$PATH

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
QBLAS_DIR="$PROJECT_ROOT/src/qblas/qblas"
TEST_DIR="$PROJECT_ROOT/src/qblas/test"

if [ "$1" == "clean" ]; then
    echo "Cleaning build artifacts..."
    rm -rf "$QBLAS_DIR/bin" "$QBLAS_DIR/obj"
    rm -rf "$TEST_DIR/bin" "$TEST_DIR/obj"
    echo "Clean complete."
    exit 0
fi

echo "=== Building QBLAS Library ==="
cd "$QBLAS_DIR"
dotnet build qblas.csproj -c Debug

echo ""
echo "=== Building Test Project ==="
cd "$TEST_DIR"
dotnet build test.csproj -c Debug

echo ""
echo "=== Running Tests ==="
cd "$TEST_DIR"
dotnet run

echo ""
echo "=== Build and Test Complete ==="