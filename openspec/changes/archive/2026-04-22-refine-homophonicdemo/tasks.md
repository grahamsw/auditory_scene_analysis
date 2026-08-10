## 1. Audio Logic Refinement

- [x] 1.1 Implement precise white noise buffer generation (2s loop).
- [x] 1.2 Implement the high-precision look-ahead scheduler (100ms look-ahead, 25ms interval).
- [x] 1.3 Implement the amplitude envelope ramp sequence using `linearRampToValueAtTime`.
- [x] 1.4 Integrate the scheduler into the `start()` and `stop()` methods.

## 2. UI and Visualization

- [x] 2.1 Update the SVG diagram to use a dynamic `path` based on `riseTime`.
- [x] 2.2 Implement the synchronized playhead using `requestAnimationFrame`.
- [x] 2.3 Add categorical hints and descriptions (Abrupt vs Gradual) to the UI.
- [x] 2.4 Refine CSS styling for better layout and parameter readability.

## 3. Verification and Cleanup

- [x] 3.1 Verify timing accuracy against the SuperCollider reference timings.
- [x] 3.2 Ensure proper resource cleanup (stopping nodes, clearing intervals) in `onUnmounted`.
- [x] 3.3 Test parameter changes during playback to ensure smooth transitions.
