# Agents

AI agent plugins organized by platform.

## Structure

```
claude/    - Claude Code plugin marketplace (mrn-plugins)
codex/     - OpenAI Codex plugins (planned)
```

## Claude Code Marketplace

### Adding this marketplace

```bash
/plugin marketplace add maireneu/Agents
```

### Available plugins

| Plugin | Description | Version |
|--------|------------|---------|
| hello-world | Example plugin with a greeting command | 0.1.0 |

### Local development

```bash
claude --plugin-dir ./claude/plugins/hello-world
```

### Adding a new plugin

1. Create a directory under `claude/plugins/<plugin-name>/`
2. Add `.claude-plugin/plugin.json` with plugin metadata
3. Add `commands/`, `skills/`, `agents/`, `hooks/` as needed
4. Register the plugin in `.claude-plugin/marketplace.json` (repo root)
