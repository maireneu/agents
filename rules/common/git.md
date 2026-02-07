# Git

## Commit Messages
**(MUST)** Follow Conventional Commits format:
```
<type>: <subject>

<body>

<footer>
```
**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting (no code changes)
- `refactor`: Refactoring
- `test`: Tests
- `chore`: Build, package configuration
- `perf`: Performance improvement
- `init`: Initial project setup
- `merge`: Branch merge
**Guidelines:**
- **(SHOULD)** Subject: 50 chars recommended, 72 chars max
- **(SHOULD)** Body: Wrap at 72 chars

## Commit Granularity
**(SHOULD)** One commit = one logical change
**(MUST NOT)** Do not mix unrelated changes in a single commit
Split strategy:
- **By file**: When changes in different files are independent
- **By logic**: When a single file has multiple distinct changes
- **By feature**: When implementing a feature with clear sub-components

## Issue Linking
**(SHOULD)** Include GitHub or JIRA issue key in footer
```
Refs: issue-804
```
Can be extracted from branch name. Omit if not available.

## AI Attribution
**(SHOULD)** Add to footer when using AI tools
```
# Claude Code
🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Branch Naming
**(SHOULD)** Derive from JIRA issue key
- `feature/issue-804`

## PR
**(MUST)** 100% test pass before PR
**(MUST)** Follow `.github/pull_request_template.md` if it exists
**(MUST)** Review line-by-line, not just the PR summary
