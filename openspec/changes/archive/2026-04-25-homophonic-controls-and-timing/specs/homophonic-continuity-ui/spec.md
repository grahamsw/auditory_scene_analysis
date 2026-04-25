## MODIFIED Requirements

### Requirement: Dynamic Envelope Visualization
The system SHALL provide an SVG visualization that dynamically updates to reflect the current amplitude envelope shape based on the rise time, fall time, and duration parameters.

#### Scenario: Asymmetric ramp visualization
- **WHEN** Rise Time is 10ms and Fall Time is 250ms
- **THEN** the SVG path SHALL show a sharp vertical rise followed by a gradual sloped decay.

### Requirement: Real-time Playhead Indicator
The system SHALL display a visual indicator (e.g., a vertical line or color change) moving across the envelope diagram synchronized with the audio playback.

#### Scenario: Playhead synchronization
- **WHEN** the audio is playing
- **THEN** a playhead SHALL move across the SVG diagram in perfect sync with the current position in the audio cycle.

### Requirement: Categorical Parameter Hints
The system SHALL provide clear text hints indicating the perceptual result of the current settings, specifically focusing on the rise and fall times.

#### Scenario: Perceptual hint display
- **WHEN** both Rise Time and Fall Time are less than 10ms
- **THEN** the UI SHALL display a hint indicating "Abrupt: Heard as TWO objects (Ghost sound joining)".
- **WHEN** both Rise Time and Fall Time are greater than 100ms
- **THEN** the UI SHALL display a hint indicating "Gradual: Heard as ONE object changing volume".

## ADDED Requirements

### Requirement: Spectral and Timing Control Interface
The UI SHALL provide a structured layout for managing the expanded set of timing (Rise, Fall, Durations) and spectral (Frequency, Q) parameters.

#### Scenario: Parameter grouping
- **WHEN** the user views the demo
- **THEN** controls SHALL be grouped logically into "Timing", "Envelope", and "Spectral" sections for clarity.
