# Agents

AI agent plugins organized by platform.

## Structure

```
.claude-plugin/
  marketplace.json   - Plugin marketplace registry
claude/
  plugins/
    hello-world/     - Example plugin
    mrn-rules/       - MRN coding rules sync plugin
rules/               - MRN coding rules (source of truth)
  common/            - Git, security rules
  design/            - API, architecture, testing, coding style
  language/          - Go, Kotlin, Python, TypeScript
```

## Claude Code Marketplace

### Adding this marketplace

```bash
/plugin marketplace add maireneu/agents
```

### Available plugins

| Plugin | Description | Commands |
|--------|------------|----------|
| hello-world | Example plugin | `/hello-world:hello` |
| mrn-rules | Sync MRN coding rules to project | `/mrn-rules:sync`, `/mrn-rules:unsync` |

### mrn-rules plugin

Syncs curated coding rules into your project's `.claude/rules/` directory.

- `/mrn-rules:sync` - Analyzes your project, selects applicable rules, and copies them to `.claude/rules/`
- `/mrn-rules:unsync` - Removes synced rules from `.claude/rules/` (with optional backup)

Rules are auto-selected based on project characteristics (language, framework, build files). See `rules/README.md` for the full rule list and selection criteria.

### Local development

```bash
claude --plugin-dir ./claude/plugins/<plugin-name>
```
