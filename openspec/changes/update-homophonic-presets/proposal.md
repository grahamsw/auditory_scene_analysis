## Why

The Homophonic Continuity demo (Demo 32) currently uses defaults that may not immediately demonstrate the perceptual "Old-Plus-New" heuristic clearly without manual adjustment. Setting the default presets to specific values (Gradual for Set 1, Abrupt for Set 2) provides an instant comparison that highlights the effect as soon as the demo is opened.

## What Changes

- Update `DEFAULT_SETTINGS` in `HomophonicDemo.vue` to match the "Gradual" (One object) perceptual state.
- Update `preset1` and `preset2` initialization logic to provide two distinct, optimized presets for immediate comparison.
- Ensure the demo loads with "Set 1" (Gradual) active by default.
- Specific parameter updates:
    - **Set 1 (Default)**: Curve: true, Rise: 250ms, Fall: 250ms, Peak: 100ms.
    - **Set 2**: Curve: true, Rise: 1ms, Fall: 1ms, Peak: 100ms.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `homophonic-toggle-logic`: Update requirements for initial state and default preset values to ensure a consistent out-of-the-box comparison experience.

## Impact

- `web/src/components/demos/HomophonicDemo.vue`: Modification of default reactive state and preset initialization logic.
- `web/src/types.ts`: (If needed) review `HomophonicSettings` defaults, though component-level overrides are preferred.
