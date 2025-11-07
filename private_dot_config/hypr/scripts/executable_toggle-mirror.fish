#!/usr/bin/env fish

set mirror_state_file /tmp/hypr-mirror-enabled
set primary_monitor eDP-1

function get_connected_monitors
    hyprctl monitors -j | jq -r '.[].name'
end

function get_resolution
    set monitor_name $argv[1]
    hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor_name\") | .width, .height" | string join "x"
end

if test -e $mirror_state_file
    echo "Reverting to extended mode"
    rm $mirror_state_file

    set xpos 0
    for mon in (get_connected_monitors)
        set res (get_resolution $mon)
        hyprctl dispatch "monitor $mon,$res,$xposx0,1"
        set xpos (math $xpos + (string split x $res)[1])
    end
else
    echo "Enabling mirror mode"
    touch $mirror_state_file

    set res (get_resolution $primary_monitor)
    for mon in (get_connected_monitors)
        hyprctl dispatch "monitor $mon,$res,0x0,1"
    end
end

