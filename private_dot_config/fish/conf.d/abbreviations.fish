# Git abbreviations
abbr --add gclone git clone
abbr --add ginit git init
abbr --add gst git status
abbr --add gad git add
abbr --add gadd git add .
abbr --add gmv git mv
abbr --add gmvf git mv -f
abbr --add grm git rm
abbr --add grmf git rm -f
abbr --add grs git reset
abbr --add grsh git reset --hard
abbr --add gci git commit
abbr --add gcia git commit -a
abbr --add gcin git commit -n
abbr --add gcian git commit -an
abbr --add gamend git commit --amend
# AI-assisted commit message generation. Calls Claude with the staged diff and
# opens the editor pre-filled. See ~/.config/fish/functions/git-commit-ai.fish.
abbr --add gca git-commit-ai

# AI-assisted PR drafting. Pushes the branch, generates title + description
# from commits + diff via Claude, then opens `gh pr create` with the result.
# Pass through extra args (e.g. --draft) to gh.
abbr --add ghpr gh-pr-ai
abbr --add gco git checkout
abbr --add gcob git checkout -b
abbr --add gswn git -c core.hooksPath=/dev/null switch
abbr --add gdf git diff
abbr --add gbr git branch
abbr --add gbra git branch -a
abbr --add gbrd git branch -d
abbr --add gbrdf git branch -D
abbr --add gbrm git branch -m
abbr --add glg git log
abbr --add glg1 git log -1
abbr --add gmg git merge
abbr --add gpush git push
abbr --add gpushf git push -f
abbr --add gpull git pull
abbr --add gf git fetch --prune
abbr --add gbi git bisect
abbr --add gbis git bisect start
abbr --add gbig git bisect good
abbr --add gbib git bisect bad
abbr --add grb git rebase
abbr --add grbc git rebase --continue
abbr --add gtag git tag
abbr --add gstash git stash
abbr --add gstashl git stash list
abbr --add gstashp git stash pop
abbr --add gstashd git stash drop
abbr --add gstashs git stash show

# Docker compose abbreviations
abbr --add dco docker-compose
abbr --add dcl docker-compose logs -f
abbr --add dcoup docker-compose up -d
abbr --add dcor docker-compose run --rm
abbr --add dcoru docker-compose run --rm --user (id -u):(id -g)
abbr --add dstop "docker ps --format '{{.ID}}' | xargs --no-run-if-empty docker stop"
abbr --add dcstart "docker-compose up --detach --wait && docker-compose run --rm --workdir=/app api yarn turbo run --filter=@createinc/flux-api --env-mode=loose seed:run"
abbr --add dcbstart "docker-compose up --detach --build && docker-compose run --rm --workdir=/app api yarn turbo run --filter=@createinc/flux-api --env-mode=loose seed:run"
abbr --add dcbs "docker-compose build && docker-compose run --rm --workdir=/app api yarn turbo run --filter=@createinc/flux-api --env-mode=loose seed:run"

# Standard shell command abbreviations

# Processes aliases
abbr --add psa ps aux
abbr --add psg "ps aux | grep"

abbr --add grep grep --color=auto
abbr --add fgrep fgrep --color=auto
abbr --add egrep egrep --color=auto

# enable color support of ls and also add handy aliases
abbr --add ls ls --color=auto
abbr --add ll ls -alF
abbr --add la ls -A
abbr --add l ls -CF

abbr --add oc opencode attach http://localhost:4096 --dir=.

# Chezmoi drift across both sources (dotfiles + griever).
# The starship prompt nags via `!cz` when either has uncommitted changes;
# this is the quick command to see what's drifted.
abbr --add chezdiff "chezmoi diff; and chezmoi diff --source=$HOME/.local/share/griever"

# Neovim abbreviations
# The Snacks dashboard has bindings for diff review (d/D/h). Launching nvim
# with +cmd runs Diffview during startup and races with snacks dashboard,
# bufferline, lazy-loading etc., which breaks file-panel keymaps. Just open
# nvim and press the dashboard key instead.
abbr --add nvd nvim
