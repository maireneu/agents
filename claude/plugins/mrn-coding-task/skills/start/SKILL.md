---
description: Start a coding task from a GitHub Issue — branch creation, planning, step-by-step implementation, PR, and issue comment
user-invocable: true
argument-hint: "[issue-number]"
---

# Start Coding Task

GitHub Issue-driven coding workflow. Analyzes an issue, creates a branch, plans the implementation, codes step-by-step with tests and commits, then creates a PR and comments on the issue.

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

### Phase 5: Codebase Analysis

Analyze the current repository to determine how to solve the issue.

- Identify files and modules that need modification
- Understand related code patterns and conventions
- Check test structure and existing test patterns
- Assess dependency and impact scope

Use `Glob`, `Grep`, `Read`, and the `Task` tool with `Explore` agent as needed.

---

### Phase 6: PR Info Pre-collection

Gather PR-related information before planning implementation.

Use a single `AskUserQuestion` with two questions:
- **Base branch**: Which branch should the PR target? (default: `develop`)
- **Reviewers**: Who should review the PR? (free text input)

---

### Phase 7: Implementation Planning

Use `EnterPlanMode` to design the implementation.

**Each Step in the plan MUST include:**
1. **Implementation**: What to modify or add (specific files and changes)
2. **Tests**: Test code that verifies this step's changes
3. **Commit message**: Descriptive commit message for this step

**Plan structure example:**
```
Step 1: [Module/Feature name]
- Implementation: ...
- Tests: ...
- Commit: "feat: ..."

Step 2: [Module/Feature name]
- Implementation: ...
- Tests: ...
- Commit: "feat: ..."
```

**Final Step** must be the PR creation plan:
- Base branch (from Phase 6)
- Reviewers (from Phase 6)
- PR body structure (using template if found)
- Include `Closes #<issue_number>` in PR body

---

### Phase 8: Plan Feedback Loop

Present the plan to the user with `ExitPlanMode`.

- Wait for user approval
- If the user requests changes → revise the plan and present again
- **Only proceed to implementation after explicit user approval**

---

### Phase 9: Step-by-Step Implementation

Execute each approved Step in order.

For each Step:

#### 9.1 Implement
- Write or modify code as described in the plan
- No user confirmation needed for code changes

#### 9.2 Test
- Write test code as described in the plan
- Run tests and ensure they all pass
- If tests fail → fix and re-run before proceeding

#### 9.3 Commit (requires user confirmation)
Use `AskUserQuestion` to request commit approval:
- Present a summary of changes made in this step
- Wait for the user to review the diff (e.g., in VSCode)
- On user approval → create the commit with the planned message

---

### Phase 10: PR Creation

After all steps are committed, delegate to the `create-pr` skill.

Pass the following info already collected in Phase 6:
- Base branch
- Reviewers

The `create-pr` skill will handle pushing, drafting, user review, and PR creation.

---

### Phase 11: Issue Comment

After the PR is created, add a comment to the original GitHub issue.

Use `add_issue_comment` with:
- Summary of what was implemented
- Link to the PR
- List of key changed files
