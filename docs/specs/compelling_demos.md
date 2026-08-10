# Specification: ASA Compelling Demos & Threshold Effects

## Overview
This specification details the design and implementation of three highly interactive demonstrations in the Auditory Scene Analysis web application. They are designed to illustrate the brain's unconscious auditory grouping assumptions using threshold effects and temporal memory (hysteresis).

---

## 1. Apparent Continuity (Picket Fence, Demo 28)

### Concept
A pure tone (1000Hz) is played with periodic gaps of silence. When the gaps are silent, the tone sounds chopped-up or stuttering. When white noise is played in the gaps, if the noise amplitude is above a certain threshold, the brain assumes the tone continued behind the noise and reconstructs it as a single, continuous tone.

### Sound Architecture
* **Tone Generator:** Pure sine wave oscillator (`OscillatorNode`).
* **Tone Gate:** A `GainNode` scheduled to cycle between `0.05` (on) and `0.0` (off) using linear ramps.
* **Noise Generator:** A looped `AudioBufferSourceNode` playing white noise.
* **Noise Filter:** A `BiquadFilterNode` configured as a bandpass filter centered at the tone's frequency to focus the masking power.
* **Noise Gate:** A `GainNode` scheduled inversely to the tone gate.
* **Controls:**
  * **Noise Level Slider:** Controls the noise volume (0.0 to 1.0).
  * **Tone Duration Slider:** Adjusts tone segment length (50ms - 500ms).
  * **Gap Duration Slider:** Adjusts silence segment length (20ms - 200ms).
  * **Mute Noise Toggle:** Silences the noise, revealing the actual silence gaps in the tone.
  * **Make Tone Continuous Toggle:** Bypasses gating on the tone to play it continuously as a perceptual reference.

### Visualizer
* An SVG timeline showing two cycles of the physical signal (alternating blocks of blue tone and red noise) vs. the perceived signal (a solid blue bar of tone underneath red noise blocks).
* A playhead line animated in sync with the audio.

---

## 2. Harmonic Mistuning & Hysteresis (Demo 18)

### Concept
A complex tone (6 harmonics) is played. When in tune, it fuses into a single musical object (a rich hum). When one harmonic is mistuned, it pops out as a separate whistle. When it returns to tune, the brain continues to track it as a separate whistle for a few seconds before it fuses back (hysteresis/sensory memory).

### Sound Architecture
* **Synthesis:** 6 sine wave oscillators representing $f, 2f, 3f, 4f, 5f, 6f$ at equal starting volume (`0.1` amplitude).
* **Target Harmonic:** The oscillator corresponding to the target partial (e.g. 3rd harmonic) has a variable frequency multiplier (normally 1.0).
* **Hysteresis Sweep Routine:**
  * **Cycle 1 (0s - 5s):** Slow cycle of continuous mistuning (ramps out to 1.12 at 2.5s and back to 1.0 at 5.0s).
  * **Cycle 2 (5s - 8s):** Medium cycle of continuous mistuning (ramps out to 1.12 at 6.5s and back to 1.0 at 8.0s).
  * **Cycle 3 (8s - 9.5s):** Fast cycle of continuous mistuning (ramps out to 1.12 at 8.75s and back to 1.0 at 9.5s).
  * **Hold Phase (9.5s - 12.5s):** Holds at the original pitch (1.0) and maintains active tracking state visually.
  * **End Phase (12.5s+):** Sweep finishes and fuses.
* **Controls:**
  * **Trigger Hysteresis Sweep Button:** Starts the automated out-and-back sweep.
  * **Manual Mistuning Slider:** Move manually to find the threshold (disabled during sweeps).
  * **Fundamental Level Slider:** Adjusts the level of the fundamental frequency (0% to 100%, default 100%) to reduce upward masking on higher overtones, without modifying the target harmonic itself.
  * **Target Harmonic Radio Buttons:** Select the target harmonic (H2 to H6) instantly.

### Visualizer
* An SVG "Object Map" showing a large grey circle ("Complex Tone") and a small circle ("Target Harmonic").
* When fused, the target is inside the core. When mistuned, it drifts out as a satellite.
* During Phase 3 & 4, a glowing dash-dot circle around the satellite lights up with a label saying **"Brain is still tracking... (Hysteresis)"**, which slowly fades out as it merges back.


---

## 3. Asynchronous Onset (Demo 21)

### Concept
A short complex tone repeats. When all harmonics start simultaneously, they fuse. When one harmonic is delayed by a tiny offset (e.g., 30ms), it breaks the simultaneous onset assumption, making the delayed harmonic pop out as a separate initial "chirp" or "ping" before merging.

### Sound Architecture
* **Synthesis:** 5 sine wave oscillators representing $f, 2f, 3f, 4f, 5f$ with $1/n$ amplitude roll-off.
* **Timing:** The note plays for 400ms and repeats every 1.5 seconds.
* **Onset Delay:** The target partial starts at $t = \text{delay}$, while all other partials start at $t = 0$. All partials end together at $t = 400\text{ms}$ to share a common offset.
* **Controls:**
  * **Onset Delay Slider:** 0ms (fully fused) to 150ms.
  * **Target Harmonic Radio Buttons:** Select the target harmonic (H1 to H5) instantly.

### Visualizer
* An SVG timeline showing 5 horizontal channels (one for each harmonic).
* The delayed harmonic bar is shifted to the right, showing the delay gap.
* A vertical playhead sweeps across the bars during note playback.
