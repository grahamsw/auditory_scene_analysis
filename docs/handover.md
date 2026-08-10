# Handover Document

## Current Status
The project has successfully pivoted to a web-based implementation. Four core ASA demonstrations are functional in the `/web` application. The original SuperCollider backend has been moved to `/supercollider` and remains as a reference for complex synthesis logic.

## Recently Completed
- Web application scaffolding (Vue 3, TS, Vite).
- Web Audio implementation of Demos 1, 18 (with hysteresis), 21, 28, 32, and 39.
- **Overview Landing Page** overhauled with detailed scientific explanations and interactive threshold cards.
- **Demo 28 (Picket Fence):** Apparent continuity with bandpass white noise, gap duration controls, and a "Mute Noise" toggle.
- **Demo 21 (Asynchronous Onset):** Timeline visualizer and repeating note generator demonstrating the temporal synchrony requirement.
- **Demo 18 (Mistuning Hysteresis):** Automated frequency sweep and Object Separation Map illustrating sensory memory tracking.
- Navigation and layout integration in `App.vue`.

## Pending Demos (To be ported from SC or implemented fresh)
- **Demo 25 (Old-Plus-New Capturing):** Tone A capturing a component from an A+B complex.
- **Demo 17 (Crossing Trajectories):** Two crossing glissandi.

## Next Steps
1. **Web Audio Clock Scheduler:** Port the remaining simple repetition loops (e.g. streaming, onset) to use the high-precision Web Audio look-ahead scheduler (as used in Homophonic and Picket Fence demos) to eliminate any potential JavaScript timing jitter.
2. **Spiderhats Integration:** Prepare the build for integration into the `spiderhats` repo (likely as an iframe or sub-route).

## Known Issues / Notes
- **Timing:** `setTimeout` is used for demo rhythms. For extremely high-speed streaming, consider switching to the `Web Audio Clock` (look-ahead scheduler) to avoid jitter.
- **Dichotic Demo:** Ensure headphones are used for Demo 39 to experience the intended effect.
