---
paths:
  - "server/ai/**"
---

# LLM Agent Code Rules

ADR-001's invariant: **LLM → intent (tool call) → rules validator → state change.**

- NEVER mutate world state from this code — no DB writes, no imports of
  `server/sim` internals beyond the intent-submission API. An LLM's output is a
  proposal; only the validator in `server/sim` applies it.
- Every NPC action is a typed intent tool with bounded arguments. A tool
  without a matching validator rule does not ship.
- Parse LLM output strictly: unknown tool, bad arguments or free text where a
  tool call was expected → reject and use the fallback. Never "repair" it into a
  different action.
- Every LLM call sets a max-token limit, a timeout and a retry cap. Values come
  from config, not literals in code.
- Every call has a deterministic fallback (canned line or utility-AI action) for
  timeout, error, refusal or rejected intent. The world never waits on an LLM.
- Log tokens, latency and cost per call, tagged with the NPC id.
- LLM-client imports (`agno`, `openai`, `anthropic`, …) are allowed only here;
  `validate-commit.sh` flags them anywhere else.
- Player text is untrusted input — see `.claude/rules/prompt-injection.md`.
