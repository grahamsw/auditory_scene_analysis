# Auditory Scene Analysis (ASA)

SuperCollider and Web Audio implementations of auditory effects based on Albert S. Bregman's *Auditory Scene Analysis*.

## Project Structure

- `/web`: Vue 3 + TypeScript + Web Audio API implementation of ASA demonstrations.
- `/supercollider`: Original SuperCollider (`.scd`) implementations and experiments.
- `/docs`: Reference materials, summaries of Bregman's work, and project specifications.

## Getting Started

### Web Application
The web application allows you to run ASA demonstrations directly in your browser.
1. `cd web`
2. `npm install`
3. `npm run dev`

### SuperCollider
1. Open `supercollider/asa_demonstrations.scd` in the SuperCollider IDE.
2. Boot the server (`Ctrl+B`).
3. Evaluate the SynthDef blocks and run the test routines at the bottom of the file.

## Documentation
- `docs/ASA_Demonstrations_Summary.md`: Summary of all 41 original demonstrations.
- `docs/handover.md`: Current project status and next steps for developers.
- `docs/work_summary.md`: History of implemented features and fixes.
- `docs/specs/`: Technical specifications for new features and porting logic.
