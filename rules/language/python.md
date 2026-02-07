# Python

## Project Structure
```
project/
├── src/<package>/
│   └── ...
├── tests/
├── pyproject.toml
└── uv.lock
```
- **(MUST)** Use `src/` layout
- **(MAY)** `__init__.py` can be omitted (Python 3.3+ namespace packages)
- **(MUST)** Pin all dependencies and versions in `pyproject.toml`
- **(SHOULD)** Use `uv` for new projects

## Naming Conventions
- Files/Modules: `snake_case.py`
- Variables/Functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- **(MUST NOT)** Never call magic methods directly (`obj.__len__()` → `len(obj)`)

## Type Hints
**(MUST)** Type hints required for all function signatures
- **(MUST)** Parameter and return type hints required
- **(MUST)** Use `Optional[T]` for nullable
- **(SHOULD)** Use `Any` sparingly with justification
- **(SHOULD)** Use specific collection types (`list[str]`, `dict[str, int]`)

## Data Classes
**(SHOULD)** Use `@dataclass` for domain objects
```python
@dataclass(frozen=True)  # Immutability recommended
class Model:
    name: str
    version: str
    tags: list[str]
    description: str | None = None
```
**(MAY)** Pydantic `BaseModel` allowed for API layer

## Async Patterns
**(SHOULD)** Use async/await for I/O operations
**(MUST NOT)** Never mix async with blocking I/O
**(MUST)** Use `asyncio.to_thread()` for blocking calls inside async functions

## Resource Management
**(MUST)** Use context managers for files, network, DB connections, etc.
```python
async with ResourceClient() as client:
    result = await client.fetch_data()
```
**(MUST)** Custom resource classes must implement `__enter__/__exit__` or `__aenter__/__aexit__`

## Error Handling
**(MUST)** No bare except clauses, catch specific exceptions
**(SHOULD)** Custom exceptions should inherit from `Exception`
**(MUST NOT)** Never use exceptions for control flow

## Collections & Functional
**(SHOULD)** Use list comprehension, generator expressions
**(SHOULD)** Use generators for large datasets
**(MUST NOT)** No mutable default arguments (`def f(items=[])` → `def f(items=None)`)

## Immutability
**(SHOULD)** Prefer `frozen=True` dataclass
**(MUST NOT)** No global mutable state

## Dependency Injection
**(MUST)** Inject dependencies via constructor or function parameters
**(MUST NOT)** No direct instantiation of external services at module level

## Testing
**(MUST)** Use pytest
Test naming: `test_method__state__expected`
```python
def test_get_model__model_exists__returns_model(): ...
def test_get_model__not_found__raises_error(): ...
```
**(MUST)** Use `pytest-asyncio` for async function tests
**(SHOULD)** Use `unittest.mock` or `pytest-mock` for mocking

## HTTP Server
**(MAY)** FastAPI recommended, Flask/Django also acceptable

## Linting
**(MUST)** Use `ruff` (lint + format)
**(MAY)** `mypy` recommended for static type checking
**(MAY)** `black` formatter allowed (choose one if overlapping with ruff format)
