## Why

The current "Swap Channels" spatial logic focuses on reversing the Left/Right assignment of Constant and Intermittent sounds. However, a more fundamental demonstration of ASA is comparing a spatially segregated sound (Stereo) with a spatially fused one (Mono/Centered). Switching to a "Stereo Effect" toggle allows users to hear how spatial separation contributes to object segregation.

## What Changes

- **BREAKING**: Replace `isSpatialSwapped` with `isSpatialEnabled` in the homophonic settings and audio logic.
- Update the audio engine to route Constant to Left (-1) and Intermittent to Right (1) when spatial is ON.
- Update the audio engine to route both to Center (0) when spatial is OFF.
- Update UI labels and controls to reflect "Stereo Effect: On/Off".

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `homophonic-spatial-logic`: Change requirement from channel swapping to stereo effect toggle (Left/Right vs. Center/Center).

## Impact

- `web/src/types.ts`: Rename property in `HomophonicSettings`.
- `web/src/components/demos/HomophonicDemo.vue`: Update refs, audio panner logic, and template.
- `openspec/specs/homophonic-spatial-logic/spec.md`: Requirement update.
