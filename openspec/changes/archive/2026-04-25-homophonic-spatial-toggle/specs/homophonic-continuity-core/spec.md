## ADDED Requirements

### Requirement: Split-Path Signal Processing
The system SHALL decompose the homophonic signal into two parallel paths sharing the same noise source:
1. **Constant Path**: Pure white noise at the fixed `baseLevel`.
2. **Intermittent Path**: Pure white noise with an envelope that ramps between 0.0 and (1.0 - `baseLevel`).

#### Scenario: Signal decomposition
- **WHEN** the `baseLevel` is 0.25
- **THEN** the Constant Path SHALL output noise at 0.25 gain.
- **AND** the Intermittent Path SHALL output noise ramped from 0.0 up to 0.75 (peak) and back to 0.0.

### Requirement: Dynamic Spatial Routing
The system SHALL route the Constant and Intermittent paths to the Left or Right channels based on the active spatial mapping configuration.

#### Scenario: Routing to channels
- **WHEN** Spatial Mapping is "Normal"
- **THEN** the Constant Path SHALL be routed to the Left output and the Intermittent Path to the Right output.
