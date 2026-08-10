## MODIFIED Requirements

### Requirement: Dual Parameter Storage
The system SHALL maintain two independent storage buffers (Set 1 and Set 2) for all homophonic demo parameters, including all timing segments (Base 1, Rise, Peak, Fall, Base 2), cycle duration, spectral filter settings (Frequency, Q), and envelope geometry settings (Curve, Spatial).

#### Scenario: Initializing sets
- **WHEN** the system loads
- **THEN** Set 1 SHALL be initialized with "Gradual" parameters: Curve: true, Rise: 250ms, Fall: 250ms, Peak: 100ms.
- **AND** Set 2 SHALL be initialized with "Abrupt" parameters: Curve: true, Rise: 1ms, Fall: 1ms, Peak: 100ms.
- **AND** Set 1 SHALL be selected as the active set.
