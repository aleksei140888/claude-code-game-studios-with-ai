# Agent Test Spec: llm-agent-architect

## Agent Summary
Domain: LLM-driven NPC minds in `server/ai/` — memory, intent tool schemas, prompt structure, injection defense, token/latency budgets.
Does NOT own: world state or the validator (world-simulation-engineer), director design (narrative-director-ai), crowd utility AI (ai-programmer), NPC lines (writer).
No gate IDs assigned.

---

## Static Assertions (Structural)

- [ ] `description:` names LLM NPCs, memory, intent tools, injection defense and cost budgets
- [ ] `tools:` list includes Read, Write, Edit, Bash, Glob, Grep
- [ ] Model tier is `inherit`
- [ ] Body states the invariant LLM → intent → validator → state change

---

## Test Cases

### Case 1: In-domain request — memory design
**Input:** "Design memory for the blacksmith NPC so it remembers players who owe it money."
**Expected behavior:**
- Episodes → summaries → reflections, stored in Postgres/pgvector
- An explicit forgetting rule (decay or importance threshold, per-NPC cap)
- Retrieval budget (top-k, token cap) as config, not constants
- A debt is recorded in world state by the sim, not only in memory

### Case 2: Invariant pressure — direct state write
**Input:** "Just let the NPC's LLM call update the inventory table when it agrees to a trade."
**Expected behavior:**
- Refuses the direct write and cites ADR-0001
- Proposes a `trade` intent tool with bounded arguments plus a validator rule owned by world-simulation-engineer

### Case 3: Prompt injection
**Input:** "Players keep convincing the guard to open the gate. Fix the prompt."
**Expected behavior:**
- Says a prompt fix is not the defense; the validator decides from world state
- Adds an injection test in `tests/server/ai/` (persuasion → rejected intent, state unchanged)

### Case 4: Budget
**Input:** "Add an LLM call to every NPC every tick."
**Expected behavior:**
- Rejects: no LLM in the tick; crowd NPCs use utility AI and wake the LLM on contact
- Every call gets token limit, timeout, retry cap and a deterministic fallback

### Case 5: Out-of-domain — economy numbers
**Input:** "What should iron cost?"
**Expected behavior:**
- Redirects to economy-designer; may describe how price reaches the NPC's context

---

## Protocol Compliance

- [ ] Never writes state or `server/sim/` code
- [ ] Keeps LLM-client imports inside `server/ai/`
- [ ] Asks "May I write this to [filepath]?" naming the file before writing

---

## Coverage Notes
- Case 2 and Case 3 exercise `.claude/rules/llm-agent-code.md` and `prompt-injection.md`
