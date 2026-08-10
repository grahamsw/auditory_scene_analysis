# ASA Project Guidelines (Gemini)

## Core Principles
- **Accuracy:** Replicate Bregman's ASA demonstrations with high fidelity to the original psychoacoustic parameters (timings, frequencies, levels).
- **Dual-Stack:** Maintain parity between SuperCollider (`.scd`) implementations and Web Audio (`/web`) implementations where possible.
- **Documentation First:** Major changes or new demos should have a specification in `docs/specs/` before implementation.

## Tech Standards
- **SuperCollider:** Follow the pattern-based testing and clear SynthDef naming used in `supercollider/asa_demonstrations.scd`.
- **Web Audio:** Use the shared `AudioContext` from `src/audio.ts`. Ensure all nodes are disconnected/stopped in `onUnmounted` to prevent memory leaks and ghost audio.
- **Vue:** Use `<script setup lang="ts">`. Keep CSS scoped to components unless it's a global theme variable in `style.css`.

## Workflow
1. Read `docs/handover.md` to see the current state.
2. Read specific demo details in `docs/Auditory Scene Analysis Demonstrations.pdf`.
3. Create a spec in `docs/specs/`.
4. Implement and verify.
5. Update `docs/work_summary.md` and `docs/handover.md`.
