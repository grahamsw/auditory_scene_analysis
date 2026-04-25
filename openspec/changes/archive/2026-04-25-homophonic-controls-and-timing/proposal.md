## Why

The current Homophonic Continuity demo (Demo 32) provides basic controls but lacks the flexibility needed to explore the full range of parameters described in Bregman's ASA research. Specifically, it lacks independent control over rise/fall times and timing components, which are critical for demonstrating the "Old-Plus-New" heuristic in varying conditions.

## What Changes

- **Granular Timing Controls**: Expose parameters for Steady Duration, Peak Duration, and Total Cycle Duration.
- **Asymmetric Envelopes**: Add independent controls for Rise Time and Fall Time (currently they are coupled).
- **Spectral Character**: Add a Bandpass Filter to the noise source with controllable Center Frequency and Bandwidth (Q), allowing users to hear how the effect interacts with different spectral regions.
- **Improved Visualization**: Enhance the SVG diagram to reflect independent rise/fall times and the filtered noise spectrum.

## Capabilities

### New Capabilities
- `homophonic-timing-engine`: Advanced scheduling logic supporting asymmetric envelopes and variable cycle timing.
- `homophonic-spectral-controls`: Audio processing chain including band-limited noise generation and filtering.

### Modified Capabilities
- `homophonic-continuity-ui`: Update the UI to accommodate the new granular controls and enhanced visualization.

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Major update to both the `<script>` (audio logic) and `<template>` (UI/SVG).
- `web/src/audio.ts`: No changes expected.
