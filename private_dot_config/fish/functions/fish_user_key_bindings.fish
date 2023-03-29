function fish_user_key_bindings
    bind \cp 'set -l file (fzf --ansi --preview="bat --color=always --style=numbers,grid,changes {}"); and nvim $file'
    bind \cd delete-char
end
