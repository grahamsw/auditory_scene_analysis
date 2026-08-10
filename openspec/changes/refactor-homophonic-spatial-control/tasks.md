## 1. Type and Ref Updates

- [x] 1.1 Rename `isSpatialSwapped` to `isSpatialEnabled` in `web/src/types.ts`.
- [x] 1.2 Update `DEFAULT_SETTINGS` and component refs in `HomophonicDemo.vue`.
- [x] 1.3 Update `saveToSet` and `loadFromSet` in `HomophonicDemo.vue` to use the new property name.

## 2. Audio Engine Refactor

- [x] 2.1 Update `start()` function in `HomophonicDemo.vue`:
    - Constant Panner: `pan.value = isSpatialEnabled.value ? -1 : 0`
    - Intermittent Panner: `pan.value = isSpatialEnabled.value ? 1 : 0`

## 3. UI and Labeling

- [x] 3.1 Update the "Spatial Mapping" fieldset in `HomophonicDemo.vue`:
    - Legend: "Spatial Effect"
    - Label: `{{ isSpatialEnabled ? 'Stereo (L/R)' : 'Mono (Center)' }}`
    - Button: "Toggle Stereo Effect"
- [x] 3.2 Update descriptive hint text below the button.

## 4. Verification

- [x] 4.1 Verify that when "Stereo" is On, the constant noise is in the Left ear only.
- [x] 4.2 Verify that when "Stereo" is Off, the sound is balanced in both ears.
- [x] 4.3 Verify that the setting is correctly saved and loaded from presets.
