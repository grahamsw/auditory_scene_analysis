## Why

The current Homophonic Continuity demo (Demo 32) allows for real-time parameter exploration but makes it difficult to quickly compare two specific sets of psychoacoustic parameters (e.g., comparing "Abrupt" vs "Gradual" transitions). A toggle mode will allow users to define, save, and rapidly switch between two distinct configurations to better perceive the "Old-Plus-New" heuristic.

## What Changes

- **Toggle Mode UI**: Add a "Toggle Mode" switch to the UI.
- **Dual Parameter Sets**: Maintain two independent sets of timing and filter parameters (Mode 1 and Mode 2).
- **"Set Timings" Action**: Provide a way to capture the current slider values into the currently active mode's buffer.
- **"Use Timings" State**: Implement the logic to apply the selected mode's parameters to the audio engine and visualization.
- **Improved Comparison**: Allow instant switching between two configurations without manual slider adjustment.

## Capabilities

### New Capabilities
- `homophonic-toggle-logic`: Logic for managing two sets of parameter states and switching between them.

### Modified Capabilities
- `homophonic-continuity-ui`: Update the UI to include toggle controls and mode-specific configuration buttons.
- `homophonic-continuity-core`: Ensure the timing engine can handle rapid parameter set swaps.

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Update state management and UI template.
- `web/src/types.ts`: May need to define a `HomophonicState` interface if shared between modes.
