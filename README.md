# Auditory Scene Analysis in SuperCollider

This repository contains SuperCollider implementations of various auditory effects and demonstrations described in Albert S. Bregman's foundational work, **Auditory Scene Analysis (ASA)**.

The project is inspired by the *Demonstrations to accompany Bregman's Auditory Scene Analysis: The perceptual organization of sound* (MIT Press, 1990).

## Project Overview

Auditory Scene Analysis describes the process by which the human auditory system organizes sound into meaningful elements or "streams." This project aims to recreate these psychoacoustic phenomena using real-time synthesis in SuperCollider.

### Key Demonstrations Implemented:

- **Homophonic Continuity (Demo 32):** Explores the "old-plus-new" heuristic. A gradual volume change sounds like one object getting louder, while an abrupt change sounds like a second object joining the first.
- **Stream Segregation / Galloping Rhythm (Demo 1):** Demonstrates how frequency separation and speed cause a single melodic line to "split" into two independent rhythmic streams.
- **Harmonic Mistuning (Demo 18):** Shows how mistuning a single partial in a harmonic complex causes it to perceptually "pop out" as a separate tone.
- **Perceptual Continuity / Picket Fence Effect (Demo 28):** Illustrates how the brain "repairs" gaps in a tone when they are masked by noise.
- **Old-Plus-New Capturing (Demo 25):** Shows how a preceding sound can "capture" a component out of a subsequent fused complex.
- **Crossing Trajectories (Demo 17):** Demonstrates the brain's preference for maintaining frequency streams even when gliding tones cross.

## File Structure

- `asa_demonstrations.scd`: The main SuperCollider file containing SynthDefs and test code for the effects.
- `auditorysceneanalysis.scd`: Early experiments with morphing envelopes and tone segregation.
- `vol_envelope.scd`: A reusable envelope effect factory for shaping audio volumes.
- `docs/`:
    - `Auditory Scene Analysis Demonstrations.pdf`: The original reference booklet.
    - `ASA_Demonstrations_Summary.md`: A complete list of all 41 demonstrations from the booklet.
    - `ASA-Demo-audio/`: Original audio tracks for comparison.

## Getting Started

1. Open `asa_demonstrations.scd` in the SuperCollider IDE.
2. Boot the server (`Ctrl+B`).
3. Evaluate the `SynthDef` block at the top.
4. Run the individual test blocks provided at the bottom of the file to hear the effects.

## References

- Bregman, A. S. (1990). *Auditory Scene Analysis: The Perceptual Organization of Sound*. MIT Press.
- Bregman, A. S., & Ahad, P. A. (1990). *Demonstrations to accompany Auditory Scene Analysis* [CD]. MIT Press.
