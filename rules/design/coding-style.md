# Coding Style

## Comments
**(SHOULD)** Explain "why", not "what"
- **(MUST)** Document business context and design decisions
- **(SHOULD NOT)** No comments for self-explanatory code
- **(MUST)** Document workaround rationale
- **(MUST)** Document assumptions that affect behavior
**When comments are needed:**
- Business rules not obvious from code
- Performance optimizations with trade-offs
- Workarounds for external system constraints
- Security considerations
**When comments are unnecessary:**
- Variable assignments, simple loops, function calls, obvious logic

## Immutability
**(MUST)** Use immutable data structures wherever possible
- Declare variables/properties as immutable by default
- Prefer immutable collection types
- Create new instances when modification is needed

## Pure Functions
**(SHOULD)** Write all functions as pure functions when possible
- Same input → always same output
- No external state mutation
- No external state dependency
**(SHOULD)** Separate I/O operations (file, network, DB) from pure logic
**(MUST)** If side effects are required, indicate in function name (e.g., `save_`, `send_`, `update_`)

## SOLID Principles
**(SHOULD)** Follow SOLID principles in object-oriented design:
1. **Single Responsibility**: One class, one responsibility, one reason to change
2. **Open/Closed**: Open for extension, closed for modification
3. **Liskov Substitution**: Subtypes must be substitutable for base types
4. **Interface Segregation**: Don't depend on unused interfaces
5. **Dependency Inversion**: High-level modules depend on abstractions, not implementations

## Paradigm Harmony
**(SHOULD)** Combine the strengths of OOP and FP:
- Design system structure with OOP principles (SOLID, DI)
- Implement internal business logic with FP (pure functions, immutability)
- Isolate side effects at system boundaries (API, DB, file I/O)
