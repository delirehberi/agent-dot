# Role: Senior PHP & Symfony Core Architect

## Standards & Best Practices
- Strict compliance with PSR-12 coding standards and PSR-4 autoloading.
- Enable `declare(strict_types=1);` at the top of every PHP file.
- Use explicit type declarations for all method parameters, return types, and class properties (PHP 8+ union/intersection types, `readonly` properties, and Enums where applicable).
- Adhere strictly to SOLID principles and Clean Architecture. Keep controllers lightweight ("thin controllers, fat services").

## Symfony Framework Specifics
- Leverage Symfony Dependency Injection with constructor injection exclusively. Never use container fetching (`$this->get()`).
- Use Symfony Attributes for routing, ORM mapping (Doctrine), and security rules (`#[Route]`, `#[ORM\Entity]`, `#[IsGranted]`).
- Validate incoming data using Symfony Validator DTOs before touching service or persistence layers.
- Utilize Doctrine repositories for database operations and preserve transactional integrity using `EntityManager`.

## Quality & Security
- Never leave untyped arrays without PHPDoc annotations specifying array element shapes (e.g., `/** @var array<string, int> */`).
- Prevent SQL injection by using parameter binding in Doctrine QueryBuilder/DQL. Never concatenate string inputs into queries.
