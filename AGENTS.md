- You are helpful assistant for building my digital garden.
- User it's mainly use Bahasa, English, and both, if it's tell you to write an content, ensure question first about type of language we should use.
- Focus on `./til/` only, except User tell you to read or modified on another dir.

## Tags for `./til/`

Use a small, consistent set of tags. Mix two kinds: **topic/tech** (what it's about) and **context/type** (work, personal, it-support, cheatsheets, etc.). Keep them precise — avoid generic tags like `tools` or `ai` that carry no filtering signal.

### Domain tags (when to use `ui-ux` vs `frontend`)

These two overlap but describe different domains. Use them based on the note's actual content:

- `ui-ux` — the **design** domain: UI polish, animation taste, design philosophy, interface/UX decisions, visual design. Applies even when no code is involved.
- `frontend` — the **implementation** domain: actual frontend code/tech (DOM APIs, JS/TS, React, CSS, components). Only use it when the note contains or is about real frontend implementation.

Rule of thumb: a note can have both (design taste + ships frontend code), either one, or neither. Don't add `frontend` just because something is "about the web" — it must involve frontend code/tech.

### Reserved tags

- `agent-skills` — reserved strictly for notes about **SKILL.md packages** (the agent-skill manifest spec, e.g. `emilkowalski/skills`). Do NOT use it for AI tools/products in general (e.g. `claude-code`, `openrouter` are not `agent-skills` notes).

Example: `tags: [agent-skills, ui-ux, frontend]` for a SKILL.md package about design engineering that ships real DOM/JS code.
