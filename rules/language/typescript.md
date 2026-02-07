# TypeScript

## Project Structure
```
project/
├── src/
│   ├── app/                # Next.js App Router
│   ├── components/
│   ├── lib/                # Utilities, helpers
│   ├── types/              # Shared type definitions
│   └── hooks/              # Custom hooks
├── tests/
├── tsconfig.json
├── package.json
└── next.config.ts
```
- **(MUST)** Use `src/` directory
- **(MUST)** `strict: true` in `tsconfig.json`

## Naming Conventions
- Files/Directories: `kebab-case` (including components)
- Variables/Functions: `camelCase`
- Classes/Interfaces/Types: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- **(SHOULD)** Booleans prefixed with `is`, `has`, `can`

## Type System
**(MUST)** Never use `any`, use `unknown` with type narrowing
**(MUST)** Explicit function return types
**(SHOULD)** `interface` for object shapes, `type` for unions/intersections
**(MUST NOT)** Never use `@ts-ignore`, use `@ts-expect-error` + reason if unavoidable
**(SHOULD)** Use generics to eliminate type duplication

## Null Safety
**(MUST)** Enable `strictNullChecks`
**(SHOULD)** Use optional chaining (`?.`), nullish coalescing (`??`)
**(MUST NOT)** No non-null assertion (`!`) abuse

## Immutability
**(MUST)** Default to `const`, use `let` only when necessary
**(MUST NOT)** Never use `var`
**(SHOULD)** Use `as const`, `readonly`, `Readonly<T>` for objects/arrays

## Async Patterns
**(MUST)** Use `async/await` for async operations
**(MUST)** Handle errors with `try/catch` for specific error types
**(MUST NOT)** No unhandled promise rejections

## Error Handling
**(MUST)** Define and use specific error types
**(MUST NOT)** No empty catch blocks
**(SHOULD)** Custom error classes should extend `Error`

## Dependency Injection
**(MUST)** Inject external dependencies via parameters or Context
**(MUST NOT)** No direct instantiation of external services at module level

## Testing
**(MAY)** Vitest recommended, Jest also acceptable
Test naming: `describe > it('should ...')`
**(SHOULD)** Use Testing Library for React components

## Linting
**(MUST)** Use ESLint + Prettier
**(MAY)** Biome allowed (replaces ESLint + Prettier)

---

## Next.js (App Router)

### Routing
**(MUST)** Use App Router (`app/`)
**(MUST)** Layouts in `layout.tsx`, pages in `page.tsx`

### Server / Client Components
**(MUST)** Default to Server Components
**(MUST)** Only add `'use client'` when Client Component is needed
**(SHOULD)** Place Client Components at tree leaves, minimize usage

### Data Fetching
**(MUST)** Fetch data or access DB directly in Server Components
**(MUST NOT)** No direct access to sensitive data from Client Components
**(SHOULD)** Use Server Actions for mutations

### Environment Variables
**(MUST)** Client-exposed variables must use `NEXT_PUBLIC_` prefix
**(MUST NOT)** Never expose server-only variables to client
