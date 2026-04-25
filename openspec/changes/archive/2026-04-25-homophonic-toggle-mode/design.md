## Context

The current `HomophonicDemo.vue` uses individual `ref`s for all audio parameters (riseTime, fallTime, baseLevel, etc.). While this works for real-time manipulation, it doesn't support storing or switching between multiple configurations.

## Goals / Non-Goals

**Goals:**
- Implement a dual-set parameter storage system.
- Provide UI controls to save the current "Live" state into a set.
- Provide UI controls to recall a set into the "Live" state.
- Ensure smooth audio transitions when switching sets.

**Non-Goals:**
- Persisting these sets to local storage or a database (session only).
- Supporting more than two sets.

## Decisions

- **Parameter Data Structure**: Define a `HomophonicSettings` interface in `web/src/types.ts` to encapsulate all relevant parameters.
  ```typescript
  interface HomophonicSettings {
    riseTime: number;
    fallTime: number;
    baseLevel: number;
    base1Dur: number;
    peakDur: number;
    base2Dur: number;
    cycleDur: number;
    filterFreq: number;
    filterQ: number;
  }
  ```
- **State Management**:
  - Maintain `set1` and `set2` as `ref<HomophonicSettings>`.
  - The existing "Live" `ref`s (e.g., `riseTime.value`) will remain the primary drivers for the audio engine.
  - "Save to Set X" will copy current Live values into `setX`.
  - "Use Set X" will copy `setX` values into the Live `ref`s.
- **UI Layout**:
  - Add a new "Mode Comparison" or "Presets" fieldset at the top of the controls.
  - Buttons: [Save to 1] [Use 1] | [Save to 2] [Use 2].
- **Atomic Updates**: Since all parameters are individual `ref`s, calling "Use Set X" will trigger multiple reactive updates. Vue's batching should handle the UI/SVG update, and the scheduler will pick up the new values in its next cycle.

## Risks / Trade-offs

- **[Risk] Parameter Desync**: If a user updates a slider after clicking "Use Set 1", the Live state no longer matches Set 1.
  - **Mitigation**: This is intentional "Live" exploration. The buttons act as "Capture" and "Recall" snapshots rather than persistent bindings.
- **[Risk] Rapid Switching Glitches**: Rapidly clicking "Use 1" and "Use 2" might cause the scheduler to mix parameters if not careful.
  - **Mitigation**: The scheduler copies `.value` at the start of `scheduleEnvelope`. Even if values change during the function execution, the local constants will keep the specific scheduled event consistent.
