function gh-pr-ai --description "Open a PR with an AI-drafted title + description"
    # Resolve base branch. Caller can override with --base <branch>; the same
    # arg is passed through to `gh pr create` later so the PR targets the same
    # base it was drafted against.
    set --local base_branch
    set --local i 1
    while test $i -le (count $argv)
        if test $argv[$i] = --base
            set base_branch $argv[(math $i + 1)]
            break
        end
        if string match -q -- '--base=*' $argv[$i]
            set base_branch (string replace -- '--base=' '' $argv[$i])
            break
        end
        set i (math $i + 1)
    end

    if test -z "$base_branch"
        if git show-ref --verify --quiet refs/remotes/origin/main
            set base_branch main
        else if git show-ref --verify --quiet refs/remotes/origin/master
            set base_branch master
        else
            echo "Could not determine base branch (no origin/main or origin/master). Pass --base <branch>." >&2
            return 1
        end
    end
    printf '[trace] base branch: %s\n' $base_branch >&2

    printf '[trace] computing merge-base...\n' >&2
    set --local merge_base (git merge-base HEAD origin/$base_branch 2>/dev/null)
    or return $status
    if test -z "$merge_base"
        echo "No merge-base with origin/$base_branch. Did you forget to push or fetch?" >&2
        return 1
    end
    printf '[trace] merge-base: %s\n' $merge_base >&2

    # Use `string collect` everywhere we capture multi-line output. Without it,
    # fish splits on newlines and the variable becomes a list -- breaks both
    # `string sub --length` (operates per element) and any `string length` call
    # in a substitution context (echoes once per element).
    printf '[trace] reading commits since merge-base...\n' >&2
    set --local commits (git log --reverse --pretty=format:'%s%n%n%b%n---' $merge_base..HEAD | string collect)
    or return $status
    if test -z "$commits"
        echo "No commits to open a PR for." >&2
        return 1
    end
    printf '[trace] commits length: %s chars\n' (string length -- "$commits") >&2

    # Fetch the key NOW so 1Password's prompt appears before we compute the diff.
    # If 1Password is locked, `op read` triggers the desktop unlock modal
    # automatically.
    if not set --query __git_commit_ai_anthropic_key
        printf 'Fetching API key from 1Password (may prompt for unlock)...\n' >&2
        set --local key (op read --account $OP_ACCOUNT --no-newline "op://Employee/Anthropic API Key/credential")
        or return $status
        if test -z "$key"
            printf 'Failed to read Anthropic API key from 1Password.\n' >&2
            return 1
        end
        printf '[trace] key length: %s chars\n' (string length -- "$key") >&2
        set --global __git_commit_ai_anthropic_key $key
    else
        printf '[trace] using cached API key from this shell\n' >&2
    end

    printf '[trace] running git diff --stat...\n' >&2
    set --local diff_stat (git diff --stat $merge_base..HEAD | string collect)
    or return $status
    printf '[trace] diff_stat: %s chars\n' (string length -- "$diff_stat") >&2

    # Sanity-check: if the diff stat is enormous, the merge-base is probably
    # stale (e.g. origin/main hasn't been fetched recently), or the wrong
    # base was selected. A normal PR has tens of changed files; thousands
    # means something's off. Bail before computing the full diff.
    set --local stat_size (string length -- "$diff_stat")
    if test $stat_size -gt 50000
        printf 'Diff stat is %s chars (~%s files changed).\n' $stat_size (count (string split \n -- "$diff_stat")) >&2
        printf 'This is too large; use --base <branch> to target the correct base.\n' >&2
        printf 'Current merge-base: %s\n' $merge_base >&2
        return 1
    end

    printf '[trace] running git diff (full)...\n' >&2
    set --local diff_body (git diff $merge_base..HEAD | string collect)
    or return $status
    printf '[trace] diff_body: %s chars\n' (string length -- "$diff_body") >&2

    set --local system_prompt "You write GitHub PR titles and descriptions. Output two parts separated by a literal '---' line:

