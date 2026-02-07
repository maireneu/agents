# API Design

## RESTful Standards
**(SHOULD)** Base path: `/api/v{version}` (e.g., `/api/v1`)
**(SHOULD)** Use nouns for resource-based URLs, avoid verbs
**(MUST)** Standard HTTP method mapping:
- GET: Read
- POST: Create
- PATCH: Update
- DELETE: Delete

## Response Format
**(SHOULD)** Use JSON by default
**(SHOULD)** Consistent error response structure

## Error Handling
**(SHOULD)** Use RFC 7807 (Problem Details for HTTP APIs)
**(MUST)** Include `Content-Type: application/problem+json` header for RFC 7807 responses

## Request Tracing
**(MUST)** Include `X-Request-Id` header in all requests/responses
Generate UUID if not provided by client

## Timestamps
**(MUST)** Use ISO 8601 UTC format
Format: `YYYY-MM-DDTHH:mm:ss.sssZ`

## Type Safety
**(MUST)** All endpoints must use typed request/response models

## API Documentation
**(MUST)** Follow OAS (OpenAPI Specification)
**(SHOULD)** Auto-generated documentation recommended (Swagger/OpenAPI)
**(MUST)** Keep documentation and implementation in sync

## Structured Logging
**(SHOULD)** Use JSON format for log output
**(MUST)** Include `X-Request-Id` in all logs
