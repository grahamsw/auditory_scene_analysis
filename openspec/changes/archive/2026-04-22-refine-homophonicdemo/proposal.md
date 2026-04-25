## Why

The current implementation of the Homophonic Continuity demo (Demo 32) relies on imprecise `setTimeout` timing and lacks fidelity to the original Bregman/Ahad psychoacoustic parameters. To ensure high-quality demonstration of the "Old-Plus-New" heuristic, the timing needs to be precise and the visualization should clearly represent the amplitude changes.

## What Changes

- **Precise Timing:** Replace `setTimeout` with a Web Audio API look-ahead scheduler to eliminate jitter.
- **Accurate Parameters:** Implement the exact amplitude envelope timings from the SuperCollider reference `[0.342, riseTime, 0.032, riseTime, 0.348]`.
- **Enhanced Visualization:** Update the SVG diagram to dynamically reflect the current amplitude state and parameter settings.
- **Improved Audio Generation:** Use a cleaner noise generation and gain management pattern consistent with other demos.
- **UI Polish:** Refine the control layout and add clearer descriptions of the effect (Abrupt vs. Gradual).

## Capabilities

### New Capabilities
- `homophonic-continuity-core`: Core psychoacoustic logic and high-precision scheduling for Demo 32.
- `homophonic-continuity-ui`: Interactive controls and dynamic SVG visualization for Demo 32.

### Modified Capabilities
(None)

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Major rewrite of audio logic and UI.
- `web/src/audio.ts`: May require utility for precise scheduling if not already present.
