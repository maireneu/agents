# Test

## TDD
**(MAY)** TDD recommended (write test → implement → refactor)

## Test Scope
**(MUST)** Test public methods/classes
**(SHOULD)** Test private/internal implementation through public interfaces

## Naming Convention
Format: `MethodName_StateUnderTest_ExpectedBehavior`
- snake_case languages: `method_name__state__expected`
- camelCase languages: `methodName_state_expected`
**(SHOULD)** Follow existing test style if tests already exist

## Mock (Unit Tests)
**(MUST)** Use mocks for all external dependencies (DB, network, filesystem) in unit tests
Do not use real external systems in unit tests

## Integration Tests
**(MAY)** Use Testcontainers when tests require external dependencies
**(MUST)** Do not connect directly to shared sandbox DBs or external environments (prevents data contamination)
**(MUST)** Separate integration tests from unit tests (separate directory or marker/tag)
**(MUST)** Must be independently runnable in CI with Docker

## CI/CD Compatibility
**(MUST)** Tests must be runnable in network-isolated environments
No external service dependencies

## Independence
**(MUST)** Each test must be independent and not affect other tests
No shared mutable state between tests

## Test Data
**(SHOULD)** Use fixtures for reusable test data
**(MAY)** Manage complex test data in JSON, YAML files
