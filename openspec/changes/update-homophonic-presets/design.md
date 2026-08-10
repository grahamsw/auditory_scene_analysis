## Context

The `HomophonicDemo.vue` component initializes its state with `DEFAULT_SETTINGS` and sets up two preset buffers (`set1` and `set2`). Currently, these all default to the same values, requiring users to manually configure them to hear the "Old-Plus-New" effect.

## Goals / Non-Goals

**Goals:**
- Set `DEFAULT_SETTINGS` to match the "Gradual" (Set 1) state.
- Initialize `set1` with "Gradual" parameters (250ms rise/fall).
- Initialize `set2` with "Abrupt" parameters (1ms rise/fall).
- Ensure the live state matches `set1` on initialization.
- Enable `isCurved` by default for both presets to match user preference.

**Non-Goals:**
- Persisting presets across browser sessions (beyond current page load).
- Modifying other ASA demos.

## Decisions

- **Initialization via `onMounted`**: I will add an `onMounted` hook to call `loadFromSet(1)`, ensuring the UI refs and the "Active Set" label are consistent from the start.
- **Set 2 Initialization**: Instead of spread-copying `DEFAULT_SETTINGS` for both, `set2` will be explicitly initialized with the 1ms timing overrides.
- **Rise/Fall Precision**: Use 0.001 (1ms) for Abrupt and 0.250 (250ms) for Gradual.

## Risks / Trade-offs

- **[Risk]** → Users might be confused if they preferred the previous linear defaults.
- **[Mitigation]** → The presets are clearly labeled and can still be adjusted manually. The new defaults are more "demo-ready".
