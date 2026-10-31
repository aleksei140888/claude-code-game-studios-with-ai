---
paths:
  - "server/sim/**"
---

# World Simulation Code Rules

- The tick is DETERMINISTIC: same state + same inputs + same seed → same result.
  No wall-clock reads (pass tick time in), no unseeded random, no iteration over
  unordered collections (sort first), no floating-point accumulation across
  ticks where integers will do.
- NO LLM calls in the tick or the validator — no LLM-client imports in this
  tree at all. LLM work runs outside the tick and arrives as intents.
- Server-authoritative: clients and NPCs submit intents; only the validator
  turns an intent into a state change. An unknown intent type is rejected.
- Every rejection is logged with the intent, the actor and the reason.
- A game rule that matters lives in the validator, never only in a prompt.
- A tick commits atomically to Postgres; a crash mid-tick loses at most that tick.
- Balance values (prices, rates, caps) come from data files, not literals.
- Every validator rule has a unit test with an accept case and a reject case.
