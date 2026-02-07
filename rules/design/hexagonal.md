# Hexagonal Architecture (Ports & Adapters)

## Overview
```
┌─────────────────────────────────────────────────┐
│              Adapters (Outer)                   │
│  ┌───────────────────────────────────────────┐  │
│  │        Application (Middle)               │  │
│  │  ┌─────────────────────────────────────┐  │  │
│  │  │         Domain (Core)               │  │  │
│  │  │  - Pure business logic              │  │  │
│  │  │  - No external dependencies         │  │  │
│  │  └─────────────────────────────────────┘  │  │
│  │  - Use Cases, Orchestration               │  │
│  └───────────────────────────────────────────┘  │
│  - Inbound: API, CLI                            │
│  - Outbound: Database, External APIs            │
└─────────────────────────────────────────────────┘
```
**(MUST)** Dependencies point inward only: Adapters → Application → Domain

## Domain Layer
Location: `domain/`
**(MUST NOT)** No dependencies on external frameworks or databases
**(MUST NOT)** No imports from `application/` or `adapter/`
**(MUST)** Contains only pure functions and data structures

## Application Layer
Location: `application/`

### Ports (`application/port/`)
**Inbound Ports**: Interfaces exposed to the outside
- Naming: `*UseCase`, `*Service`
**Outbound Ports**: Interfaces for external dependencies
- Naming: `*Repository`, `*Client`, `*Gateway`

### Use Cases (`application/use_case/`)
**(MUST)** Implement Inbound Ports
**(MUST)** Depend only on Outbound Port interfaces (not implementations)

## Adapter Layer
Location: `adapter/`
**(MAY)** Organize by `inbound/outbound` or `api/repository` per team convention
**Inbound Adapters**: REST API controllers, CLI handlers, event listeners
**Outbound Adapters**: Database implementations, external API clients, message queue publishers
