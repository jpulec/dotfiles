if status --is-interactive
  powerline-daemon -q
  set fish_function_path $fish_function_path "/usr/lib/python3.11/site-packages/powerline/bindings/fish"
  powerline-setup
end

set -gx EDITOR nvim
set -gx PATH ~/.gem/ruby/2.5.0/bin $PATH
set -gx PATH ~/.npm-global/bin $PATH
# set -gx PATH ~/.config/fnm/bin $PATH

# set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

## Aliases
# Alias sudo so that aliases work
alias sudo='sudo '
alias docker-compose="docker compose"

# Set ripgrep as default for FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden'

#eval (dircolors -c ~/.dircolors/dircolors.ansi-dark)

set -g -x COMPOSE_HTTP_TIMEOUT 200

set -g -x PIPENV_VENV_IN_PROJECT 1

set pipenv_fish_fancy yes

set -xg LOCAL_TUNNEL https://jpulec.ngrok.io

set -xg RIPGREP_CONFIG_PATH ~/.ripgreprc

# Bat stuff
set -xg BAT_THEME Dracula


direnv hook fish | source

set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

set -x GPG_TTY (tty)


# Auto set using nvmrc
function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null
end
__nvm_auto

