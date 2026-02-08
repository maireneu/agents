# Unsync MRN Rules

Remove MRN coding rules from the current project's `.claude/rules/` directory.

## Instructions

Follow these steps in order:

### Step 1: Check Existing Rules
Check if `.claude/rules/` exists in the current project.
If it does not exist, inform the user and stop.

### Step 2: User Confirmation
Use `AskUserQuestion` to ask how to handle the existing rules:
- **Backup and remove**: Move to `.claude/rules.bak.<timestamp>/`
- **Delete permanently**: Remove without backup

### Step 3: Execute
Run the unsync script:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/unsync.sh ".claude/rules" [--backup]
```
Pass `--backup` flag if the user chose to backup.

### Step 4: Report Results
Report what was done and the backup path if applicable.
