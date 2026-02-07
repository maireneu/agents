# Security

## Credential Management
**(MUST NOT)** Never commit production credentials (API tokens, passwords, keys) to Git or include in public documents
**(MUST)** Credentials must only exist in:
- Vault
- Environment variables
- `.env` (gitignored)
**(SHOULD)** Use placeholders in documents: `<VAULT_TOKEN>`, `${USER_TOKEN}`
**(MAY)** Sandbox/Dev Zone credentials are allowed
**(MUST)** If accidentally committed:
1. Immediately rotate the credential
2. Remove from Git history with `git filter-repo`
3. Force push and notify the team

## Dangerous Operations
**(MUST)** Obtain explicit user confirmation before performing:
- Deleting files/directories outside the project or system-wide
- Database DROP, TRUNCATE, bulk DELETE/UPDATE (verify WHERE clause)
- Bulk data transfer to external systems
- Production environment configuration changes
- Infrastructure/IAM permission changes
- Hard-to-reverse operations (force push, migration without backup, etc.)
