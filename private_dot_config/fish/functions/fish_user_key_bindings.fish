function fish_user_key_bindings
    bind \cp 'set -l file (fzf --preview="cat {}"); and nvim $file'
    bind \cd delete-char
end
