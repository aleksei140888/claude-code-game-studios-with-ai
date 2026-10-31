# Directory Structure

```text
/
├── CLAUDE.md                    # Master configuration
├── project.yaml                 # Machine-readable project config — engine, modes, stage (source of truth)
├── .claude/                     # Agent definitions, skills, hooks, rules, docs
├── client/                      # Godot client code — the code root (Godot project root is /)
├── server/                      # Python world server — sim/, ai/, net/ (see server/CLAUDE.md)
├── assets/                      # Game assets (art, audio, vfx, shaders, data)
├── design/                      # Game design documents (gdd, narrative, levels, balance)
├── docs/                        # Technical documentation (architecture, api, postmortems)
│   └── engine-reference/        # Curated engine API snapshots (version-pinned)
├── tests/                       # Godot test suites (unit, integration, performance, playtest)
│   └── server/                  # Python server tests (pytest)
├── tools/                       # Build and pipeline tools (ci, build, asset-pipeline)
├── prototypes/                  # Throwaway prototypes (outside the code root)
├── production/                  # Production management (sprints, milestones, releases)
│   ├── session-state/           # Ephemeral session state (active.md — gitignored)
│   └── session-logs/            # Session audit trail (gitignored)
└── studio-tests/                # QA for the skills/agents themselves — /skill-test, /skill-improve
```

## The code root

This fork is Godot-only. The Godot project root is the repo root; game code lives
in `client/` (`resolve_code_root` returns `client` for `engine.name: Godot`).
A path written as `src/…` in older docs means `client/…`.

`server/` is the Python world server and is not engine code: Godot skips it
(`server/.gdignore`). Its tests live in `tests/server/`, also skipped by Godot.

| Code | Root | Tests |
|---|---|---|
| Godot client | `client/` | `tests/unit/`, `tests/integration/` (gdUnit4) |
| World server | `server/` | `tests/server/` (pytest) |
