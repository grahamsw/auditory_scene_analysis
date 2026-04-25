## ADDED Requirements

### Requirement: Atomic Parameter Swap
The system SHALL support atomic swapping of the entire parameter set driving the `scheduleEnvelope` function to ensure consistency within a playback cycle.

#### Scenario: Mid-cycle swap
- **WHEN** the active set is switched while the audio is playing
- **THEN** the current cycle SHALL complete with existing parameters, and the NEXT scheduled cycle SHALL use the newly selected set.
