## Context

The `getAudioContext` function in `web/src/audio.ts` uses `(window as any).webkitAudioContext` to satisfy the TypeScript compiler because the `Window` interface does not natively include the Safari-specific `webkitAudioContext` property.

## Goals / Non-Goals

**Goals:**
- Eliminate the `as any` typecast in `web/src/audio.ts`.
- Ensure TypeScript compiles successfully without the cast.

**Non-Goals:**
- Refactor the audio initialization logic itself.

## Decisions

### Decision 1: Declare global Window augmentation in types.ts

We will augment the global `Window` interface to include `webkitAudioContext: typeof AudioContext`. We will place this declaration in `web/src/types.ts` so that it's globally available to the TypeScript project, keeping `audio.ts` clean.