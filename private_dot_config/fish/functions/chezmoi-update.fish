function chezmoi-update --description "Update both dotfiles and griever"
    chezmoi update
    git -C $HOME/.local/share/griever pull
    chezmoi apply --source=$HOME/.local/share/griever
end
