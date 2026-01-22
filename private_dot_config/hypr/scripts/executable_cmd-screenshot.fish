#!/usr/bin/fish

if test -f ~/.config/user-dirs.dirs
    source ~/.config/user-dirs.dirs
end

set --local OUTPUT_DIR $HOME/Pictures
if set --query XDG_PICTURES_DIR
    set OUTPUT_DIR $XDG_PICTURES_DIR
end

if not test -d "$OUTPUT_DIR"
    notify-send "Screenshot directory does not exist: $OUTPUT_DIR" -u critical -t 3000
    exit 1
end

set --local mode region
if set --query argv[1]
    set mode $argv[1]
end

pkill slurp 2>/dev/null
hyprshot -m $mode --raw |
  satty --filename - \
    --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    --save-after-copy \
    --copy-command 'wl-copy'
