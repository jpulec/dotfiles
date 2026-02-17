#!/bin/bash
# install.sh - Bootstrap chezmoi and apply dotfiles
set -e

# Install chezmoi if not present
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize and apply dotfiles from this repo
# If running from the cloned repo, use the current directory
# Otherwise, clone from GitHub
if [ -f "$(dirname "$0")/.chezmoiignore" ]; then
    chezmoi init --source="$(dirname "$0")" --apply
else
    chezmoi init jpulec --apply
fi

echo "Dotfiles applied!"
