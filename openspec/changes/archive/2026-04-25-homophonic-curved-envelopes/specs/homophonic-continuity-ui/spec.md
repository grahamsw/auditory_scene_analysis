## ADDED Requirements

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
