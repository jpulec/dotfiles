#!/usr/bin/env fish

set --local mirror_state_file /tmp/hypr-mirror-enabled
set --local primary_monitor eDP-1

function get_connected_monitors
    hyprctl monitors -j | jq -r '.[].name'
end

function get_resolution
    set --local monitor_name $argv[1]
    hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor_name\") | .width, .height" | string join "x"
end

if test -e $mirror_state_file
    echo "Reverting to extended mode"
    rm $mirror_state_file

    set --local xpos 0
    for mon in (get_connected_monitors)
        set --local res (get_resolution $mon)
        set --local position "$xpos"x0
        hyprctl keyword monitor "$mon,$res,$position,1"
        set xpos (math $xpos + (string split x $res)[1])
    end
else
    echo "Enabling mirror mode"
    touch $mirror_state_file

    set --local res (get_resolution $primary_monitor)
    for mon in (get_connected_monitors)
        hyprctl keyword monitor "$mon,$res,0x0,1"
    end
end
