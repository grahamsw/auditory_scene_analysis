## ADDED Requirements

### Requirement: Spatial Channel Mapping
The system SHALL support two spatial mapping configurations for the homophonic components:
1. **Normal**: Constant (Base) component on the Left, Intermittent (Peak) component on the Right.
2. **Swapped**: Constant (Base) component on the Right, Intermittent (Peak) component on the Left.

#### Scenario: Switching spatial mapping
- **WHEN** the spatial mapping is set to "Normal"
- **THEN** the constant base noise SHALL be panned hard Left and the intermittent peak noise SHALL be panned hard Right.
- **WHEN** the spatial mapping is set to "Swapped"
- **THEN** the constant base noise SHALL be panned hard Right and the intermittent peak noise SHALL be panned hard Left.

### Requirement: Independent Component Panning
The system SHALL provide independent panning control for the "Constant" (base level) and "Intermittent" (envelope ramp) portions of the noise signal.

#### Scenario: Panning verification
- **WHEN** only the Constant component is active (volume at base level)
- **THEN** audio output SHALL only be heard in the channel designated by the current spatial mapping.
