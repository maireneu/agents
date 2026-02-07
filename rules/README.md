# MRN Rules

This directory contains rules used by MRN.
The `/sync` command excludes this file (README.md) during synchronization.

## Rules List and Selection Criteria

### Common (Always Included)
| Rule | Description |
|------|-------------|
| `rule.md` | RFC 2119 and priority |
| `common/git.md` | Git conventions, commits, PR |
| `common/security.md` | Credentials, dangerous operation confirmation |
| `design/coding-style.md` | Comments, immutability, pure functions, SOLID |
| `design/test.md` | Test rules |

### Conditional
| Rule | Condition |
|------|-----------|
| `design/api.md` | HTTP API server project (REST, GraphQL, etc.) |
| `design/hexagonal.md` | Hexagonal architecture (`domain/`, `application/`, `adapter/` structure) |
| `language/python.md` | Python project |
| `language/golang.md` | Go project |
| `language/kotlin.md` | Kotlin project |
| `language/typescript.md` | TypeScript / Next.js project |

### Project Analysis Hints
- **Language**: Determine by build files (`pyproject.toml`, `go.mod`, `build.gradle.kts`, `tsconfig.json`, `package.json`, etc.)
- **API**: Web framework dependency or `api/`, `controller/`, `handler/` directory exists
- **Hexagonal**: `domain/`, `application/`, `adapter/` directory structure (at root or under src)
