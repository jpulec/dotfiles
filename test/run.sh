#!/bin/bash
# run.sh - Build and run dotfiles tests
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

cd "$REPO_DIR"

# Parse arguments
DISTROS="${1:-all}"

run_test() {
    local distro="$1"
    echo ""
    echo "========================================"
    echo "  Testing on: $distro"
    echo "========================================"
    echo ""
    
    echo "==> Building $distro test image..."
    docker build \
        --file "test/Dockerfile.$distro" \
        --tag "dotfiles-test:$distro" \
        .
    
    echo ""
    echo "==> Running tests on $distro..."
    docker run --rm "dotfiles-test:$distro"
}

if [ "$DISTROS" = "all" ]; then
    run_test "ubuntu"
    run_test "arch"
elif [ "$DISTROS" = "ubuntu" ] || [ "$DISTROS" = "arch" ]; then
    run_test "$DISTROS"
else
    echo "Usage: $0 [all|ubuntu|arch]"
    echo "  all    - Test on both Ubuntu and Arch (default)"
    echo "  ubuntu - Test on Ubuntu only"
    echo "  arch   - Test on Arch only"
    exit 1
fi

echo ""
echo "========================================"
echo "  All tests completed successfully!"
echo "========================================"
