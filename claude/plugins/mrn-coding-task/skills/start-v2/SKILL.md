---
description: Issue-driven development with superpowers skill delegation — branch, plan, implement with reviews, PR, and issue comment
user-invocable: true
argument-hint: "[issue-number]"
---

# Start Coding Task v2

GitHub Issue-driven coding workflow that delegates core development phases to superpowers skills for higher quality output.

**Inline phases** (1–4, 7, 11–12): GitHub Issue lifecycle management.
**Delegated phases** (5–6, 8–10, 13): Core development via specialized skills.

## Instructions

Follow these phases in order. Do NOT skip phases unless explicitly noted.

---

### Phase 1: Issue Key Resolution

Determine the GitHub issue number to work on.

**Priority order:**
1. If the user provided an issue number or URL (via `$ARGUMENTS`) → extract and use it
2. Try extracting from the current branch name:
   ```bash
   git branch --show-current
   ```
   Match patterns: `#(\d+)`, `issue-(\d+)`, `(\d+)` in branch name
3. If on `main` or `develop` (or the repo's default branch) → ask the user:
   ```
   AskUserQuestion: "Which GitHub issue should I work on?"
   ```

Store the resolved issue number and the repository owner/name (from git remote) for all subsequent phases.

---

### Phase 2: Issue Branch Creation

Create a feature branch for this issue if not already on one.

1. Check current branch:
   ```bash
   git branch --show-current
   ```
2. **If already on an issue-related branch** (contains the issue number) → skip to Phase 3
3. **If on `main`, `develop`, or default branch** → propose a new branch:
   - Default name: `feature/issue-#<number>`
   - Use `AskUserQuestion` to confirm or let the user customize the branch name
   - Create and checkout:
     ```bash
     git checkout -b <branch-name>
     ```

---

### Phase 3: Set Issue In Progress

Update the issue status in GitHub Projects (if available).

1. Use `projects_list` (method: `list_projects`) to find projects for the repo owner
2. If a project is found:
   - `projects_list` (method: `list_project_fields`) → find the Status field and its ID
   - `projects_list` (method: `list_project_items`) with query filter for this issue → find the item ID
   - `projects_write` (method: `update_project_item`) → set Status to "In Progress"
3. **If no project or item is found → skip silently.** Not all repos use GitHub Projects.

---

### Phase 4: Issue & Context Gathering

Collect all information needed to understand the issue.

1. **Main issue**: `issue_read` (method: `get`) → title, body, labels, assignees
2. **Issue comments**: `issue_read` (method: `get_comments`) → additional context
3. **Referenced resources** in issue body:
   - Other issue numbers (e.g., `#42`) → `issue_read` for 1-depth linked issues
   - Repo-internal documents (README, `docs/`, or other directories containing architecture/design docs) → read them
   - External document links → `WebFetch` if accessible
4. **Exploration rule**: Follow first-depth references. Do not recurse deeper unless necessary for understanding.

---

### Phase 5: Codebase Exploration (Delegated)

Use `feature-dev:code-explorer` agents for deep codebase analysis.

Launch **2–3 code-explorer agents in parallel** using the `Agent` tool with `subagent_type: "feature-dev:code-explorer"`. Each agent targets a different aspect:

1. **Related code**: Files, modules, and functions that relate to the issue. Trace execution paths.
2. **Test patterns**: Existing test structure, frameworks, conventions, and coverage patterns.
3. **Architecture**: Module boundaries, design patterns, conventions from CLAUDE.md or docs.

After agents complete:
- Read all important files they identified
- Synthesize findings into a summary for use in later phases
- Note: key file paths, existing patterns to follow, test conventions, potential impact areas

---

### Phase 6: Brainstorming (Delegated)

Invoke `superpowers:brainstorming` via the `Skill` tool.

**Context to provide**: Before invoking, summarize the following so the skill has full context:
- Issue title, body, and key comments (from Phase 4)
- Codebase analysis findings (from Phase 5)

The brainstorming skill will:
1. Ask clarifying questions one at a time
2. Propose 2–3 approaches with trade-offs
3. Present a design for user approval
4. Save a design doc to `docs/plans/YYYY-MM-DD-<topic>-design.md`

**Override**: When the skill finishes and invokes `writing-plans`, let it proceed naturally — this flows into Phase 8.

---

### Phase 7: PR Info Pre-collection

Gather PR-related information before planning implementation.

Use a single `AskUserQuestion` with three questions:
- **Base branch**: Which branch should the PR target? (default: `main`)
- **Reviewers**: Who should review the PR? (free text input)
- **Commit mode**: How should commits be handled during implementation?
  - **Auto-commit** (default): Commit automatically after each task passes tests. No confirmation needed.
  - **Confirm each**: Ask for user approval before every commit, so the user can review the diff first.

Store the selected commit mode for use in Phase 9.

---

### Phase 8: Implementation Planning (Delegated)

Invoke `superpowers:writing-plans` via the `Skill` tool.

**Note**: If this was already invoked by the brainstorming skill in Phase 6, skip this phase.

**Context to provide**: Before invoking, summarize the following so the skill has full context:
- Design document (from Phase 6)
- Base branch and reviewers (from Phase 7)

**Override**: When `writing-plans` finishes and offers execution choices (subagent-driven vs parallel session), do NOT select either. Instead, continue to Phase 9.

The plan will be saved to `docs/plans/YYYY-MM-DD-<feature-name>.md` by the skill.

---

### Phase 9: Step-by-Step Execution (Delegated)

Invoke `superpowers:subagent-driven-development` via the `Skill` tool.

**Context to provide**:
- The implementation plan created in Phase 8
- **Commit mode** selected in Phase 7:
  - If **auto-commit**: Include in every implementer subagent prompt: "After tests pass, commit immediately with the planned commit message. Do NOT ask for user confirmation."
  - If **confirm each**: Include in every implementer subagent prompt: "After tests pass, present a summary of changes and wait for user approval before committing."

**Overrides**:
- **Git worktree**: The skill marks worktrees as REQUIRED. Since we already created a feature branch in Phase 2, skip the worktree requirement. The feature branch provides sufficient isolation.
- **Finishing**: When the skill reaches `finishing-a-development-branch`, do NOT invoke that skill. Instead, continue to Phase 11.

The skill will execute each task with:
- Implementer subagent per task
- Spec reviewer (confirms plan compliance)
- Code quality reviewer
- Tests and commits per task (commit behavior depends on commit mode)

---

### Phase 10: TDD Enforcement

This is NOT a separate phase to execute. It is a **standing rule** that applies throughout Phase 9.

All implementer subagents in Phase 9 MUST follow the TDD discipline from `superpowers:test-driven-development`:

1. **RED**: Write a failing test first. Run it. Verify it fails for the right reason.
2. **GREEN**: Write minimal code to make the test pass. Verify it passes.
3. **REFACTOR**: Clean up while keeping tests green.

**Iron Law**: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST. If code is written before a test, delete it and start over.

Include this instruction in every implementer subagent prompt dispatched in Phase 9.

---

### Phase 11: PR Creation

After all steps are committed, delegate to the `create-pr` skill.

Pass the following info already collected in Phase 7:
- Base branch
- Reviewers

The `create-pr` skill will handle pushing, drafting, user review, and PR creation.

---

### Phase 12: Issue Comment

After the PR is created, add a comment to the original GitHub issue.

Use `add_issue_comment` with:
- Summary of what was implemented
- Link to the PR
- List of key changed files

---

### Phase 13: Verification (Delegated)

Invoke `superpowers:verification-before-completion` via the `Skill` tool.

Before claiming the task is complete, verify:
- All tests pass (fresh run, not cached results)
- PR was created successfully
- Issue comment was posted
- No uncommitted changes remain

Only after verification evidence confirms all of the above, announce completion.
