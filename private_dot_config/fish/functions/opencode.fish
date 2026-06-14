function opencode --description "Run opencode with MCP secrets sourced from 1Password"
    # `attach` connects to the already-running server (systemd opencode.service),
    # which spawns the MCP processes itself -- the attach client never uses these
    # tokens. Skip the op reads so attaching doesn't trigger a 1Password unlock.
    if test "$argv[1]" = attach
        command opencode $argv
        return
    end

    # Cache secrets in global vars per shell so we only pay the op-read latency
    # once per fish session. The local MCP servers read these via {env:...}
    # interpolation in opencode.json.
    if not set --query __opencode_github_pat
        if command --query op
            set --local pat (op read --account $OP_ACCOUNT --no-newline "op://Employee/OpenCode GitHub MCP/credential" 2>/dev/null)
            if test -n "$pat"
                set --global __opencode_github_pat $pat
            end
        end
    end

    if not set --query __opencode_slack_xoxp
        if command --query op
            set --local token (op read --account $OP_ACCOUNT --no-newline "op://Employee/OpenCode Slack MCP/credential" 2>/dev/null)
            if test -n "$token"
                set --global __opencode_slack_xoxp $token
            end
        end
    end

    GITHUB_PERSONAL_ACCESS_TOKEN=$__opencode_github_pat SLACK_MCP_XOXP_TOKEN=$__opencode_slack_xoxp command opencode $argv
end
