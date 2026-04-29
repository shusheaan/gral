# Codex Config

This directory tracks the repo-managed subset of `~/.codex`.

Synced by `sync-ai`:

- `config.toml`
- `hooks.json`
- `rules/default.rules`
- `~/.codex/AGENTS.md` linked to `claude/CLAUDE.md`
- `~/.codex/agents` linked to `claude/agents`
- `~/.codex/commands` linked to `claude/commands`
- Claude skills linked individually into `~/.codex/skills`

Not synced:

- `auth.json`
- `history.jsonl`
- `sessions/`
- `logs_*.sqlite`
- `state_*.sqlite`
- `cache/`
- `tmp/`
- `models_cache.json`
- `installation_id`

`~/.codex/skills` is not replaced as a whole because Codex owns its `.system`
skills. User skills from `claude/skills` are linked into that directory one by
one.
