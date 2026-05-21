# Per-repo config for escher, sourced by wt-workspace and wt-workspace-create.
# All variables are set with `--global --export` so child processes inherit them.

set --global --export WT_REPO_DIR "$HOME/Dev/Anything/escher-wt"

# Hyprland workspace name = workspace prefix + worktree name.
set --global --export WT_WORKSPACE_PREFIX ""

# Branch name = branch prefix + worktree name. Escher uses "_<name>".
set --global --export WT_BRANCH_PREFIX "_"

# Symlink local docker-compose overrides into a per-worktree path (optional).
set --global --export WT_COMPOSE_OVERRIDE_SRC "$WT_REPO_DIR/.anything/docker-compose.local.yml"
set --global --export WT_COMPOSE_OVERRIDE_DEST "apps/flux/.docker-compose.local.yml"

# Doppler:
#   yaml  - run `doppler setup -f` once at the worktree root (uses doppler.yaml)
#   apps  - per-app loop using WT_DOPPLER_APPS pairs ("dir:project")
#   none  - skip
#
# Escher has a comprehensive `doppler.yaml` at each worktree root mapping every
# app subdirectory to its project (covers apps/flux/* AND apps/anyone/* AND
# auxiliary projects like coworker and secret-service). yaml mode picks up all
# of them, so we don't have to maintain a parallel WT_DOPPLER_APPS list here.
set --global --export WT_DOPPLER_MODE "yaml"
set --global --export WT_DOPPLER_CONFIG "dev_personal"

# Install command run inside the new worktree (empty to skip).
set --global --export WT_INSTALL_CMD "yarn install"

# Extra lines appended to the generated .envrc (newline-separated).
set --global --export WT_EXTRA_ENVRC "export COMPOSE_PROJECT_NAME=\$worktree_name"
