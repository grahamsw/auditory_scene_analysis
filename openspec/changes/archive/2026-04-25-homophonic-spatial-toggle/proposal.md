## Why

In the Homophonic Continuity demo, spatial separation can further enhance or compete with the perceptual grouping of the sounds. Allowing users to toggle the stereo positioning of the constant base sound and the intermittent peak sound provides a way to explore how spatial location interacts with continuity and volume envelopes in Auditory Scene Analysis.

## What Changes

- Add a spatial control to the Homophonic Continuity demo that swaps the stereo placement of the base level and the peak level.
- Implement hard-left and hard-right panning for the two components.
- Update the UI with a "Swap Channels" toggle.

## Capabilities

### New Capabilities
- `homophonic-spatial-logic`: Manages the stereo positioning and panning of different components within the homophonic audio engine.

### Modified Capabilities
- `homophonic-continuity-ui`: Add controls for spatial channel swapping and visual indicators for current channel mapping.
- `homophonic-continuity-core`: Expand the audio engine to support independent panning for the base and peak components.

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Update template and script to handle panning.
- `web/src/types.ts`: Update `HomophonicSettings` to include spatial state.
- Audio Engine: Introduction of `StereoPannerNode` or equivalent to handle separation.
