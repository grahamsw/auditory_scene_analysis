## ADDED Requirements

### Requirement: Type-Safe Audio Initialization

The audio context initialization MUST be type-safe and accurately represent the fallback to `webkitAudioContext` for Safari without relying on an `any` typecast.

#### Scenario: Global Window extension

- **WHEN** initializing the web audio context
- **THEN** it must use the extended `Window` interface containing `webkitAudioContext`
- **AND** there should be no TypeScript compilation errors regarding `webkitAudioContext` not existing on type `Window`.