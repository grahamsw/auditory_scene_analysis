## ADDED Requirements

### Requirement: Curved Amplitude Ramps
The system SHALL support curved amplitude ramps in the `scheduleEnvelope` function for both the Constant (if applicable) and Intermittent paths.
- For the **Rise** segment, the system SHALL use an exponential ramp or a high-order power curve to ensure a "start slow, get faster" onset.
- For the **Fall** segment, the system SHALL use a curve that begins with a low slope and ends with a high slope.

#### Scenario: Audio scheduling with curves
- **WHEN** the "Curved" mode is active
- **THEN** the `intermittentGainNode` SHALL be scheduled using `exponentialRampToValueAtTime` or `setValueCurveAtTime` to achieve the accelerating shape.
