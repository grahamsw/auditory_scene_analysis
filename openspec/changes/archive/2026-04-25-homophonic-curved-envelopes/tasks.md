## 1. Types and State

- [x] 1.1 Update `HomophonicSettings` in `web/src/types.ts` to include `isCurved: boolean`.
- [x] 1.2 Update `DEFAULT_SETTINGS` and component refs in `HomophonicDemo.vue` to include `isCurved`.
- [x] 1.3 Update `saveToSet` and `loadFromSet` in `HomophonicDemo.vue` to include `isCurved`.

## 2. SVG Visualization (Geometric update)

- [x] 2.1 Update `envelopePath` computed property in `HomophonicDemo.vue`.
- [x] 2.2 If `isCurved` is true, use `Q` commands for Rise and Fall segments.
- [x] 2.3 Verify SVG path geometry matches the "start slow, get faster" description.

## 3. Audio Engine Implementation

- [x] 3.1 Implement a `generateQuadraticCurve(start, end, points)` helper function.
- [x] 3.2 Update `scheduleEnvelope()` in `HomophonicDemo.vue` to check `isCurved`.
- [x] 3.3 If `isCurved` is true, use `setValueCurveAtTime` for the Rise and Fall ramps on `intermittentGainNode`.
- [x] 3.4 Ensure segments still transition smoothly at the peak and base levels.

## 4. UI Controls

- [x] 4.1 Add a "Curved Envelopes" toggle (switch or button) to the "Envelope" fieldset in `HomophonicDemo.vue`.
- [x] 4.2 Add a descriptive label or hint explaining the curve shape.

## 5. Verification

- [x] 5.1 Verify that enabling "Curved" visually changes the SVG ramps to be convex/concave.
- [x] 5.2 Verify that audio playback follows the curved ramps without clicks or glitches.
- [x] 5.3 Verify that switching between Linear and Curved works during active playback.
