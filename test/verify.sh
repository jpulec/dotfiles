#!/bin/bash
# verify.sh - Verify dotfiles installed correctly

PASS=0
FAIL=0

check() {
    local name="$1"
    local cmd="$2"
    
    if eval "$cmd" >/dev/null 2>&1; then
        echo "✓ $name"
        PASS=$((PASS + 1))
    else
        echo "✗ $name"
        FAIL=$((FAIL + 1))
    fi
}

echo "=== Verifying dotfiles installation ==="
echo ""

echo "--- Commands available ---"
check "fish installed" "command -v fish"
check "bat installed" "command -v bat"
check "fzf installed" "command -v fzf"
check "ripgrep installed" "command -v rg"
check "tmux installed" "command -v tmux"
check "zoxide installed" "command -v zoxide"
check "direnv installed" "command -v direnv"
check "gh (GitHub CLI) installed" "command -v gh"

echo ""
echo "--- Config files ---"
check "fish config exists" "test -f ~/.config/fish/config.fish"
check "nvim config exists" "test -f ~/.config/nvim/init.lua"
check "tmux config exists" "test -f ~/.tmux.conf"
check "gitconfig exists" "test -f ~/.gitconfig"
check "ripgreprc exists" "test -f ~/.ripgreprc"

echo ""
echo "--- Fish setup ---"
check "fish is default shell" "getent passwd \$(whoami) | grep -q fish"
check "fisher installed" "fish -c 'type -q fisher'"
check "fish_plugins file exists" "test -f ~/.config/fish/fish_plugins"

check "opencode installed" "command -v opencode"

echo ""
echo "--- Neovim setup ---"
check "lazy.nvim installed" "test -d ~/.local/share/nvim/lazy/lazy.nvim"
check "nvim plugins synced" "test -f ~/.config/nvim/lazy-lock.json"

echo ""
echo "--- Summary ---"
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "Some checks failed!"
    exit 1
else
    echo ""
    echo "All checks passed!"
    exit 0
fi
