function chezmoi-hierarchical --description "Apply both dotfiles and griever configs"
    chezmoi apply $argv
    chezmoi apply --source=$HOME/.local/share/griever $argv
end
