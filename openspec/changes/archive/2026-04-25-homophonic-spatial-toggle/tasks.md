## 1. Types and State

- [x] 1.1 Update `HomophonicSettings` in `web/src/types.ts` to include `isSpatialSwapped: boolean`.
- [x] 1.2 Update `DEFAULT_SETTINGS` and component refs in `HomophonicDemo.vue` to include `isSpatialSwapped`.
- [x] 1.3 Update `saveToSet` and `loadFromSet` in `HomophonicDemo.vue` to include spatial state.

## 2. Audio Engine Refactoring

- [x] 2.1 Update `start()` to create two parallel gain nodes (`constantGainNode`, `intermittentGainNode`) and two panners (`constantPanner`, `intermittentPanner`).
- [x] 2.2 Re-route audio nodes: `filterNode` should connect to both `constantGainNode` and `intermittentGainNode`.
- [x] 2.3 Connect each gain node to its respective panner, and both panners to `audioCtx.destination`.
- [x] 2.4 Update `scheduleEnvelope()` to apply fixed `baseLevel` gain to `constantGainNode` and the (0.0 to 1.0 - baseLevel) ramp to `intermittentGainNode`.
- [x] 2.5 Implement spatial mapping logic that sets `pan.value` to -1/1 based on `isSpatialSwapped`.
- [x] 2.6 Add a watcher for `isSpatialSwapped` to update panner values in real-time.

## 3. UI Implementation

- [x] 3.1 Add a "Spatial Mapping" fieldset to the template in `HomophonicDemo.vue`.
- [x] 3.2 Add a toggle button or checkbox for "Swap Channels (L/R)".
- [x] 3.3 Add a visual indicator label showing current mapping (e.g., "Constant: Left | Intermittent: Right").

## 4. Verification

- [x] 4.1 Verify that constant noise is hard panned to one side and intermittent peaks are heard on the other.
- [x] 4.2 Verify that toggling the swap control immediately moves the sounds to the opposite channels.
- [x] 4.3 Verify that preset "Capture" and "Use" correctly stores and restores the spatial mapping state.
