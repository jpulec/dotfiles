if status --is-interactive
  powerline-daemon -q
  set fish_function_path $fish_function_path "/usr/lib/python3.9/site-packages/powerline/bindings/fish"
  powerline-setup
end

set -gx EDITOR nvim
set -gx PATH ~/.gem/ruby/2.5.0/bin $PATH
# set -gx PATH ~/.config/fnm/bin $PATH

# set -gx PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Processes aliases
alias psa="ps aux"
alias psg="ps aux | grep "

# Git aliases
alias gclone='git clone'
alias ginit='git init'
alias gst='git status'
alias gad='git add'
alias gadd='git add .'
alias gmv='git mv'
alias gmvf='git mv -f'
alias grm='git rm'
alias grmf='git rm -f'
alias grs='git reset'
alias grsh='git reset --hard'
alias gci='git commit'
alias gcia='git commit -a'
alias gcin='git commit -n'
alias gcian='git commit -an'
alias gamend='git commit --amend'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gdf='git diff'
alias gbr='git branch'
alias gbra='git branch -a'
alias gbrd='git branch -d'
alias gbrdf='git branch -D'
alias gbrm='git branch -m'
alias glg='git log'
alias glg1='git log -1'
alias gmg='git merge'
alias gpush='git push'
alias gpushf='git push -f'
alias gpull='git pull'
alias gf='git fetch --prune'
alias gbi='git bisect'
alias gbis='git bisect start'
alias gbig='git bisect good'
alias gbib='git bisect bad'
alias grb='git rebase'
alias grbc='git rebase --continue'
alias gtag='git tag'
alias gstash='git stash'
alias gstashl='git stash list'
alias gstashp='git stash pop'
alias gstashd='git stash drop'
alias gstashs='git stash show'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# docker aliases
alias dco="docker-compose"
alias dcl="docker-compose logs -f"
alias dcoup="docker-compose up -d"
alias dcor="docker-compose run --rm"
alias dcoru="docker-compose run --rm --user (id -u):(id -g)"

alias docker-compose="docker compose"

# Set ripgrep as default for FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore-vcs --hidden'

#eval (dircolors -c ~/.dircolors/dircolors.ansi-dark)

set -g -x COMPOSE_HTTP_TIMEOUT 200

set -g -x PIPENV_VENV_IN_PROJECT 1

set pipenv_fish_fancy yes 

set -xg LOCAL_TUNNEL https://jpulec.ngrok.io

set -xg RIPGREP_CONFIG_PATH ~/.ripgreprc


direnv hook fish | source
