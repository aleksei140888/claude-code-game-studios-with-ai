#!/usr/bin/env bash
# Self-check for validate-commit.sh's LLM-boundary block (ADR-001).
# Usage: bash studio-tests/hooks/validate-commit-llm.sh   (from the repo root)
set -u
SRC="$(cd "$(dirname "$0")/../.." && pwd)"
R="$(mktemp -d)"; trap 'rm -rf "$R"' EXIT
cd "$R" && git init -q && cp -R "$SRC/.claude" "$SRC/project.yaml" . && mkdir -p server/ai server/sim client
git add -A && git -c user.email=t@t -c user.name=t commit -qm base
J='{"tool_name":"Bash","tool_input":{"command":"git commit -m test"}}'
fail=0
expect() { # <exit> <path> <content> <label>
  mkdir -p "$(dirname "$2")"; printf '%s\n' "$3" > "$2"; git add "$2"
  echo "$J" | bash .claude/hooks/validate-commit.sh >/dev/null 2>&1; got=$?
  git reset -q; rm -f "$2"
  if [ "$got" = "$1" ]; then echo "ok   $4"; else echo "FAIL $4 (exit $got, want $1)"; fail=1; fi
}
expect 2 server/sim/x.py 'from openai import OpenAI' 'sim importing openai is blocked'
expect 2 client/x.gd 'var u = "https://api.anthropic.com/v1/messages"' 'client calling an LLM API is blocked'
expect 0 server/ai/x.py 'from agno.agent import Agent' 'server/ai may import agno'
expect 0 tests/server/ai/x.py 'import anthropic' 'tests/server/ai may import a client'
expect 0 server/sim/x.py 'import os' 'clean sim file passes'
exit $fail
