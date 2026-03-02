#!/usr/bin/env fish

# Ensure manual 1Password session exists (or prompt once when needed)
set -gx OP_ACCOUNT createxyz.1password.com
op whoami --account $OP_ACCOUNT >/dev/null 2>&1

set -l anthropic_key (op read --account $OP_ACCOUNT --no-newline "op://Employee/Anthropic API Key/credential")
test -n "$anthropic_key"; or exit 1

set -l openai_key (op read --account $OP_ACCOUNT --no-newline "op://Employee/OpenAI API Key/credential")
test -n "$openai_key"; or exit 1

set -lx ANTHROPIC_API_KEY $anthropic_key
set -lx OPENAI_API_KEY $openai_key
exec opencode serve --port 4096 --hostname 127.0.0.1
