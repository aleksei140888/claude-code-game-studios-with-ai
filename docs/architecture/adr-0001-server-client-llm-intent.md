# ADR-0001: Authoritative World Server, Godot Client, LLM via Intents

## Status

Proposed

## Date

2026-10-31

## Last Verified

2026-10-31

## Decision Makers

Aleksei K (owner); drafted with Claude Code for FOUN-1.

## Summary

A persistent online world with LLM-driven NPCs needs one source of truth that a
model cannot corrupt. A Python world server (Agno + Postgres/pgvector) runs a
deterministic simulation and owns all state; the Godot 4 client only renders and
sends intents; an LLM can only propose intents, which a rules validator accepts
or rejects.

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.7 (client only) |
| **Domain** | Core / Networking |
| **Layer** | Foundation |
| **Knowledge Risk** | MEDIUM — Godot 4.7 is past the LLM cutoff (`docs/engine-reference/godot/VERSION.md`); the server side is engine-independent |
| **References Consulted** | `docs/engine-reference/godot/VERSION.md` |
| **Post-Cutoff APIs Used** | None (this ADR fixes boundaries, not client APIs) |
| **Verification Required** | Commit hook blocks LLM clients outside `server/ai/`; injection tests in `tests/server/ai/` pass once the validator exists |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | LLM provider choice; client–server network protocol; NPC memory store schema |
| **Blocks** | Every server and client epic |
| **Ordering Note** | Provider and protocol are separate ADRs (out of FOUN-1 scope) |

## Context

### Problem Statement

The game is a persistent world in the spirit of *Играть чтобы жить*, without
full immersion: LLM NPCs with memory, an AI director, a simulated economy, clan
wars. LLMs are slow, costly, non-deterministic and persuadable by players. If a
model can write state directly, one clever player message can mint resources,
and no replay or test can reproduce what happened.

### Constraints

- Solo developer, prototype stage — the simplest architecture that holds.
- LLM latency (seconds) must never stall the world tick.
- LLM cost must be bounded per NPC and per player.

### Requirements

- One source of truth for world state, reproducible from inputs.
- Players cannot change state by talking to NPCs.
- Hundreds of NPCs alive without hundreds of concurrent LLM calls.

## Decision

1. **World server** — Python, Agno for agents, Postgres + pgvector for state and
   NPC memory. The deterministic simulation (`server/sim/`) and the database are
   the only source of truth.
2. **Client** — Godot 4 (GDScript), code in `client/`. Renders state, sends
   player intents. Never decides outcomes.
3. **Invariant** — **LLM → intent (tool call) → rules validator → state change.**
   No other path writes state.
4. **NPC tiers** — key NPCs think with an LLM; crowd NPCs run utility AI / GOAP and
   wake the LLM only on direct player contact.
5. **NPC memory** — episodes → summaries → reflections, with forgetting.
6. **AI director** — reads world signals and proposes conflicts as intents,
   through the same validator, so emergence does not flatten into grey mush.

### Architecture Diagram

```text
 Godot client ──player intent──▶ ┌──────────── world server ─────────────┐
      ▲                          │ server/net ──▶ server/sim/validator   │
      │ state snapshots          │                  │ accept / reject    │
      └──────────────────────────│                  ▼                    │
                                 │           deterministic tick ──▶ Postgres
                                 │                  ▲                    │
                                 │ server/ai (LLM NPCs, director)        │
                                 │   reads state + memory (pgvector)     │
                                 │   proposes intents ──────┘            │
                                 └───────────────────────────────────────┘
```

### Key Interfaces

- `server.sim.validator.validate(state, intent) -> Result(accepted, reason)` —
  pure: does not mutate `state`. An unknown intent type is rejected.
- Intents are typed tool calls with bounded arguments; the schema list is shared
  by `server/ai` (as LLM tools) and `server/sim` (as validator rules).

### Implementation Guidelines

- Code in `server/ai/` must never write state; it submits intents.
- Code in `server/sim/` must never call an LLM and must be deterministic.
- LLM-client imports must appear only under `server/ai/` (enforced by
  `validate-commit.sh`).
- Every LLM call must have a token limit, a timeout and a deterministic fallback.
- Every intent tool that moves resources must have a prompt-injection test.
- AI decisions record their budget and fallback using
  `.claude/docs/templates/architecture-decision-record-ai.md`.

## Alternatives Considered

### Alternative 1: Godot-authoritative (server logic in Godot)
- **Pros**: one language, one runtime.
- **Cons**: LLM tooling, pgvector and Agno are Python-native; headless Godot as an
  MMO backend is uncommon and harder to test.

### Alternative 2: LLM writes state through function calls directly
- **Pros**: less code; fewer moving parts.
- **Cons**: any successful prompt injection becomes a state change; non-reproducible
  world; no single place to enforce rules. Rejected — this is the risk the ADR exists for.

## Consequences

### Positive
- Prompt injection can change dialogue, not the world.
- The tick is replayable and testable without a model.
- LLM cost is bounded by tiering and per-call budgets.

### Negative
- Two languages (Python, GDScript) and a network boundary from day one.
- Every new NPC ability needs both a tool schema and a validator rule.

### Neutral
- LLM provider and network protocol remain open (separate ADRs).

## Risks

- **Validator gaps** — a rule missing from the validator is a hole. Mitigation:
  unknown intents are rejected; injection tests per tool.
- **Cost overrun** — mitigated by NPC tiers and per-NPC call caps.

## GDD Requirements Addressed

None yet — no GDD exists. NPC agents are specified with
`.claude/docs/templates/npc-agent.md`.

## Performance Implications

LLM calls run outside the tick, asynchronously; the tick never waits on them.

## Migration Plan

None — greenfield.

## Validation Criteria

- `bash studio-tests/hooks/validate-commit-llm.sh` passes.
- `pytest tests/server` passes once `server/sim/validator.py` exists.

## Related

- Jira FOUN-1
- `.claude/rules/llm-agent-code.md`, `world-sim-code.md`, `prompt-injection.md`
- Agents: `llm-agent-architect`, `world-simulation-engineer`, `narrative-director-ai`
