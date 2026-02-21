# Plugin Setup for Remote Sessions

You are reading this document because a user wants to configure the **maireneu/agents** plugin marketplace in their current project. Follow the instructions below step by step.

## Overview

This document instructs you to:
1. Discover available plugins from the marketplace
2. Present them to the user for selection
3. Write (or merge into) the project's `.claude/settings.json`

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

Then ask the user which plugins they want to enable. Use a multi-select question so they can pick any combination. Exclude obviously internal or example-only plugins (like `hello-world`) from the default recommendation, but still list them as available.

## Step 3: Write Settings

Based on the user's selection, write or merge into `.claude/settings.json` in the **current project root**.

### If `.claude/settings.json` does not exist

Create it with this structure:

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

### If `.claude/settings.json` already exists

Merge carefully:
- Add `mrn-plugins` to `extraKnownMarketplaces` if not already present
- Add selected plugins to `enabledPlugins`, preserving any existing entries
- Do NOT overwrite or remove existing settings

## Step 4: Confirm

After writing the file, show the user:
1. The final contents of `.claude/settings.json`
2. A note that the settings may require a **session restart** to take effect
3. Suggest the user restart the session (or let it go idle and resume) for plugins to load

## Important Notes

- The marketplace name is `mrn-plugins` (as defined in `marketplace.json`).
- The marketplace source is the GitHub repo `maireneu/agents`.
- Always read from the live marketplace registry — never hardcode plugin lists.
- Respect existing settings — merge, don't overwrite.
