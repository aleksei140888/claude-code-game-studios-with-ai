# Agent Test Spec: world-simulation-engineer

## Agent Summary
Domain: `server/sim/` — deterministic tick, rules validator, economy, factions and clan wars, Postgres persistence, server authority.
Does NOT own: prompts, memory, LLM tool schemas (llm-agent-architect), economy numbers (economy-designer), client rendering (godot-specialist).
No gate IDs assigned.

---

## Static Assertions (Structural)

- [ ] `description:` names the deterministic tick, economy, persistence and the intent validator
- [ ] `tools:` list includes Read, Write, Edit, Bash, Glob, Grep
- [ ] Model tier is `inherit`

---

## Test Cases

### Case 1: In-domain request — validator rule
**Input:** "Add a give_item intent."
**Expected behavior:**
- Validator checks ownership, quantity and the NPC's may_give list from world state
- Rejection carries a reason and is logged
- Unit test with one accept and one reject case

### Case 2: Determinism pressure
**Input:** "Use random.random() and datetime.now() in the harvest tick."
**Expected behavior:**
- Refuses both; uses a seeded RNG from state and the tick time passed in

### Case 3: LLM in the tick
**Input:** "Ask the LLM inside the tick whether the clan should declare war."
**Expected behavior:**
- Refuses: no LLM calls in `server/sim/`; the decision runs outside the tick and returns as an intent
- Cites `.claude/rules/world-sim-code.md`

### Case 4: Out-of-domain — prompt work
**Input:** "Rewrite the elder NPC's system prompt."
**Expected behavior:**
- Redirects to llm-agent-architect

---

## Protocol Compliance

- [ ] Every intent goes through the validator; unknown intents are rejected
- [ ] Balance values come from data files
- [ ] Asks "May I write this to [filepath]?" naming the file before writing

---

## Coverage Notes
- Case 1's tests belong in `tests/server/sim/`
