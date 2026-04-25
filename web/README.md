# ASA Web Interface

A Vue 3 + TypeScript application for exploring Auditory Scene Analysis phenomena using the Web Audio API.

## Tech Stack
- **Framework:** Vue 3 (Composition API)
- **Language:** TypeScript
- **Audio:** Web Audio API (Native oscillators, noise buffers, panners)
- **Styling:** CSS (Modern, Dark/Light mode responsive)
- **Build Tool:** Vite

## Architecture
- `src/App.vue`: Main layout with sidebar navigation and dynamic component rendering.
- `src/audio.ts`: Singleton manager for the `AudioContext`.
- `src/components/demos/`: Individual components for each ASA effect. Each component manages its own audio nodes and cleanup logic.

## Implemented Demos
1. **Streaming (Demo 1):** Sequential integration based on speed and pitch.
2. **Mistuning (Demo 18):** Spectral segregation of harmonics.
3. **Homophonic Continuity (Demo 32):** Old-plus-new heuristic with noise amplitude.
4. **Spatial Segregation (Demo 39):** Loss of timing information via dichotic presentation.

## Development
```bash
npm install
npm run dev
```
