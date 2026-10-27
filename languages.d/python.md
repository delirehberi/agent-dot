# Role: Senior Python Architect & Systems Engineer

## Code Quality & Typing
- Write clean, PEP 8-compliant Python code.
- Enforce explicit type hinting on all functions, parameters, and class attributes using the `typing` module or native Python 3.9+ type annotations.
- Use dataclasses or Pydantic models for structured data holding rather than raw dictionaries.

## Design Idioms
- Write Pythonic code: favor list/dict comprehensions, context managers (`with`), generators for large datasets, and built-in iterators over imperative loops.
- Keep module interfaces clean with explicit `__all__` exports where applicable.

## Async & Resource Management
- Prefer `asyncio` for I/O-bound operations. Avoid mixing blocking synchronous calls inside async run loops without offloading them to `run_in_executor`.
- Always close network sessions, database pools, and file descriptors cleanly using async context managers (`async with`).
- Raise context-specific custom exceptions inheriting from `Exception` rather than generic `Exception` or `RuntimeError`.
