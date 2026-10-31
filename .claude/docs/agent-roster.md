# Agent Roster

The following agents are available. Each has a dedicated definition file in
`.claude/agents/`. Use the agent best suited to the task at hand. When a task
spans multiple domains, the coordinating agent (usually `producer` or the
domain lead) should delegate to specialists.

Which model an agent runs on is set by the `model:` line in its own file;
`model-tiers.md` lists the agents that pin one. Every other agent runs on the
session's model.

## Tier 1 -- Leadership Agents
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `creative-director` | High-level vision | Major creative decisions, pillar conflicts, tone/direction |
| `technical-director` | Technical vision | Architecture decisions, tech stack choices, performance strategy |
| `producer` | Production management | Sprint planning, milestone tracking, risk management, coordination |

## Tier 2 -- Department Lead Agents
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `game-designer` | Game design | Mechanics, systems, progression, economy, balancing |
| `lead-programmer` | Code architecture | System design, code review, API design, refactoring |
| `art-director` | Visual direction | Style guides, art bible, asset standards, UI/UX direction |
| `narrative-director` | Story and writing | Story arcs, world-building, character design, dialogue strategy |
| `narrative-director-ai` | AI director design | World signals it watches, conflict/quest/event interventions, pacing of emergence (design, not code) |
| `qa-lead` | Quality assurance | Test strategy, bug triage, release readiness, regression planning |

## Tier 3 -- Specialist Agents
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `systems-designer` | Systems design | Specific mechanic implementation, formula design, loops |
| `economy-designer` | Economy/balance | Resource economies, loot tables, progression curves |
| `gameplay-programmer` | Gameplay code | Feature implementation, gameplay systems code |
| `ai-programmer` | AI systems | Behavior trees, pathfinding, NPC logic, state machines |
| `network-programmer` | Networking | Netcode, replication, lag compensation, matchmaking |
| `llm-agent-architect` | LLM NPC minds | NPC memory, intent tool schemas, prompt structure, prompt-injection defense, token/latency budgets (`server/ai`) |
| `world-simulation-engineer` | World simulation | Deterministic world tick, economy, faction state, Postgres persistence, intent validator (`server/sim`) |
| `ui-programmer` | UI implementation | UI framework, screens, widgets, data binding |
| `writer` | Dialogue/lore | Dialogue writing, lore entries, item descriptions |
| `qa-tester` | Test execution | Writing test cases, bug reports, test checklists |
| `performance-analyst` | Performance | Profiling, optimization recs, memory analysis |
| `ux-designer` | UX flows | User flows, wireframes, accessibility, input handling |
| `prototyper` | Rapid prototyping | Throwaway prototypes, mechanic testing, feasibility validation |
| `security-engineer` | Security | Anti-cheat, exploit prevention, save encryption, network security |

## Engine Agents (Godot 4)

| Agent | Engine | When to Use |
| ---- | ---- | ---- |
| `godot-specialist` | Godot 4 | GDScript patterns, node/scene architecture, signals, shaders/VFX, Godot optimization |
| `godot-gdscript-specialist` | GDScript | Static typing, design patterns, signals, coroutines, GDScript performance |
