---
description: Create a Pull Request from the current branch with template support and reviewer assignment
user-invocable: true
---

# Create Pull Request

Create a Pull Request from the current branch's changes.

## Instructions

Follow these steps in order. If any information was already provided by the caller (e.g., from the `start` skill), skip collecting it again.

---

### Step 1: PR Info Collection

Skip any fields already provided. Use `AskUserQuestion` to collect missing info.

#### 1.1 Base Branch
- Default: `develop`
- Let the user change if needed

#### 1.2 Reviewers
- User provides reviewer usernames

#### 1.3 PR Template
Search for a PR template file:
1. Check `.github/pull_request_template.md`
2. Check `pull_request_template.md` in repo root
3. If not found → proceed without one

---

### Step 2: Analyze Changes

Analyze changes against the base branch confirmed in Step 1:

```bash
git log --oneline $(git merge-base HEAD <base_branch>)..HEAD
git diff <base_branch>...HEAD --stat
```

Understand the full scope of commits and file changes that will be included in the PR.

---

### Step 3: Draft PR Title and Body

1. **Title**: Derive from the commit history. Keep under 70 characters.
2. **Body**:
   - If a PR template was found → fill in the template
   - Otherwise → use this default structure:
     ```
     ## Summary
     <bullet points summarizing changes>

     ## Changes
     <list of key modified files/modules>

     ## Test Plan
     <how changes were tested>
     ```
   - If the branch is associated with a GitHub issue (detected from branch name pattern like `issue-#N` or `#N`), include `Closes #<issue_number>` in the body

---

### Step 4: User Review

Present the draft PR title and body to the user via `AskUserQuestion`:
- Show the full PR title and body
- Ask for approval or modifications

Wait for user confirmation before proceeding.

---

### Step 5: Push and Create PR

1. Push the branch to remote:
   ```bash
   git push -u origin <branch-name>
   ```
2. Create the PR with the confirmed title, body, base branch, and reviewers
3. Report the PR URL to the user
