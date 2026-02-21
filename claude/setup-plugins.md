# Plugin Setup for Remote Sessions

You are reading this document because a user wants to configure the **maireneu/agents** plugin marketplace. Follow the instructions below step by step.

## Overview

This document instructs you to:
1. Discover available plugins from the marketplace
2. Present them to the user for selection
3. Merge plugin settings into the **user-level** `~/.claude/settings.json`

> **Why user-level?** Writing to the project's `.claude/settings.json` would create untracked files in the target repository, causing commit/gitignore issues. User-level settings apply across all projects without polluting any repo.

## Step 1: Discover Available Plugins

Fetch the marketplace registry to get the current plugin list. Do NOT rely on any hardcoded list — always read from the source.

1. Fetch the raw content of the marketplace registry:
   `https://raw.githubusercontent.com/maireneu/agents/main/.claude-plugin/marketplace.json`
2. Parse the `plugins` array. For each plugin, note the `name` and `description`.
3. Optionally, for richer descriptions, fetch each plugin's `plugin.json` from:
   `https://raw.githubusercontent.com/maireneu/agents/main/{source}/.claude-plugin/plugin.json`
   where `{source}` is the plugin's `source` field from the marketplace registry.
4. You may also inspect `commands/` and `skills/` directories within each plugin source to list available slash commands and skills.

## Step 2: Present Plugins to the User

Show the user a summary of each discovered plugin:
- **Name** and **description**
- Available **commands** (slash commands) and **skills**, if found
- A brief explanation of what each plugin does

Then ask the user which plugins they want to enable. Use the `AskUserQuestion` tool with `multiSelect: true` so the user can pick any combination via checkboxes. Exclude obviously internal or example-only plugins (like `hello-world`) from the default recommendation, but still list them as available.

If the user cannot interact with the multi-select UI (e.g., on mobile), fall back to asking them to list their choices in plain text.

## Step 3: Write Settings

Based on the user's selection, merge into `~/.claude/settings.json` (the **user-level** settings file).

### Settings to add

```json
{
  "extraKnownMarketplaces": {
    "mrn-plugins": {
      "source": {
        "source": "github",
        "repo": "maireneu/agents"
      }
    }
  },
  "enabledPlugins": {
    "<plugin-name>@mrn-plugins": true
  }
}
```

Replace `<plugin-name>` with each selected plugin's name (e.g., `mrn-rules@mrn-plugins`).

### Merge rules

- Read the existing `~/.claude/settings.json` first
- Add `mrn-plugins` to `extraKnownMarketplaces` if not already present
- Add selected plugins to `enabledPlugins`, preserving any existing entries
- Do NOT overwrite or remove any existing settings (hooks, permissions, etc.)

## Step 4: Confirm

After writing the file, show the user:
1. The final contents of `~/.claude/settings.json`
2. A note that the settings may require a **session restart** to take effect
3. Suggest the user restart the session (or let it go idle and resume) for plugins to load

## Important Notes

- The marketplace name is `mrn-plugins` (as defined in `marketplace.json`).
- The marketplace source is the GitHub repo `maireneu/agents`.
- Always read from the live marketplace registry — never hardcode plugin lists.
- Respect existing settings — merge, don't overwrite.
- Target file is `~/.claude/settings.json` (user-level), NOT the project's `.claude/settings.json`.
