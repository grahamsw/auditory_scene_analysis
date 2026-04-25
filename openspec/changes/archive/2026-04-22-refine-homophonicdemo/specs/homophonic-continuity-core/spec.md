## ADDED Requirements

### Requirement: Precise Amplitude Envelope
The system SHALL implement the homophonic continuity amplitude envelope using the following timings: 342ms base level, `riseTime` to peak level (1.0), 32ms peak level, `riseTime` back to base level, and 348ms base level.

#### Scenario: Envelope Cycle
- **WHEN** the demo cycle begins
- **THEN** the amplitude SHALL follow the sequence: Base(342ms) -> Rise(riseTime) -> Peak(32ms) -> Fall(riseTime) -> Base(348ms)

### Requirement: High-Precision Scheduling
The system SHALL use the Web Audio API's clock and scheduled parameter changes (e.g., `linearRampToValueAtTime`) to ensure the envelope timings are accurate and free of jitter.

#### Scenario: Jitter-Free playback
- **WHEN** the demo is running over multiple cycles
- **THEN** the onset and offset of the amplitude ramps MUST stay perfectly aligned with the Web Audio clock.

### Requirement: Adjustable Parameters
The system SHALL allow the user to adjust the `riseTime` and `baseLevel` in real-time.

#### Scenario: Parameter Update
- **WHEN** the user changes the `riseTime` slider
- **THEN** the next envelope cycle MUST use the updated `riseTime` value.
