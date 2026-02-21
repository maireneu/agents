# Plugin Setup for Remote Sessions

You are reading this document because a user wants to install plugins from the **maireneu/agents** marketplace. Follow the instructions below step by step.

## Overview

This document instructs you to:
1. Register the marketplace using the `claude` CLI
2. Discover available plugins from the registry
3. Present them to the user for selection
4. Install selected plugins using the `claude` CLI

## Step 1: Register the Marketplace

Run the following command to add the marketplace:

```bash
claude plugin marketplace add maireneu/agents
```

If the marketplace is already registered, this is a no-op.

## Step 2: Discover Available Plugins

Fetch the marketplace registry to get the current plugin list. Do NOT rely on any hardcoded list — always read from the source.

1. Fetch the raw content of the marketplace registry:
   `https://raw.githubusercontent.com/maireneu/agents/main/.claude-plugin/marketplace.json`
2. Parse the `plugins` array. For each plugin, note the `name` and `description`.
3. Optionally, for richer descriptions, fetch each plugin's `plugin.json` from:
   `https://raw.githubusercontent.com/maireneu/agents/main/{source}/.claude-plugin/plugin.json`
   where `{source}` is the plugin's `source` field from the marketplace registry.
4. You may also inspect `commands/` and `skills/` directories within each plugin source to list available slash commands and skills.

## Step 3: Present Plugins to the User

Show the user a summary of each discovered plugin:
- **Name** and **description**
- Available **commands** (slash commands) and **skills**, if found
- A brief explanation of what each plugin does

Then ask the user which plugins they want to install. Use the `AskUserQuestion` tool with `multiSelect: true` so the user can pick any combination via checkboxes. Exclude obviously internal or example-only plugins (like `hello-world`) from the default recommendation, but still list them as available.

If the user cannot interact with the multi-select UI (e.g., on mobile), fall back to asking them to list their choices in plain text.

## Step 4: Install Selected Plugins

For each selected plugin, run:

```bash
claude plugin install <plugin-name>@mrn-plugins
```

For example:
```bash
claude plugin install mrn-rules@mrn-plugins
claude plugin install mrn-coding-task@mrn-plugins
```

This handles everything automatically — downloading the plugin, caching it, and updating `~/.claude/settings.json` with the correct `enabledPlugins` and `extraKnownMarketplaces` entries.

## Step 5: Confirm

After installation, show the user:
1. Which plugins were installed successfully
2. A note that a **session restart** may be required for plugins to fully load
3. Suggest the user restart the session (or let it go idle and resume) to activate the plugins

## Important Notes

- The marketplace name is `mrn-plugins` (as defined in `marketplace.json`).
- The marketplace source is the GitHub repo `maireneu/agents`.
- Always read from the live marketplace registry — never hardcode plugin lists.
- Use `claude plugin install` — do NOT manually edit `~/.claude/settings.json`.
