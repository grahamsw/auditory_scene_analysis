## Requirements

### Requirement: Dynamic Envelope Visualization
The system SHALL provide an SVG visualization that dynamically updates to reflect the current amplitude envelope shape based on the rise time, fall time, and duration parameters.

#### Scenario: Rise Time change visualization
- **WHEN** the `riseTime` is set to 1ms (abrupt)
- **THEN** the SVG path SHALL show a sharp rectangular jump.
- **WHEN** the `riseTime` is set to 250ms (gradual)
- **THEN** the SVG path SHALL show a sloped trapezoidal ramp.

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

### Requirement: Spectral and Timing Control Interface
The UI SHALL provide a structured layout for managing the expanded set of timing (Rise, Fall, Durations) and spectral (Frequency, Q) parameters.

#### Scenario: Parameter grouping
- **WHEN** the user views the demo
- **THEN** controls SHALL be grouped logically into "Timing", "Envelope", and "Spectral" sections for clarity.

### Requirement: Toggle Mode Controls
The system SHALL display buttons or a switch to select between "Set 1" and "Set 2", along with "Save current to Set X" actions for each.

#### Scenario: Visualizing active set
- WHEN Toggle Mode is enabled
- THEN the UI SHALL clearly indicate which set (1 or 2) is currently active.

### Requirement: Spatial Mapping Controls
The UI SHALL provide a control (e.g., a toggle button or switch) to swap the spatial mapping between "Normal" and "Swapped".

#### Scenario: Toggling spatial mapping
- WHEN the user clicks the "Swap Channels" button
- THEN the spatial mapping SHALL toggle between its two states.
- AND the UI SHALL update to show the current mapping (e.g., "Constant: Left, Intermittent: Right").

### Requirement: Curved Envelope Rendering
The SVG visualization SHALL render Rise and Fall segments as curves using SVG Path Bezier commands (`Q` or `C`) when "Curved" mode is active.

#### Scenario: Rendering curved path
- **WHEN** the `isCurved` property is true
- **THEN** the `envelopePath` computed property SHALL generate a path string containing Bezier segments for the Rise and Fall portions.

### Requirement: Curve Mode Toggle UI
The UI SHALL provide a control to switch between "Linear" and "Curved" envelope modes.

#### Scenario: Toggling envelope shape
- **WHEN** the user clicks the "Curved Envelopes" toggle
- **THEN** the `isCurved` state SHALL change and the SVG diagram SHALL immediately update its path geometry.

