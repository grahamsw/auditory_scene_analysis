# Handover Document

## Current Status
The project has successfully pivoted to a web-based implementation. Four core ASA demonstrations are functional in the `/web` application. The original SuperCollider backend has been moved to `/supercollider` and remains as a reference for complex synthesis logic.

## Recently Completed
- Web application scaffolding (Vue 3, TS, Vite).
- Web Audio implementation of Demos 1, 18, 32, and 39.
- **Overview Landing Page** implementation (default view).
- Fixed `App.vue` compilation issues.
- Basic navigation and card-based UI.
- Mermaid architectural diagrams.

## Pending Demos (To be ported from SC or implemented fresh)
- **Demo 28 (Picket Fence):** Tone with gaps masked by noise.
- **Demo 25 (Old-Plus-New Capturing):** Tone A capturing a component from an A+B complex.
- **Demo 17 (Crossing Trajectories):** Two crossing glissandi.

## Next Steps
1.  **Refine UI:** Add diagrams (SVGs) for Spatial and Mistuning demos (currently mostly text/controls).
2.  **Implementation:** Port the "Picket Fence" effect (Demo 28) next, as it's highly visual and uses similar noise logic to Demo 32.
3.  **Spiderhats Integration:** Prepare the build for integration into the `spiderhats` repo (likely as an iframe or a sub-route).

## Known Issues / Notes
- **Timing:** `setTimeout` is used for demo rhythms. For extremely high-speed streaming, consider switching to the `Web Audio Clock` (look-ahead scheduler) to avoid jitter.
- **Dichotic Demo:** Ensure headphones are used for Demo 39 to experience the intended effect.
