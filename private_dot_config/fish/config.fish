set --global --export EDITOR nvim
fish_add_path ~/.local/bin
fish_add_path ~/.local/share/gem/ruby/3.3.0/bin
fish_add_path ~/.npm-global/bin
set --global --export NODE_OPTIONS "--experimental-sqlite"

# Initialize zoxide (smart cd)
zoxide init fish | source

## Aliases
# Alias sudo so that aliases work
alias sudo='sudo '
alias docker-compose="docker compose"

# Set ripgrep as default for FZF
set --global --export FZF_DEFAULT_COMMAND 'rg --files --hidden'

set --global --export COMPOSE_HTTP_TIMEOUT 200
set --global --export PIPENV_VENV_IN_PROJECT 1
set --global pipenv_fish_fancy yes

# TODO: Consider dropping this in favor of cloudflared or something else
set --global --export LOCAL_TUNNEL https://jpulec.ngrok.io
set --global --export RIPGREP_CONFIG_PATH ~/.ripgreprc

# Bat stuff
set --global --export BAT_THEME Dracula

direnv hook fish | source

set --global --export SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
set --global --export GPG_TTY (tty)

# Auto set using nvmrc
function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null
end
__nvm_auto

if status --is-interactive
  set --global fish_key_bindings fish_default_key_bindings

  # Theme colors
  set --global fish_color_autosuggestion brblack
  set --global fish_color_cancel -r
  set --global fish_color_command blue
  set --global fish_color_comment red
  set --global fish_color_cwd green
  set --global fish_color_cwd_root red
  set --global fish_color_end green
  set --global fish_color_error brred
  set --global fish_color_escape brcyan
  set --global fish_color_history_current --bold
  set --global fish_color_host normal
  set --global fish_color_host_remote yellow
  set --global fish_color_normal normal
  set --global fish_color_operator brcyan
  set --global fish_color_param cyan
  set --global fish_color_quote yellow
  set --global fish_color_redirection cyan --bold
  set --global fish_color_search_match white --background=brblack
  set --global fish_color_selection white --bold --background=brblack
  set --global fish_color_status red
  set --global fish_color_user brgreen
  set --global fish_color_valid_path --underline
  set --global fish_pager_color_completion normal
  set --global fish_pager_color_description yellow -i
  set --global fish_pager_color_prefix normal --bold --underline
  set --global fish_pager_color_progress brwhite --background=cyan
  set --global fish_pager_color_selected_background -r

  powerline-daemon -q
  set --global fish_function_path $fish_function_path "/usr/lib/python3.14/site-packages/powerline/bindings/fish"
  powerline-setup
end
