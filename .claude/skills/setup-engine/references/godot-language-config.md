# Godot Language Configuration — setup-engine reference

Lookup tables for `/setup-engine`, split out of the skill body. Godot with
GDScript is the only supported configuration, so each subsection has a single
GDScript variant.

Referenced from Sections 4, 5 and 5.5 of `/setup-engine` by the names A1, A2
and A3.

**In this file:**

- A1. CLAUDE.md Technology Stack Templates
- A2. Naming Conventions
- A3. Engine Specialists Routing

---

### A1. CLAUDE.md Technology Stack Templates

**GDScript:**
```markdown
- **Engine**: Godot [version]
- **Language**: GDScript
- **Build System**: SCons (engine), Godot Export Templates
- **Asset Pipeline**: Godot Import System + custom resource pipeline
```

> **Guardrail**: When using this GDScript template, write the Language field as exactly "`GDScript`" — no additions. Do NOT append "C++ via GDExtension" or any other language.

---

### A2. Naming Conventions

**GDScript:**
- Classes: PascalCase (e.g., `PlayerController`)
- Variables/functions: snake_case (e.g., `move_speed`)
- Signals: snake_case past tense (e.g., `health_changed`)
- Files: snake_case matching class (e.g., `player_controller.gd`)
- Scenes: snake_case matching the file (e.g., `player_controller.tscn`)
- Constants: UPPER_SNAKE_CASE (e.g., `MAX_HEALTH`)

> **This list and the `naming` enum table in Section 5.5.1 of the skill must
> agree, value for value.** They are written into two different files —
> `technical-preferences.md` from here, `project.yaml` from there — and Section
> 5.5.3 compares them and **stops the skill** on any mismatch.

---

### A3. Engine Specialists Routing

**GDScript:**
```markdown
## Engine Specialists
- **Primary**: godot-specialist
- **Language/Code Specialist**: godot-gdscript-specialist (all .gd files)
- **Shader Specialist**: godot-specialist (.gdshader files, VisualShader resources — primary covers shaders)
- **UI Specialist**: godot-specialist (no dedicated UI specialist — primary covers all UI)
- **Additional Specialists**: none
- **Routing Notes**: Invoke primary for architecture decisions, ADR validation, and cross-cutting code review. Invoke GDScript specialist for code quality, signal architecture, static typing enforcement, and GDScript idioms. Invoke primary for material design and shader code.

### File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| Game code (.gd files) | godot-gdscript-specialist |
| Shader / material files (.gdshader, VisualShader) | godot-specialist |
| UI / screen files (Control nodes, CanvasLayer) | godot-specialist |
| Scene / prefab / level files (.tscn, .tres) | godot-specialist |
| General architecture review | godot-specialist |
```
