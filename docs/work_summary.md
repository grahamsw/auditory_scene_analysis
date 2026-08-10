# Work Summary - ASA Project

## Initial State
- Project contained several SuperCollider (`.scd`) scripts implementing Bregman's ASA demonstrations.
- Documentation existed in PDF and Markdown summaries.

## Session 1: Web Migration & Visualization (2026-04-18)
- Analyzed codebase and created architectural diagrams (Mermaid).
- Identified core parameters for Demo 39 (Spatial Segregation) from source PDF.
- Scaffolded a Vue 3 + TypeScript + Vite web project in `/web`.
- Implemented core Web Audio utility (`audio.ts`).
- **Implemented Demos in Web Audio:**
    1. **Streaming (Demo 1):** Rhythmic streaming with pitch/tempo controls.
    2. **Spatial Segregation (Demo 39):** Left/Right noise bursts with timing delay controls.
    3. **Harmonic Mistuning (Demo 18):** 8-harmonic synthesis with mistuning controls and SVG visualization.
    4. **Homophonic Continuity (Demo 32):** White noise amplitude modulation with rise-time controls.
- Created an **Overview Landing Page** with placeholder content explaining ASA and internal models/Anil Seth's theory.
- Fixed a compilation error in `App.vue` caused by accidental placeholder characters.
- Created project-wide documentation (READMEs, GEMINI guidelines, Handover).
- Reorganized file structure: Moved all SuperCollider (`.scd`) files into a dedicated `/supercollider` directory.

## Session 2: Compelling Demos & Threshold Effects (2026-08-01)
- Summarized the core mathematical and physical assumptions of Auditory Scene Analysis.
- Designed and implemented two new highly interactive, threshold-focused demonstrations:
  1. **Apparent Continuity (Picket Fence, Demo 28):** Tone with gaps masked by band-pass noise. Features controls for noise volume, gap size, and a "Mute Noise (Reveal Gaps)" toggle to expose the raw physical silence and break the illusion.
  2. **Asynchronous Onset (Demo 21):** Repeating 8-harmonic complex tone where the user can delay the onset of a single partial (0-150ms), showing that a tiny delay breaks perceptual fusion.
- Enhanced the **Harmonic Mistuning (Demo 18)** component:
  - Added an automated **Hysteresis Sweep** (in-tune -> out-of-tune -> in-tune) to demonstrate sensory memory.
  - Implemented a premium "Perceptual Object Map" SVG visualizer illustrating when the harmonic is fused, when it is segregated, and when it is tracked in hysteresis.
- Fully integrated the new demonstrations into `App.vue` navigation and layout.
- Rewrote `HomeView.vue` to explain the 1D-pressure-wave inverse problem, the 8 core assumptions, and why violating these rules creates uncanny, other-worldly auditory chimeras.
- Resolved strict TypeScript compiler warnings and verified build succeeds.

