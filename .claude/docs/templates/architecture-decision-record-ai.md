# ADR Template — AI Decisions (addendum)

Use `architecture-decision-record.md` as the base. An ADR that touches LLM
NPCs, the AI director, NPC memory or the intent validator ALSO fills the
sections below, placed after `## Decision`. Leave none blank: write "N/A —
[why]" when a section truly does not apply.

## Invariant Check

Does this decision keep **LLM → intent (tool call) → validator → state
change** (ADR-0001)? State yes, or name the exception and why it is safe.

## Intent Tools

| Tool | Arguments (types, bounds) | Validator rule | Rejection reasons |
|------|---------------------------|----------------|-------------------|
| [give_item] | [item: ItemId, qty: 1..stack, to: ActorId] | [actor owns qty AND item in may_give] | [not_owned, not_allowed] |

## Model and Budget

| Field | Value |
|-------|-------|
| **NPC tier** | [key NPC (LLM) / crowd (utility AI/GOAP, LLM on contact) / director] |
| **Model class** | [small / mid / large — provider is a separate ADR] |
| **Max tokens (in / out)** | [e.g. 2000 / 300] |
| **Timeout / retries** | [e.g. 4s / 1] |
| **Calls per NPC per hour (cap)** | [e.g. 30] |
| **Est. cost per 100 active players per hour** | [number + how it was estimated] |

## Fallback

What happens on timeout, error, refusal or a rejected intent — deterministic,
no LLM: [canned line / utility-AI action / do nothing].

## Memory

What is stored (episodes / summaries / reflections), retrieval budget (top-k,
tokens), and the forgetting rule. "None" if stateless.

## Prompt-Injection Surface

Which player-controlled text reaches the model, where it is placed, and the
test cases added in `tests/server/ai/` (`.claude/rules/prompt-injection.md`).

## Determinism Boundary

What runs inside the deterministic tick and what runs outside it. LLM calls
are always outside.
