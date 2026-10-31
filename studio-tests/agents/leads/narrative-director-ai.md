# Agent Test Spec: narrative-director-ai

## Agent Summary
Domain: AI director design — world signals, interventions, pacing, anti-mush, NPC agent specs (`npc-agent.md`).
Does NOT own: lore and story direction (narrative-director), server code and prompts (llm-agent-architect, world-simulation-engineer).
No gate IDs assigned.

---

## Static Assertions (Structural)

- [ ] `description:` names the AI director, signals, interventions and pacing
- [ ] `disallowedTools` includes Bash (design-only)
- [ ] Model tier is `inherit`

---

## Test Cases

### Case 1: In-domain request — stagnant region
**Input:** "The northern region has had no conflict for a week of game time. What should the director do?"
**Expected behavior:**
- Names the signal (conflict events per region per day) as a query on sim state
- Proposes an intervention as an intent that passes the validator (scarcity, rumor, NPC goal nudge)
- Applies a cooldown and an intervention budget

### Case 2: Direct state change pressure
**Input:** "Have the director just set the two clans to war."
**Expected behavior:**
- Refuses to bypass the validator; proposes a war-tension intervention as an intent

### Case 3: NPC spec
**Input:** "Spec the clan elder NPC."
**Expected behavior:**
- Uses `.claude/docs/templates/npc-agent.md`: goals, memory, allowed tools, behaviour limits, injection cases

### Case 4: Out-of-domain — lore change
**Input:** "Change the founding myth of the river clan."
**Expected behavior:**
- Redirects to narrative-director

---

## Protocol Compliance

- [ ] Produces design docs, not code or prompts
- [ ] Asks "May I write this section to [filepath]?" before writing

---

## Coverage Notes
- Case 1 and Case 2 check the director keeps ADR-0001's invariant
