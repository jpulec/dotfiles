function __fnm_autoswitch --description "Switch node via fnm based on nearest .nvmrc/.node-version walking upward"
    # Skip when fnm isn't available (e.g. minimal shells).
    type --query fnm
    or return 0

    # Walk from cwd to / looking for a version file.
    set --local dir (pwd --physical)
    set --local found
    while test -n "$dir"
        if test -f "$dir/.node-version"
            set found "$dir/.node-version"
            break
        end
        if test -f "$dir/.nvmrc"
            set found "$dir/.nvmrc"
            break
        end
        if test "$dir" = /
            break
        end
        set dir (dirname "$dir")
    end

    if test -n "$found"
        # Already on this file -> nothing to do (avoids redundant `fnm use`).
        if test "$__fnm_autoswitch_last_file" = "$found"
            return 0
        end
        set --global __fnm_autoswitch_last_file "$found"
        fnm use --silent-if-unchanged --install-if-missing 2>/dev/null
    else
        # No version file in any ancestor -> restore the default if we're not
        # already on it. fnm default version lives in $FNM_DIR/aliases/default.
        if test -n "$__fnm_autoswitch_last_file"
            set --erase __fnm_autoswitch_last_file
            fnm use default --silent-if-unchanged 2>/dev/null
        end
    end
end
