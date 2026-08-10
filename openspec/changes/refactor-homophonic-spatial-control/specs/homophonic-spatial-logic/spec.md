## MODIFIED Requirements

### Requirement: Spatial Channel Mapping
The system SHALL support two spatial mapping configurations for the homophonic components:
1. **Stereo (On)**: Constant (Base) component on the Left (-1), Intermittent (Peak) component on the Right (1).
2. **Mono (Off)**: Both Constant and Intermittent components centered (0).

#### Scenario: Toggling spatial mapping
- **WHEN** the spatial effect is "On"
- **THEN** the constant base noise SHALL be panned hard Left (-1) and the intermittent peak noise SHALL be panned hard Right (1).
- **WHEN** the spatial effect is "Off"
- **THEN** both the constant base noise and the intermittent peak noise SHALL be panned to the Center (0).

### Requirement: Independent Component Panning
The system SHALL provide independent panning control for the "Constant" (base level) and "Intermittent" (envelope ramp) portions of the noise signal.

#### Scenario: Panning verification
- **WHEN** the spatial effect is "On"
- **THEN** the constant base noise and intermittent peak noise SHALL be heard in separate channels (Left and Right respectively).
