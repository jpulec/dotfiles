# Initialize fnm for non-interactive bash (used by OpenCode)
eval "$(fnm env)"

# Auto-switch if .nvmrc or .node-version exists in cwd
if [[ -f .nvmrc || -f .node-version ]]; then
  fnm use --silent-if-unchanged 2>/dev/null
fi
