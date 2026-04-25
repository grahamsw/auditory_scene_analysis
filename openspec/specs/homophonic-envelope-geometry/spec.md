# Capability: Homophonic Envelope Geometry

## Purpose
Define the geometric shapes and mathematical curves used for the homophonic continuity amplitude envelopes, supporting both linear and curved (accelerating) transitions.

## Requirements

### Requirement: Accelerating Envelope Curves
The system SHALL support amplitude envelope curves for the Rise and Fall segments that "start slow and get faster" (convex growth for Rise, concave-down decay for Fall).
- **Rise**: The slope SHALL increase over the duration of the segment.
- **Fall**: The slope SHALL start near zero and become increasingly negative over the duration of the segment.

#### Scenario: Visualizing curved segments
- **WHEN** the "Curved" mode is active
- **THEN** the Rise segment from Base to Peak SHALL be rendered as an upward-curving path.
- **AND** the Fall segment from Peak to Base SHALL be rendered as a downward-curving path (starts horizontal, ends steep).

### Requirement: Curve Mode Selection
The system SHALL allow the user to toggle between "Linear" and "Curved" amplitude ramps.

#### Scenario: Switching to Curved mode
- **WHEN** the user selects "Curved"
- **THEN** both the audio engine (scheduling) and the SVG visualization SHALL update to use the accelerating curves.
