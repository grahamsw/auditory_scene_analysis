## ADDED Requirements

### Requirement: Band-Limited Noise Generation
The system SHALL provide a white noise source that is processed through a resonant Bandpass Filter to allow exploring the homophonic continuity effect in specific frequency regions.

#### Scenario: Filter engagement
- **WHEN** the demo starts
- **THEN** the noise source SHALL pass through a BiquadFilterNode configured as a 'bandpass' filter before reaching the gain envelope.

### Requirement: Spectral Parameter Control
The system SHALL allow real-time control over the Center Frequency and the Quality Factor (Q) or Bandwidth of the Bandpass filter.

#### Scenario: Frequency sweep
- **WHEN** the user changes the Center Frequency slider
- **THEN** the filter's frequency parameter SHALL update immediately to target the new spectral region.

#### Scenario: Bandwidth adjustment
- **WHEN** the Q factor is increased
- **THEN** the noise SHALL become more tonal as the filter bandwidth narrows around the center frequency.
