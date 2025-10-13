function e2bc
    # -------------------- 1. validate input --------------------
    set -l pgid $argv[1]
    if test -z "$pgid"
        echo "Usage: connect_to_sandbox_by_pg <project_group_id>"
        return 1
    end

    # -------------------- 2. fetch & clean table ---------------
    # strip colour codes so parsing is easier
    set -l rows (e2b sandbox ls | sed 's/\x1b\[[0-9;]*m//g')

    # -------------------- 3. walk through each data row --------
    set -l chosen ''
    for line in (string split -n '\n' -- $rows)
        set -l trimmed (string trim -- $line)

        # skip blank lines and the header/border lines
        if test -z "$trimmed"
            continue
        end
        if string match -q "*Sandbox ID*" -- $trimmed
            continue
        end
        if string match -qr '^[\-\+|]+' -- $trimmed
            continue
        end

        # first whitespace‑delimited field is the sandbox ID
        set -l sandbox_id (string match -r '^[^ ]+' -- $trimmed)

        # metadata JSON (first {...} occurrence on the line)
        set -l metadata (string match -r '\{[^}]*\}' -- $trimmed)[1]
        if test -z "$metadata"
            continue
        end

        # pull out the devServerId value
        set -l devserver (string match -r -g '"devServerId":"([^"]+)' -- $metadata)[1]
        if test -z "$devserver"
            continue
        end

        # project‑group‑id is everything before the first colon
        set -l pgid_on_line (string split ':' -- $devserver)[1]

        if test "$pgid_on_line" = "$pgid"
            set chosen $sandbox_id
            break
        end
    end

    # -------------------- 4. connect or report -----------------
    if test -n "$chosen"
        echo "Connecting to sandbox $chosen …"
        e2b sandbox connect $chosen
    else
        echo "No running sandbox found for project‑group id: $pgid"
        return 1
    end
end
