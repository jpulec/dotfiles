# Tool init scripts. These run in every shell; keep them lean.

# Smart cd
zoxide init fish | source

# Per-directory env
direnv hook fish | source

# Node version manager. Initialize fnm env (PATH, FNM_*), but skip its built-in
# --use-on-cd hook -- that only checks the *current* directory and never walks
# up, so cd-ing into a repo subfolder loses the repo's pinned version.
# We install our own on-cd hook below that searches upward for .nvmrc /
# .node-version and falls back to the default version when leaving any project.
fnm env --shell fish | source

# docker-compose -> docker compose
alias docker-compose="docker compose"
# Alias sudo so that aliases work
alias sudo='sudo '
