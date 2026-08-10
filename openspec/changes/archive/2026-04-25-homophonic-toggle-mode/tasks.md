## 1. Data Types and Interface

- [x] 1.1 Define `HomophonicSettings` interface in `web/src/types.ts`.

## 2. State Management Implementation

- [x] 2.1 Add `set1` and `set2` refs to `HomophonicDemo.vue` with default values.
- [x] 2.2 Implement `saveToSet(index: number)` function to capture current Live refs into a set.
- [x] 2.3 Implement `loadFromSet(index: number)` function to apply set values to Live refs.
- [x] 2.4 Add an `activeSetLabel` computed property to show which set was last loaded.

## 3. UI Controls

- [x] 3.1 Add a "Presets" fieldset to the `<template>` in `HomophonicDemo.vue`.
- [x] 3.2 Add buttons for "Capture Set 1", "Use Set 1", "Capture Set 2", and "Use Set 2".
- [x] 3.3 Style the preset buttons to be distinct from main playback controls.

## 4. Verification

- [x] 4.1 Verify that clicking "Capture" saves the current slider positions.
- [x] 4.2 Verify that clicking "Use" updates both the audio engine and the SVG visualization.
- [x] 4.3 Verify that switching sets while playing results in a smooth transition in the next cycle.

