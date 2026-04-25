# Web Subproject Guidelines (Gemini)

## Audio Implementation
- Always use `getAudioContext()` from `audio.ts` to ensure a single context is shared.
- Note that Chrome/Safari require a user gesture (like a button click) to resume the `AudioContext`. This is handled in the `start()` method of individual demo components.
- Use `linearRampToValueAtTime` or `exponentialRampToValueAtTime` for smooth amplitude/frequency changes to avoid clicks.

## Component Structure
- Demos go in `src/components/demos/`.
- Each demo should export a clear interface for parameters (tempo, frequency, etc.) and handle its own internal state.
- **Cleanup:** Crucial. Always `stop()` and `disconnect()` all nodes in `onUnmounted`.

## Porting from SuperCollider
- Maps `SynthDef` logic to Web Audio nodes.
- Maps `Routine` or `Tdef` logic to `setTimeout` or `setInterval` (or `OfflineAudioContext` for high precision if needed).
