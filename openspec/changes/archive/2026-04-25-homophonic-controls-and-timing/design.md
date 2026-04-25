## Context

The current `HomophonicDemo.vue` uses hardcoded timing constants for the base and peak durations, and couples rise and fall times into a single `riseTime` parameter. It also lacks spectral controls for the noise source, which is often band-limited in ASA experiments to isolate perceptual effects.

## Goals / Non-Goals

**Goals:**
- Decouple Rise and Fall times for asymmetric envelope exploration.
- Expose all timing components (Steady Base 1, Peak, Steady Base 2, Cycle Duration) to the UI.
- Add a Bandpass filter with Frequency and Q controls.
- Update the SVG visualization to dynamically reflect all timing and envelope changes.

**Non-Goals:**
- Adding multi-channel or spatial support (covered by other demos).
- Supporting custom noise types (e.g., pink noise) beyond filtered white noise.

## Decisions

- **Parameter State**: Convert hardcoded constants (`BASE1_DUR`, `PEAK_DUR`, etc.) into Vue `ref`s to allow UI binding.
- **Audio Chain Expansion**: 
  - `AudioBufferSourceNode` -> `BiquadFilterNode` -> `GainNode` -> `AudioContext.destination`.
  - The `BiquadFilterNode` will be of type `'bandpass'`.
- **Scheduling Logic**:
  - The `scheduleEnvelope` function will be updated to use the new `ref` values.
  - It will ensure that the sum of segments does not exceed `cycleDuration`.
- **SVG Visualization**:
  - The `envelopePath` computed property will be updated to handle asymmetric rise/fall and dynamic durations.
  - X-scaling will be relative to `cycleDuration`.
- **UI Organization**:
  - Use `fieldset` or CSS Grid to group parameters into "Timing", "Envelope", and "Filter" sections.

## Risks / Trade-offs

- **[Risk] Parameter Overlap**: Users might set segment durations that exceed the total cycle duration.
  - **Mitigation**: Implement a computed `totalDuration` check or use `Math.min` in the scheduler to clamp segment timings within the cycle.
- **[Risk] Filter Instability**: High Q values can cause ringing or clipping.
  - **Mitigation**: Clamp Q value to a safe range (e.g., 0.1 to 20.0) and include a small safety margin in the base amplitude.
