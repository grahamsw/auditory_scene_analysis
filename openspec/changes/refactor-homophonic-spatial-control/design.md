## Context

The current spatial implementation uses `isSpatialSwapped` to toggle between Left/Right and Right/Left. The user wants to switch this to a Stereo Effect (On/Off) toggle, where Off means everything is centered (Mono).

## Goals / Non-Goals

**Goals:**
- Replace "Swap Channels" with "Stereo Effect" toggle.
- On = Constant Left, Intermittent Right.
- Off = Both Center.
- Maintain individual panner nodes for both paths.

## Decisions

- **Rename State**: Rename `isSpatialSwapped` to `isSpatialEnabled` across types and component refs.
- **Audio Logic**:
  ```typescript
  constantPanner.pan.value = isSpatialEnabled.value ? -1 : 0;
  intermittentPanner.pan.value = isSpatialEnabled.value ? 1 : 0;
  ```
- **UI Update**: Replace "Swap Channels" button with a toggle/switch labeled "Stereo Effect".

## Risks / Trade-offs

- **[Risk]** → Users might still want to swap channels.
- **[Mitigation]** → The current request explicitly asks for an On/Off stereo effect. Swapping can be re-added later as a separate control if needed.
