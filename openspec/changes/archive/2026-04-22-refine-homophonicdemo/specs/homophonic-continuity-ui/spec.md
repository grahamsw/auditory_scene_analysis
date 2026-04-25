## ADDED Requirements

### Requirement: Dynamic Envelope Visualization
The system SHALL provide an SVG visualization that dynamically updates to reflect the current amplitude envelope shape based on the `riseTime` parameter.

#### Scenario: Rise Time change visualization
- **WHEN** the `riseTime` is set to 1ms (abrupt)
- **THEN** the SVG path SHALL show a sharp rectangular jump.
- **WHEN** the `riseTime` is set to 250ms (gradual)
- **THEN** the SVG path SHALL show a sloped trapezoidal ramp.

### Requirement: Real-time Playhead Indicator
The system SHALL display a visual indicator (e.g., a vertical line or color change) moving across the envelope diagram synchronized with the audio playback.

#### Scenario: Playhead synchronization
- **WHEN** the audio is playing
- **THEN** a playhead SHALL move across the SVG diagram in perfect sync with the current position in the audio cycle.

### Requirement: Categorical Parameter Hints
The system SHALL provide clear text hints indicating the perceptual result of the current settings (e.g., "Abrupt: 2 objects" vs "Gradual: 1 object").

#### Scenario: Perceptual hint display
- **WHEN** `riseTime` is less than 10ms
- **THEN** the UI SHALL display a hint indicating "Abrupt: Heard as TWO objects (Ghost sound joining)".
- **WHEN** `riseTime` is greater than 100ms
- **THEN** the UI SHALL display a hint indicating "Gradual: Heard as ONE object changing volume".
