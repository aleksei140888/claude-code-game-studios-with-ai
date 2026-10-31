# /setup-engine — Section 4: Update CLAUDE.md Technology Stack

> Part of `/setup-engine`. `SKILL.md` names when to read this file; the settings it
> resolved and the rules under its later headings still apply here.

## 4. Update CLAUDE.md Technology Stack

### Language Selection (Godot only)

Godot is the only supported engine and **GDScript** is the project language.
Do not offer C# or a mixed setup. Record `GDScript` — it determines the
CLAUDE.md template, naming conventions, specialist routing, and which agent is
spawned for code files throughout the project (`godot-gdscript-specialist`).

---

Read `CLAUDE.md` and show the user the proposed Technology Stack changes.
Ask: "May I write these engine settings to `CLAUDE.md`?"

Wait for confirmation before making any edits.

Update the Technology Stack section, replacing the `[CHOOSE]` placeholders with the actual values:

**For Godot** — use the GDScript template. See `references/godot-language-config.md` (**A1**).

### Engine reference import

In the same CLAUDE.md write, set the **Engine Version Reference** import to the
chosen engine. Find the line marked `ENGINE-REFERENCE-IMPORT` (an
`@docs/engine-reference/<engine>/VERSION.md` line under its comment) and Edit it
to point at the configured engine:
- Godot → `@docs/engine-reference/godot/VERSION.md`

It is idempotent — re-running `/setup-engine` rewrites the same line. (The target `docs/engine-reference/<engine>/`
directory is created in Section 7, Populate Engine Reference Docs, if it does not yet exist.)

---
