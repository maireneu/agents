# Go

## Project Structure
```
project/
├── cmd/**/main.go      # Application entry points
├── internal/               # Private code
├── pkg/                    # Public libraries (optional)
├── api/                    # API definitions
├── test/                   # Test helpers
├── go.mod
└── go.sum
```
- **(MUST)** `cmd/` for executable entry points
- **(MUST)** `internal/` for private code

## Package Naming
- **(MUST)** Lowercase only (no underscores, no camelCase)
- **(SHOULD)** Use singular form (`model`, not `models`)
- **(MUST NOT)** No generic names (`util`, `common`, `base`)

## Formatting
**(MUST)** Apply `gofmt` to all code
**(MUST NOT)** No custom formatting rules

## Naming Conventions
- **(MUST)** Exported starts with uppercase, unexported with lowercase
- **(SHOULD)** Abbreviations should be consistent (`HTTP`/`http`, `ID`/`id`)
- **(MUST NOT)** No underscores

## Interface Naming
- Single-method: method + "er" (`Reader`, `Writer`)
- Multi-method: Descriptive name (`ModelRepository`)
- **(MUST NOT)** No `Interface` suffix

## Error Handling
**(MUST)** Handle all errors explicitly
**(MUST)** Error messages: lowercase, no punctuation
**(SHOULD)** Wrap with `fmt.Errorf` and `%w`
**(MUST NOT)** Never ignore errors with `_`
**(SHOULD)** Use `errors.Is()`, `errors.As()`

## Documentation
**(MUST)** All exported types/functions require doc comments
**(MUST)** Comments start with identifier name

## Concurrency

### Goroutines
**(MUST)** Clearly manage goroutine lifecycle
**(MUST)** Wait for completion with `sync.WaitGroup` or channels
**(MUST)** Pass loop variables as parameters
**(MUST NOT)** No goroutine leaks

### Context
**(MUST)** Context is the first parameter
**(MUST)** Never store Context in a struct field
**(MUST)** `defer cancel()` is mandatory
**(SHOULD)** Use context for I/O operations

### Channel
**(MUST)** Sender closes the channel (not receiver)
**(MUST)** Specify channel direction (`chan<-`, `<-chan`)

### Mutex
**(MUST)** Use mutex for shared data access
**(MUST)** Guarantee unlock with `defer`
**(SHOULD)** Use `RWMutex.RLock()` for read-only access

## Panic & Recover
**(MUST NOT)** Never use panic for general error handling
**(MAY)** Panic allowed for initialization errors (`MustConnect` pattern)
**(SHOULD)** Handle recover in HTTP middleware

## Testing
**(SHOULD)** Use Table-Driven Tests with `t.Run()` for 2+ cases
**(MUST)** Call `t.Helper()` in helper functions
**(MAY)** testify/mock, gomock allowed

## Dependency Management
**(MUST)** Include `go.mod` and `go.sum` in version control
**(SHOULD)** Run `go mod tidy` regularly
**(MUST)** Inject dependencies via constructor functions
**(MUST NOT)** No dependency management through global variables

## Performance
**(SHOULD)** Pre-allocate slice capacity (`make([]T, 0, cap)`)
**(SHOULD)** Use `strings.Builder` for string concatenation
**(SHOULD)** Use pointers for large structs
**(MUST)** Use pointer receivers for mutating methods
**(MUST)** Keep receiver type consistent

## HTTP Server
**(MAY)** Echo recommended, Gin/Chi/net/http also acceptable

## Linting
**(MUST)** Run `go fmt`, `go vet`
**(MAY)** `golangci-lint` recommended