1. First line: a concise, lowercase Conventional Commits style title (no period, no markdown).
2. Then '---' on its own line.
3. Then a markdown body with these sections:
   ## Summary
   <2-4 sentences on what changed and why>

   ## Changes
   <bullet list of notable changes>

   ## Testing
   <how to verify; or 'covered by existing tests' if appropriate>

Do not include surrounding code fences, quotes, or commentary."

    # Truncate large diffs to a reasonable size for the model + ARG_MAX safety.
    # 100KB ~ 25K tokens, well within the model's 200K input limit, and leaves
    # room for the system prompt + commits + diff_stat.
    set --local diff_truncated (string sub --length 100000 -- $diff_body)

    set --local user_content "Write a PR title and description.

Commits on this branch:
$commits

Diff stat:
$diff_stat

Full diff (truncated to 40KB):
$diff_truncated"

    # Pipe the user content into jq via stdin to avoid ARG_MAX blowups on
    # large diffs. `jq --raw-input --slurp` reads stdin as one string in `.`.
    printf '[trace] building jq payload...\n' >&2
    set --local payload (
        printf '%s' $user_content | jq --raw-input --slurp \
            --arg model "claude-sonnet-4-5" \
            --arg system "$system_prompt" \
            '{
                model: $model,
                max_tokens: 1500,
                system: $system,
                messages: [{role: "user", content: .}]
            }' | string collect
    )
    or return $status
    printf '[trace] payload: %s chars\n' (string length -- "$payload") >&2

    printf 'Drafting PR description with Claude...\n' >&2
    # Pipe the payload to curl via stdin too -- avoids embedding it in argv.
    set --local response (
        printf '%s' $payload | curl --silent --max-time 60 \
            -X POST https://api.anthropic.com/v1/messages \
            -H "x-api-key: $__git_commit_ai_anthropic_key" \
            -H "anthropic-version: 2023-06-01" \
            -H "content-type: application/json" \
            --data-binary @-
    )
    or return $status
    printf '[trace] response: %s chars\n' (string length -- "$response") >&2

    if test -z "$response"
        echo "Empty response from Anthropic API (likely timed out or curl failed)." >&2
        return 1
    end

    printf '[trace] parsing response...\n' >&2
    # `string collect` keeps newlines in the response so our awk separator
    # works. Without it, fish would list-split the response on newlines and
    # subsequent `echo` calls would re-join with spaces, eating the `---`
    # line that separates title from body.
    set --local full_text (printf '%s' $response | jq -r '.content[0].text // empty' | string collect)
    or return $status

    if test -z "$full_text"
        echo "Failed to generate PR description. API response:" >&2
        echo $response | jq . >&2
        return 1
    end
    printf '[trace] full_text: %s chars\n' (string length -- "$full_text") >&2
    printf '[trace] full_text line count: %s\n' (count (string split \n -- "$full_text")) >&2

    # Split on `---` separator. Use printf to preserve newlines, then trim
    # whitespace and stray quotes from the title.
    set --local title (printf '%s' $full_text | awk 'NR==1' | string trim --chars=' "\'\\\'')
    set --local body (printf '%s' $full_text | awk '/^---$/{found=1; next} found' | string collect)

    if test -z "$title" -o -z "$body"
        echo "Failed to split title/body. Raw model output:" >&2
        echo $full_text >&2
        return 1
    end

    echo "Draft ready: $title" >&2

    # Push.
    printf '[trace] pushing branch...\n' >&2
    if not git push --set-upstream origin HEAD
        echo "Push failed; not opening PR." >&2
        return 1
    end
    printf '[trace] push succeeded\n' >&2

    # Open the PR with pre-filled title and body.
    echo "Opening PR..." >&2
    printf '%s' $body | gh pr create \
        --title $title \
        --body-file - \
        --assignee @me \
        --reviewer Create-Inc/eng \
        $argv
end
