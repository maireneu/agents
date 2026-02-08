# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A Claude Code plugin marketplace (`mrn-plugins`) owned by `maireneu`. Contains reusable plugins and coding rules that can be installed into any project via `/plugin marketplace add maireneu/Agents`.

## Architecture

- `.claude-plugin/marketplace.json` — Plugin registry (must stay at repo root for GitHub discovery)
- `claude/plugins/<name>/` — Individual plugins, each with `.claude-plugin/plugin.json`
- `rules/` — Canonical coding rules (source of truth). Plugins reference these, never duplicate them.
- `rules/README.md` — Single source of truth for rule selection criteria and project analysis logic

The `mrn-rules` plugin contains a symlink `rules → ../../../rules` so it can access the canonical rules at runtime via `${CLAUDE_PLUGIN_ROOT}/rules/`.

## Plugin Anatomy

Each plugin lives in `claude/plugins/<name>/` and has:
- `.claude-plugin/plugin.json` — Name, version, author metadata
- `commands/*.md` — Slash commands (e.g., `/mrn-rules:sync`). Markdown files that instruct Claude what to do.
- `scripts/*.sh` — Shell scripts invoked by commands
- `skills/*/SKILL.md` — Reusable skills (optional)

When editing `commands/*.md`, keep instructions generic and delegate specifics to data files (like `rules/README.md`). Avoid hardcoding file lists or analysis rules that could go stale.

## Git Conventions

Commit hook (`.git/hooks/commit-msg`) enforces type prefixes. Allowed types:
```
feat fix refactor perf docs style test chore init merge
```
Example: `feat: Add new plugin command`

Main branch is `main`. Development happens on `master`.

## Key Decisions

- Windows development environment — use `mklink /D` for symlinks (not `ln -s`), with relative paths so git stores them portably (mode `120000`)
- Rules are written in English
- Rule files use RFC 2119 keywords (MUST, SHOULD, MAY) for severity
- `sync.md` intentionally delegates all project analysis logic to `rules/README.md` to avoid duplication
