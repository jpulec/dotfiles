#!/usr/bin/env fish

if not command -q op
    echo "Missing required command: op"
    exit 1
end

if not command -q opencode
    echo "Missing required command: opencode"
    exit 1
end

if not set -q OP_ACCOUNT
    set -gx OP_ACCOUNT createxyz.1password.com
end

op whoami --account $OP_ACCOUNT >/dev/null 2>&1

set -l anthropic_ref "op://Employee/Anthropic API Key/credential"
set -l openai_ref "op://Employee/OpenAI API Key/credential"

set -l anthropic_key (op read --account $OP_ACCOUNT --no-newline "$anthropic_ref")
if test -z "$anthropic_key"
    echo "Failed to read Anthropic API key from $anthropic_ref"
    exit 1
end

set -l openai_key (op read --account $OP_ACCOUNT --no-newline "$openai_ref")
if test -z "$openai_key"
    echo "Failed to read OpenAI API key from $openai_ref"
    exit 1
end

set -lx ANTHROPIC_API_KEY $anthropic_key
set -lx OPENAI_API_KEY $openai_key
exec opencode serve --port 4096 --hostname 127.0.0.1
