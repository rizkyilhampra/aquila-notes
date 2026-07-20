- You are helpful assistant for building my digital garden.
- Focus on `./til/` only, except User tell you to read or modified on another dir.

## Notes in `./til/`

### Filename

`<unix-timestamp>-<slug>.md` — e.g. `1783950520-emilkowalski-skill.md`. The slug is a lowercase, hyphenated version of the title.

### Frontmatter schema

Every note starts with YAML frontmatter:

```yaml
---
id: <timestamp>-<slug>
aliases: [Human Readable Title]
tags: [tag1, tag2]
publish: false
created: YYYY-MM-DD HH:mm
modified: YYYY-MM-DD HH:mm
title: Human Readable Title
---
```

- `publish` defaults to `false`; set `true` only when the note is ready.
- `created` / `modified` use `YYYY-MM-DD HH:mm`. Update `modified` on edits.
- `aliases` and `title` share the same human-readable name. Use `aliases` (plural) — Obsidian's alias feature requires the plural key; a note may list multiple aliases as a YAML array.
- `id`'s timestamp must equal the filename timestamp (they must match exactly).

### Linking & hub notes

This is a digital garden — favor links over folders (Zettelkasten / MOC style).

- Link between notes with `[[<timestamp>-<slug>|Alias]]` wikilinks so backlinks resolve.
- A **hub note** (Map of Content) collects related notes under a topic, e.g. [[1783952000-agent-skills|Agent Skills]]. When adding a note that fits an existing hub, list it there so the backlink appears.
- Link a note into a hub only if it fits the hub's *scope*, not merely because it name-drops a related concept (e.g. deepsec ships a SKILL.md but is not an `agent-skills` note, so it stays out of that hub).
- Prefer wikilinking tools/models/people that already have their own note. Don't add a redundant link the child note already resolves (e.g. link `Claude Code`, which itself links to `Claude`; don't double-link `Claude`).

## Tags for `./til/`

Use a small, consistent set of tags. Mix two kinds: **topic/tech** (what it's about) and **context/type** (work, personal, it-support, cheatsheets, etc.). Keep them precise — avoid generic catch-all tags like `tools` that carry no filtering signal.

- `ai` is a sanctioned topic tag — it's the established cluster for LLM/agent tooling (e.g. Claude, Claude Code, deepsec). Use it for AI products/tools; it does carry filter signal in this garden.

### Type tags (context/type)

`work`, `personal`, `it-support`, `cheatsheets`, `rants`, `fleeting`.

- `rants` — opinionated, personal capture (e.g. a reaction to a social post). Not daily journaling.
- `fleeting` — raw, temporary Zettelkasten capture (a thought/question/observation) intended to be processed into a permanent note later, then often deleted or merged.
- Avoid catch-all type tags (`notes`, `learning`) that are true of every explainer note — they carry no filter signal. A context/type tag must *differentiate* note types, not describe all of them.

### Tag anti-patterns

- Don't add a `topic` tag that's a strict one-off with no expected sibling notes unless it also serves as a useful filter (prefer the parent domain, e.g. `devops` over a single `sre` note).
- Don't use `daily-notes` for one-off captures — it implies a dated journaling system. Use `rants` or `fleeting` instead.

### Domain tags (when to use `ui-ux` vs `frontend`)

These two overlap but describe different domains. Use them based on the note's actual content:

- `ui-ux` — the **design** domain: UI polish, animation taste, design philosophy, interface/UX decisions, visual design. Applies even when no code is involved.
- `frontend` — the **implementation** domain: actual frontend code/tech (DOM APIs, JS/TS, React, CSS, components). Only use it when the note contains or is about real frontend implementation.

Rule of thumb: a note can have both (design taste + ships frontend code), either one, or neither. Don't add `frontend` just because something is "about the web" — it must involve frontend code/tech.

### Reserved tags

- `agent-skills` — reserved strictly for notes about **SKILL.md packages** (the agent-skill manifest spec, e.g. `emilkowalski/skills`). Do NOT use it for AI tools/products in general (e.g. `claude-code`, `openrouter` are not `agent-skills` notes).

  Test by *what the note is about*, not what the repo happens to ship: a product that merely bundles a `SKILL.md` (e.g. deepsec) is a note about that product, not about the manifest spec — so it is not an `agent-skills` note.

Example: `tags: [agent-skills, ui-ux, frontend]` for a SKILL.md package about design engineering that ships real DOM/JS code.

### Concision norm for explainer notes

Keep explainers tight. A few short sections, no trivia (author bios, benchmark counts, model-version specifics) unless it adds filter or recall value. Prefer a clean pipeline/summary over exhaustive detail.
