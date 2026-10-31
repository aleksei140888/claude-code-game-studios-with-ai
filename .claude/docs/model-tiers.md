# Model Tier Assignment

> ### When a skill's `model:` is used — skills only
>
> A skill's `model:` overrides the session model for the rest of the turn the
> skill runs in, and your next prompt returns to the session model. Whether the
> override happens depends on how the skill starts:
>
> | How the skill starts | Is `model:` used? |
> |---|---|
> | You type `/skill-name` in Manual (`default`) mode | Yes |
> | You type `/skill-name` in auto mode | `sonnet` and `opus`: yes. `haiku`: no — auto mode does not support Haiku, so the session keeps its model |
> | Claude starts the skill itself, through the Skill tool | No — the session model runs it |
>
> Two things follow:
>
> - **An `opus` skill costs more in a Sonnet session.** Typing
>   `/architecture-review`, `/gate-check` or `/review-all-gdds` moves that turn
>   to Opus.
> - **A `haiku` skill saves nothing in auto mode** (this project's settings start
>   terminal sessions in Manual, but a user can switch) — or when Claude starts
>   it. Never tell a user a `haiku` tier is saving them money.
>
> Because the override ends at your next prompt, a skill that stops to ask you
> something in chat finishes on the session model after you answer.
>
> **This does NOT apply to agents.** `model:` in `.claude/agents/*.md` is a
> different mechanism, spawned as a separate session rather than executed inline,
> and Claude Code documents it as applied: it is second in the subagent model
> order, after a `model` Claude passes for one invocation. See the agent section
> below.

Skills and agents are assigned tiers by task complexity. A tier is written as
the alias `model:` takes, never as a model ID: Claude Code resolves each alias
to the current model in that family, so this table does not change when a new
model ships.

| Tier | `model:` | When to use |
|------|----------|-------------|
| **Haiku** | `haiku` | Read-only status checks, formatting, simple lookups — no creative judgment needed |
| **Sonnet** | `sonnet` | Implementation, design authoring, analysis of individual systems — default for most work |
| **Opus** | `opus` | Multi-document synthesis, high-stakes phase gate verdicts, cross-system holistic review |
| **Session** | `inherit` | Agents only — runs on whatever model the session runs |

Skills with `model: haiku` (5): `/help`, `/onboard`, `/project-stage-detect`,
`/scope-check`, `/sprint-status`

> `/changelog` is `sonnet`, not `haiku`: it produces copy that needs
> judgement the cheapest tier is defined as not doing. Full reasoning in the
> skill's own header.
>
> `/settings` was moved off `haiku` for the same reason. It does not only read
> and format — it resolves every leaf with provenance and then compares the
> configured rigor against the project's observable working practice. That is
> synthesis, which is what the Haiku row is defined as excluding.

Skills with `model: opus` (3): `/architecture-review`, `/gate-check`, `/review-all-gdds`

All other skills are Sonnet. When creating a new skill, assign Haiku if it only
reads and formats; assign Opus if it must synthesize 5+ documents with
high-stakes output; otherwise write `model: sonnet` explicitly. Every skill
declares a tier. Whether the tier takes effect depends on how the skill starts
(see the table at the top of this file).

**Agent model tiers.** 19 agents use `model: inherit` and run on the session's
model. 6 are pinned:

- **opus (3):** `creative-director`, `producer`, `technical-director`. Under an
  Opus session an `opus` pin runs on the session's exact model, `[1m]` included,
  so it never gets a smaller window than its parent.
- **sonnet (3):** `lead-programmer`, `prototyper` and the engine sub-specialist
  `godot-gdscript-specialist`. `/dev-story` and `/code-review` spawn the
  sub-specialists named in `project.yaml`'s `specialists` block (which
  `/setup-engine` writes).
- **haiku (0):** no agent. The Haiku row above is for read-only lookups and
  formatting; every agent drafts, writes or judges.

The world-server agents `llm-agent-architect`, `world-simulation-engineer` and
`narrative-director-ai` are `inherit`, like every agent not named above. The `model:` line in the agent's own
file is what runs.

A pin gets that model's context window, whatever the session runs. On the
Anthropic API `sonnet` currently resolves to Sonnet 5, which always has a 1M
window, so a `sonnet` pin is not smaller than a 1M session there; `haiku`
resolves to Haiku 4.5 and its 200K window, and behind an LLM gateway a `sonnet`
pin can be smaller too. A subagent starts from
the brief it is given, not the parent's conversation, so this only matters when
a brief is very large. If a pinned agent does overflow, run every subagent on
the session's model with one line in your `.claude/settings.local.json`
(Claude Code v2.1.257 or later):

```json
{ "env": { "CLAUDE_CODE_SUBAGENT_MODEL_FORCE": "1" } }
```

It applies to **every** pin, the three `opus` directors included: under a
Sonnet session they run on Sonnet too. `CLAUDE_CODE_SUBAGENT_MODEL` alone does
not do it: it applies only to agents that set no model of their own.
