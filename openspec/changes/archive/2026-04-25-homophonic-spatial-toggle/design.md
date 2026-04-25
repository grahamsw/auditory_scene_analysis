## Context

The current Homophonic Continuity implementation uses a single gain node to apply a volume envelope to a filtered white noise source. This results in a mono signal (panned to both channels equally). To achieve spatial separation between the constant base sound and the intermittent peak sound, the signal path must be split.

## Goals / Non-Goals

**Goals:**
- Separate the constant background noise from the intermittent ramped noise.
- Provide a mechanism to swap their stereo positioning (Left vs Right).
- Maintain homophonicity by using a single noise source and filter for both paths.

**Non-Goals:**
- Smooth panning transitions (hard switching between cycles is sufficient).
- Multi-channel support beyond Stereo.

## Decisions

### Decision: Parallel Gain Nodes for Signal Decomposition
To allow independent spatial treatment of the two components (constant vs intermittent), we will use two parallel `GainNode`s connected to the same `BiquadFilterNode`.
- **Rationale**: This is the most efficient way to split the signal while ensuring they share the same noise source and spectral characteristics.
- **Alternatives**: Using a single `ChannelSplitterNode` and `ChannelMergerNode` was considered, but it's more complex for simple stereo panning of distinct envelopes.

### Decision: StereoPannerNodes for Spatial Positioning
Each gain path will be connected to a `StereoPannerNode` before reaching the destination.
- **Rationale**: `StereoPannerNode` provides a simple API (`pan.value`) to move signals hard Left (-1) or hard Right (1).
- **Alternatives**: Manual `GainNode` mapping to `ChannelMergerNode` inputs, but `StereoPannerNode` is cleaner and more idiomatic.

### Decision: Updated Envelope Scheduling
The `intermittentGain` node will be scheduled to ramp from `0.0` to `(1.0 - baseLevel)`. The `constantGain` node will remain fixed at `baseLevel`.
- **Rationale**: Summing these two paths results in the original `baseLevel` to `1.0` envelope if they were mono, preserving the psychoacoustic intent while allowing spatial separation.

## Risks / Trade-offs

- **[Risk] Summing Issues** → If both paths are panned to the same side, the total peak level will be 1.0. If panned to different sides, each channel peaks at its respective component level. This is intended behavior for spatial separation.
- **[Risk] Audio Node Overhead** → Adding 2 Panners and 2 Gain nodes is negligible for modern browsers.
