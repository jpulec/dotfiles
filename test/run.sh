#!/bin/bash
# run.sh - Build and run dotfiles tests
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

cd "$REPO_DIR"

echo "=== Building Ubuntu test image ==="
docker build \
    --file test/Dockerfile.ubuntu \
    --tag dotfiles-test:ubuntu \
    .

echo ""
echo "=== Running tests ==="
docker run --rm dotfiles-test:ubuntu

echo ""
echo "=== Tests completed ==="
