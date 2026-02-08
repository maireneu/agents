# Sync MRN Rules

Synchronize MRN coding rules to the current project's `.claude/rules/` directory.

## Instructions

Follow these steps in order:

### Step 1: Verify Rules Source
Check that `${CLAUDE_PLUGIN_ROOT}/rules/` exists and contains rule files.
If it does not exist, report the error and stop.

### Step 2: Read Rules README
Read `${CLAUDE_PLUGIN_ROOT}/rules/README.md`.
This file is the single source of truth for all subsequent steps.

### Step 3: Analyze Project
Follow the README to detect the current project's characteristics.

### Step 4: Determine Rule List
Based on the README's selection criteria and the analysis from Step 3, compile the list of rule files to sync.

### Step 5: User Confirmation
Use a single `AskUserQuestion` call with two questions:
1. Present the selected rules as multiSelect options so the user can deselect any unwanted rules.
2. If `.claude/rules/` already exists, ask whether to backup existing rules before overwriting.

### Step 6: Execute Sync
Run the sync script. Pass `--backup` flag if the user chose to backup.
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/sync.sh [--backup] "${CLAUDE_PLUGIN_ROOT}/rules" ".claude/rules" <file1> <file2> ...
```
Pass the confirmed rule file paths as arguments.

### Step 7: Report Results
After the script completes, report the sync results.
If a backup was created, include the backup path.
