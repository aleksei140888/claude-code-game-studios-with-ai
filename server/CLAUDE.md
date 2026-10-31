# World Server

Python + Agno + Postgres/pgvector. The deterministic simulation and the database
are the only source of truth about the world (ADR-001).

| Path | Owner agent | Rule |
|------|-------------|------|
| `server/sim/` | `world-simulation-engineer` | `.claude/rules/world-sim-code.md` |
| `server/ai/` | `llm-agent-architect` | `.claude/rules/llm-agent-code.md`, `prompt-injection.md` |
| `server/net/` | `network-programmer` | `.claude/rules/network-code.md` |

**Invariant:** LLM → intent (tool call) → validator (`server/sim`) → state change.
Code in `server/ai/` proposes; only `server/sim/` applies. LLM-client imports
outside `server/ai/` are flagged by `validate-commit.sh`.

Tests live in `tests/server/` (pytest), mirroring this tree.
