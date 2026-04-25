## ADDED Requirements

### Requirement: Granular Timing Parameters
The system SHALL allow independent control over the following timing components of the envelope: Steady Base Duration (before rise), Peak Duration, Steady Base Duration (after fall), and Total Cycle Duration.

#### Scenario: Adjusting timing components
- **WHEN** the user modifies the "Peak Duration" parameter
- **THEN** the duration of the peak amplitude segment in the Web Audio envelope SHALL be updated accordingly for the next scheduled cycle.

### Requirement: Asymmetric Rise and Fall Times
The system SHALL support independent values for Rise Time and Fall Time.

#### Scenario: Setting asymmetric ramps
- **WHEN** Rise Time is set to 10ms and Fall Time is set to 250ms
- **THEN** the amplitude envelope SHALL ramp up sharply and decay gradually back to the base level.

### Requirement: Dynamic Cycle Scheduling
The system SHALL recalculate the envelope timing sequence whenever the Cycle Duration or any component duration is changed, ensuring that the components are fit within the cycle.

#### Scenario: Cycle duration change
- **WHEN** the Total Cycle Duration is increased to 3 seconds
- **THEN** the scheduler SHALL maintain the defined component durations and fill the remainder with the base level duration.
