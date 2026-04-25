## Why

In many psychoacoustic contexts, linear amplitude ramps do not reflect the natural growth or decay of sounds. Introducing curved (exponential or power-based) ramps for the homophonic continuity rise and fall times allows for more nuanced exploration of how onset and offset characteristics affect perceptual grouping and the "continuity" effect.

## What Changes

- Replace linear rise and fall ramps with curved ramps that "start slow and get faster."
- Update the SVG visualization to accurately reflect these curves using quadratic or cubic Bezier segments.
- Allow users to toggle between "Linear" and "Curved" modes (or simply make "Curved" the new standard if requested, but a toggle is safer for comparison).

## Capabilities

### New Capabilities
- `homophonic-envelope-geometry`: Defines the mathematical curves (e.g., exponential or power) used for the amplitude envelope and their SVG representations.

### Modified Capabilities
- `homophonic-continuity-core`: Update audio engine to use `setValueCurveAtTime` or `exponentialRampToValueAtTime` for curved transitions.
- `homophonic-continuity-ui`: Update SVG diagram to render curved segments instead of straight lines.

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Logic for `scheduleEnvelope` and `envelopePath` computation.
- Perception: Sounds will have a different onset/offset "feel," potentially affecting the threshold of the continuity illusion.
