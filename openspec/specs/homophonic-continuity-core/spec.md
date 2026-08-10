## Requirements

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

### Requirement: Atomic Parameter Swap
The system SHALL support atomic swapping of the entire parameter set driving the `scheduleEnvelope` function to ensure consistency within a playback cycle.

#### Scenario: Mid-cycle swap
- WHEN the active set is switched while the audio is playing
- THEN the current cycle SHALL complete with existing parameters, and the NEXT scheduled cycle SHALL use the newly selected set.

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

### Requirement: Curved Amplitude Ramps
The system SHALL support curved amplitude ramps in the `scheduleEnvelope` function for both the Constant (if applicable) and Intermittent paths.
- For the **Rise** segment, the system SHALL use an exponential ramp or a high-order power curve to ensure a "start slow, get faster" onset.
- For the **Fall** segment, the system SHALL use a curve that begins with a low slope and ends with a high slope.

#### Scenario: Audio scheduling with curves
- **WHEN** the "Curved" mode is active
- **THEN** the `intermittentGainNode` SHALL be scheduled using `exponentialRampToValueAtTime` or `setValueCurveAtTime` to achieve the accelerating shape.

