function git-commit-ai --description "Generate a Conventional Commits message from staged diff using Claude"
    # Capture as a single string. Fish splits command-sub output on newlines;
    # `string collect` preserves it as one element so later `string sub` can
    # truncate the whole diff, not line-by-line.
    set --local staged_diff (git diff --cached 2>/dev/null | string collect)
    if test -z "$staged_diff"
        echo "Nothing staged. Run `git add` first." >&2
        return 1
    end

    # Fetch the key NOW so 1Password's prompt appears immediately. Cached
    # in a global var per shell so subsequent calls skip the prompt entirely.
    # If 1Password is locked, `op read` triggers the desktop unlock modal.
    if not set --query __git_commit_ai_anthropic_key
        echo "Fetching API key from 1Password (modal may appear if locked)..." >&2
        set --local key (op read --account $OP_ACCOUNT --no-newline "op://Employee/Anthropic API Key/credential")
        if test -z "$key"
            echo "Failed to read Anthropic API key from 1Password." >&2
            return 1
        end
        set --global __git_commit_ai_anthropic_key $key
    end

    set --local system_prompt "You write Conventional Commits messages. Output ONLY the message itself -- no markdown, no explanation, no surrounding quotes. Use lowercase subject (no period). Body is optional; include only when meaningful. Format: <type>(<scope>): <subject>\\n\\n<body>"

    # Truncate to keep payload bounded.
    set --local diff_truncated (string sub --length 12000 -- $staged_diff)

    # Pipe the diff into jq via stdin rather than passing as --arg, which would
    # blow ARG_MAX on large diffs. jq's --raw-input --slurp reads stdin as one
    # string accessible via `.`
    set --local user_content "Write a commit message for this diff:

$diff_truncated"

    set --local payload (
        printf '%s' $user_content | jq --raw-input --slurp \
            --arg model "claude-haiku-4-5" \
            --arg system "$system_prompt" \
            '{
                model: $model,
                max_tokens: 200,
                system: $system,
                messages: [{role: "user", content: .}]
            }'
    )

    # POST the payload via stdin too -- avoids embedding a multi-KB body in a
    # shell argument.
    set --local response (
        printf '%s' $payload | curl --silent --max-time 15 \
            -X POST https://api.anthropic.com/v1/messages \
            -H "x-api-key: $__git_commit_ai_anthropic_key" \
            -H "anthropic-version: 2023-06-01" \
            -H "content-type: application/json" \
            --data-binary @-
    )

    set --local message (echo $response | jq -r '.content[0].text // empty')

    if test -z "$message"
        echo "Failed to generate commit message. API response:" >&2
        echo $response | jq . >&2
        return 1
    end

    # Open the editor pre-filled with the message so user can review/edit.
    git commit -e -m $message $argv
end
