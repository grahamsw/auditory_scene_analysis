## Context

The current `HomophonicDemo.vue` uses `setTimeout` for timing, which is unreliable in browsers due to tab throttling and JS execution jitter. The demonstration requires precise millisecond-level accuracy to differentiate between "Abrupt" (2 objects) and "Gradual" (1 object) perception.

## Goals / Non-Goals

**Goals:**
- Implement a precise look-ahead scheduler for the audio cycle.
- Match SuperCollider's amplitude envelope exactly.
- Synchronize UI (SVG playhead) with the audio clock.
- Improve code readability and maintainability of the demo.

**Non-Goals:**
- Changing the underlying sound source (White Noise) significantly (though optimization is okay).
- Adding complex multi-voice orchestration (this is a single-stream demo).

## Decisions

### 1. Scheduler Implementation: Look-Ahead pattern
**Rationale:** Standard `setTimeout` or `requestAnimationFrame` alone are not precise enough for audio triggers. We will use a scheduler that looks ahead ~100ms into the future and schedules Web Audio events slightly before they need to happen.
**Alternatives:** 
- `setInterval`: Even less reliable than `setTimeout`.
- `OfflineAudioContext`: Good for rendering, but doesn't allow real-time parameter interaction.

### 2. Audio Graph: Constant Noise Source + Gain Automation
**Rationale:** Instead of starting/stopping noise nodes, we will keep a noise source running (or loop a buffer) and automate a `GainNode`. This avoids click artifacts and reduces overhead.
**Implementation:**
- `AudioBufferSourceNode` with 2 seconds of white noise.
- `GainNode` with `linearRampToValueAtTime`.

### 3. SVG Animation: `requestAnimationFrame` with Clock Sync
**Rationale:** To keep the playhead in sync, we will use `requestAnimationFrame` to query the `audioContext.currentTime` and map it to the SVG coordinate space.
**Alternatives:** 
- CSS Transitions: Hard to sync precisely with the non-linear audio clock.

## Risks / Trade-offs

- **[Risk]** Context Suspend: Browsers may suspend the audio context if there is no user gesture.
  - **Mitigation:** Ensure `ctx.resume()` is called on every "Start" button click.
- **[Risk]** Float32 Precision: Tiny `riseTime` (e.g., 0.001s) might be affected by ramp implementation details in some browsers.
  - **Mitigation:** Test across browsers and ensure `setValueAtTime` is used before starting a ramp.
