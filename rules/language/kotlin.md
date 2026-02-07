# Kotlin

## Project Structure
```
project/
├── src/
│   ├── main/kotlin/
│   └── test/kotlin/
├── build.gradle.kts
└── settings.gradle.kts
```
- **(MUST)** Production code in `src/main/kotlin`
- **(MUST)** Test code in `src/test/kotlin`
- **(SHOULD)** Use Gradle with Kotlin DSL (`build.gradle.kts`)

## Package Naming
- **(MUST)** Reverse domain name (`com.company.project`)
- **(MUST)** All lowercase, avoid underscores
- **(MUST NOT)** No generic names (`util`, `common`, `helper`)
- **(SHOULD)** One main class per file

## Formatting
- **(MUST)** 4-space indentation
- **(MUST)** Line length 120 chars max
- **(MAY)** ktlint or detekt recommended

## Naming Conventions
- **(MUST)** Classes/Interfaces: PascalCase
- **(MUST)** Functions/Properties: camelCase
- **(MUST)** Constants (`const val`): UPPER_SNAKE_CASE
- **(SHOULD)** Booleans prefixed with `is`, `has`, `can`

## Null Safety
**(MUST)** Use non-nullable types by default
**(MUST NOT)** Never use `!!` operator
**(SHOULD)** Use `?.`, `?:`, `let`, early return
**(SHOULD)** Nullable chains max 3 levels deep

## Type Inference
**(SHOULD)** Use inference when type is obvious
**(MUST)** Explicit return type for public API functions

## Data Classes
**(MUST)** Use `data class` for data classes
**(MUST)** Default to `val` for immutability
**(MUST)** Use `copy()` for modifications

## Sealed Classes
**(SHOULD)** Use sealed class for restricted hierarchies
**(MUST)** `when` must be exhaustive

## Extension Functions
**(SHOULD)** Use extension functions when class modification is not possible
**(MUST NOT)** No extension functions that mutate class internal state

## Scope Functions
- `let`: Nullable handling
- `apply`: Object initialization
- `also`: Side effects
**(MUST NOT)** No excessive nesting

## Coroutines
**(MUST)** Use suspend functions for I/O operations
**(MUST)** No blocking calls inside suspend functions
**(SHOULD)** Use `withContext` for dispatcher switching

### Dispatchers
- **(MUST)** `Dispatchers.IO`: I/O operations
- **(MUST)** `Dispatchers.Default`: CPU-intensive work
- **(MUST)** `Dispatchers.Main`: UI updates

### Structured Concurrency
**(MUST)** Use `coroutineScope` or custom CoroutineScope
**(MUST NOT)** Never use `GlobalScope`

### Flow
**(SHOULD)** Use Flow for async streams
**(SHOULD)** Use StateFlow for state management

## Error Handling
**(SHOULD)** Catch specific exceptions
**(SHOULD)** Use `Result` type or `runCatching`
**(MUST)** Handle all cases with `when`

## Collections & Functional
**(MUST)** Prefer functional collection operations (`filter`, `map`, `sorted`)
**(MUST NOT)** Prefer declarative over imperative for loops
**(SHOULD)** Use `Sequence` for large collections

## Immutability
**(MUST)** Use immutable collections by default
**(MUST)** Default to `val`, use `var` only when necessary
**(MUST NOT)** Never expose mutable collections in public API

## Dependency Injection
**(MUST)** Use constructor injection
**(MUST NOT)** No field injection
**(MAY)** Koin, Hilt, etc. allowed

## Testing
Format: `methodName - state - expectedBehavior`
```kotlin
@Test
fun `getModel - model exists - returns model`() { ... }
```
**(MAY)** Kotest FreeSpec or StringSpec recommended
**(SHOULD)** Use MockK library
**(MUST)** Test suspend functions with `runTest`

## HTTP Server
**(MAY)** Ktor recommended, Spring Boot/Micronaut also acceptable
