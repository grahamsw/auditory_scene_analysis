## 1. Update Default Settings

- [x] 1.1 Update `DEFAULT_SETTINGS` in `HomophonicDemo.vue`:
    - `riseTime: 0.250`
    - `fallTime: 0.250`
    - `peakDur: 0.1`
    - `isCurved: true`

## 2. Initialize Preset Buffers

- [x] 2.1 Update `set1` initialization in `HomophonicDemo.vue` to use the updated `DEFAULT_SETTINGS`.
- [x] 2.2 Update `set2` initialization in `HomophonicDemo.vue` with overrides:
    - `riseTime: 0.001`
    - `fallTime: 0.001`
    - `peakDur: 0.1`
    - `isCurved: true`

## 3. Component Lifecycle & Initial State

- [x] 3.1 Import `onMounted` from `vue` in `HomophonicDemo.vue`.
- [x] 3.2 Add `onMounted(() => { loadFromSet(1) })` to the script block.
- [x] 3.3 Verify that `peakDur` live ref is also updated to `0.1` by default (or via `loadFromSet`).

## 4. Verification

- [x] 4.1 Verify that when the demo opens, "Set 1 Active" is displayed.
- [x] 4.2 Verify that clicking "Use Set 2" changes rise/fall to 1ms.
- [x] 4.3 Verify that clicking "Use Set 1" returns them to 250ms.
