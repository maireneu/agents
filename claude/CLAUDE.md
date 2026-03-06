# CLAUDE.md

## 1. GitHub Integration

When interacting with GitHub (issues, PRs, repos, actions, etc.), MUST use MCP tools (e.g., `mcp__github__*`) instead of the `gh` CLI. Fall back to `gh` only when no MCP tool covers the required operation.

## 2. Terminal Tools

Prefer these modern alternatives over their traditional counterparts:

| Use         | Instead of | Notes                    |
|-------------|------------|--------------------------|
| `eza`       | `ls`       | Modern replacement for ls |
| `fd`        | `find`     | Simpler syntax, respects .gitignore |
| `tree`      | —          | Available for directory visualization |

## 3. Shell Commands

Do not prepend `cd <dir> &&` when the current working directory is already the target directory. Run commands directly.
