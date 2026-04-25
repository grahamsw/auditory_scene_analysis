## ADDED Requirements

### Requirement: Dual Parameter Storage
The system SHALL maintain two independent storage buffers (Set 1 and Set 2) for all homophonic demo parameters, including all timing segments (Base 1, Rise, Peak, Fall, Base 2), cycle duration, and spectral filter settings (Frequency, Q).

#### Scenario: Initializing sets
- **WHEN** the system loads
- **THEN** both Set 1 and Set 2 SHALL be initialized with the default Bregman/Ahad psychoacoustic parameters.

### Requirement: Active Parameter Selection
The system SHALL allow the user to select either Set 1 or Set 2 as the "Active" set that currently drives the audio engine and visualization.

#### Scenario: Switching active set
- **WHEN** the user selects "Use Set 2"
- **THEN** all audio parameters and the SVG visualization SHALL immediately update to reflect the values stored in Set 2.

### Requirement: Parameter Capture (Set Timings)
The system SHALL provide a mechanism to "Capture" or "Set" the current slider values into the currently active storage buffer.

#### Scenario: Saving current values to a set
- **WHEN** the user adjusts sliders and then clicks "Save to Set 1"
- **THEN** the current slider values SHALL be stored in the Set 1 buffer.
