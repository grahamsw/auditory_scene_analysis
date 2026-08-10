## 1. Refactor State and Timing

- [x] 1.1 Convert hardcoded timing constants (`BASE1_DUR`, `PEAK_DUR`, `BASE2_DUR`, `CYCLE_DUR`) into Vue `ref`s.
- [x] 1.2 Split `riseTime` into independent `riseTime` and `fallTime` refs.
- [x] 1.3 Add new refs for spectral controls: `filterFreq` (default 1000Hz) and `filterQ` (default 1.0).

## 2. Update Audio Engine

- [x] 2.1 Update `start()` to initialize a `BiquadFilterNode` in the audio chain.
- [x] 2.2 Update `scheduleEnvelope` to use the new independent timing refs.
- [x] 2.3 Implement safety clamping in the scheduler to ensure envelope segments fit within `cycleDuration`.
- [x] 2.4 Add watchers or direct parameter updates to link `filterFreq` and `filterQ` refs to the filter node.

## 3. Enhance Visualization

- [x] 3.1 Update the `envelopePath` computed property to handle asymmetric rise/fall times.
- [x] 3.2 Adjust the SVG X-scaling to be relative to the dynamic `cycleDuration`.
- [x] 3.3 Ensure the playhead animation correctly scales with the new cycle timing.

## 4. UI Layout and Controls

- [x] 4.1 Group existing and new parameters into `fieldset` sections: "Timing", "Envelope", and "Filter".
- [x] 4.2 Add sliders for all new timing parameters (Base 1, Peak, Base 2, Cycle).
- [x] 4.3 Add sliders for Fall Time and Filter parameters (Freq, Q).
- [x] 4.4 Update the perceptual hint logic to account for both rise and fall times.

## 5. Verification

- [x] 5.1 Verify that setting an abrupt rise and gradual fall correctly produces the expected perceptual effect.
- [x] 5.2 Verify that the SVG visualization accurately reflects asymmetric envelopes.
- [x] 5.3 Verify that the filter controls correctly narrow or shift the noise spectrum.
