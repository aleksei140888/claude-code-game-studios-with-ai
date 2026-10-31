# /setup-engine — Section 2: Guided Mode

> Part of `/setup-engine`. `SKILL.md` names when to read this file; the settings it
> resolved and the rules under its later headings still apply here.

## 2. Guided Mode (No Arguments)

**In this file:**

- Check for existing game concept
- If the user wants to pick without a concept, ask in this order
- Produce a recommendation

If no engine is specified, run an interactive engine selection process:

### Check for existing game concept
Read the design artifact for the resolved tier (see **Tier awareness** above), by
section: find the headings you need with the Grep tool (pattern `^#`, content
mode) and Read those ranges with offset and limit:
- **`standard` / `full`**: read `design/gdd/game-concept.md` if it exists —
  extract genre, scope, platform targets, art style, team size, and the engine
  preference `/brainstorm` recorded (an engine the user named, or "undecided":
  `/brainstorm` never recommends one, so the recommendation is made here).
- **`minimal`**: read `design/game-brief.md` if it exists — extract genre,
  scope, platform, and art direction from its fields. Its absence is **expected**
  at `minimal` (the brief is authored *after* engine setup in the minimal path), so
  do not treat a missing brief as a gap — proceed straight to guided selection.
- If no concept **or** brief exists, inform the user:
  > "No game concept found. Consider running `/brainstorm` first to discover what
  > you want to build — it records your engine preference if you have one. Or
  > tell me about your game and I can help you pick."

  (At `minimal` this is optional, not a prerequisite — you can pick an engine now
  and write the brief next.)

### If the user wants to pick without a concept, ask in this order:

This studio supports **one engine: Godot 4, with GDScript**. Unity and Unreal
are not offered, and there is no engine-selection matrix. Guided mode confirms
Godot and surfaces any fit concerns for the concept.

**Question 1 — Confirm the engine** (ask this first, always, via `AskUserQuestion`):
- Prompt: "This studio is set up for Godot 4 with GDScript. Continue with Godot?"
- Options: `Godot 4 (Recommended)` / `I have a concern — let me explain`
- If they pick Godot → proceed to Section 3.
- If they raise a concern → answer it against the tradeoffs below, then ask again.

**Questions 2-4 — Fit check** (only to flag risks, never to switch engines):

**Question 2 — Target platform** (via `AskUserQuestion`):
- Prompt: "What platforms are you targeting for this game?"
- Options: `PC (Steam / Epic)` / `Mobile (iOS / Android)` / `Console` / `Web / Browser` / `Multiple platforms`
- Platform notes for the recommendation:
  - Mobile → Godot is viable for simple mobile; flag performance budgets early
  - Console → Godot console support requires third-party publishers or significant extra work
  - Web → Godot exports cleanly to web
  - PC only → no platform concern

1. **What kind of game?** (2D, 3D, or both?)
2. **Primary input method?** (keyboard/mouse, gamepad, touch, or mixed?)
3. **Team size and experience?** (solo beginner, solo experienced, small team?)

### Produce a recommendation

Present Godot with the honest tradeoffs below as they apply to the user's
concept. Name concrete risks; do not offer another engine.

**Godot 4 honest tradeoffs:**
- Genuine strengths: 2D (best in class), stylized/indie 3D, rapid iteration, free forever (MIT), open source, gentlest learning curve, best for solo devs who want full control
- Real limitations: 3D ecosystem is thinner than larger commercial engines (fewer tutorials, assets, community answers for 3D-specific problems); large open-world 3D is very hard and largely untested in Godot; console export requires third-party publishers or significant extra work; smaller professional job market
- Licensing reality: Truly free with no revenue thresholds ever. MIT license means you own everything.
- Best fit: 2D games of any scope; stylized/atmospheric 3D; contained 3D worlds (not open-world); first game projects where learning curve matters; projects where budget is a hard constraint at any scale

**Recommendation format:**
1. Show a short table of the user's specific factors and how Godot handles each
2. Name the concept-specific risks and how to mitigate them in Godot
3. Use `AskUserQuestion` to confirm: "Ready to continue with Godot 4?"
   - Options: `Continue with Godot (Recommended)` / `Explore a concern further`

**If the user picks "Explore a concern further":**
Use `AskUserQuestion` with concept-specific deep-dive topics generated from the user's actual concept — do not use generic options. For example:
- Godot's specific limitations for this concept (e.g., "How far can Godot 3D actually go for [genre]?")
- Any concept-specific technical concern (e.g., open-world streaming, multiplayer netcode)

The user can select multiple topics. Answer each selected topic in depth before returning to the confirmation question.

---
