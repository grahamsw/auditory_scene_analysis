// =====================================================================
// Auditory Scene Analysis - Asynchronous Onset Demonstration (Demo 21)
// Interactive SuperCollider Playground
// =====================================================================
(
s.waitForBoot({

    // 1. SynthDef definition
    // Synthesizes 6 harmonics at equal starting volumes.
    // Supports delaying the onset of a single chosen harmonic (0-indexed: 0=H1, 5=H6).
    // Releases all harmonics together cleanly when gate goes to 0 (common offset).
    SynthDef(\asynch_onset, {
        arg out=0, freq=200, amp=0.1, gate=1,
            atk=0.005, rel=0.15,
            delayMs=30, delayIdx=2;

        var amps = \amps.kr([0.1, 0.1, 0.1, 0.1, 0.1, 0.1]);
        var numHarmonics = 6;
        var sig, harmonics;
        var delaySec = delayMs / 1000;

        // Master envelope for release (common offset) and voice freeing
        var masterEnv = EnvGen.ar(Env.asr(0.001, 1, rel), gate, doneAction: 2);

        harmonics = Array.fill(numHarmonics, { |i|
            var hNum = i + 1;
            var hFreq = freq * hNum;
            var hAmp = amps[i];

            var isTarget = BinaryOpUGen('==', i, delayIdx);
            var startTrig = Impulse.kr(0);
            var delayedStart = DelayN.kr(startTrig, 0.5, delaySec);

            // Attack envelopes:
            var targetEnv = EnvGen.ar(Env.new([0, 1], [atk]), delayedStart);
            var normalEnv = EnvGen.ar(Env.new([0, 1], [atk]), startTrig);

            var hEnv = Select.kr(isTarget, [normalEnv, targetEnv]);

            SinOsc.ar(hFreq, 0, hAmp) * hEnv;
        });

        sig = harmonics.sum;
        Out.ar(out, Pan2.ar(sig * masterEnv * amp, 0));
    }).add;

    s.sync;

    // 2. Control Buses for Interactive Modulation
    ~delayMsBus = Bus.control(s, 1).set(0);      // Default to 0ms delay (fully fused)
    ~delayIdxBus = Bus.control(s, 1).set(2);     // Default to delaying H3

    s.sync;

    // 3. Playback Pattern Definition (Pbindef)
    // Plays a simple repeating melodic theme.
    // delayMs and delayIdx are mapped to the control buses.
    Pbindef(\asynch_pattern,
        \instrument, \asynch_onset,
        \dur, 0.4,
        \degree, Pseq([0, 2, 4, 7, 9, 7, 4, 2], inf),
        \scale, Scale.minor,
        \octave, 5,
        \amp, 0.12,
        \amps, `[0.0, 0.1, 0.1, 0.1, 0.1, 0.1], // Equal volume spectral picture
        \delayMs, ~delayMsBus.asMap,
        \delayIdx, ~delayIdxBus.asMap,
        \atk, 0.006,
        \rel, 0.25
    );

    "asynch_onset.scd loaded! Check instructions below.".postln;
});
)

/*
=====================================================================
INTERACTIVE PLAYGROUND EXAMPLES
=====================================================================

1. START PATTERN (Starts fully fused, 0ms delay)
Pbindef(\asynch_pattern).play;

2. SET TARGET HARMONIC AND INTRODUCE STATIC DELAYS
// Delay H3 (index 2) by 40ms. It will "pop out" as a separate initial whistle.
~delayIdxBus.set(2);
~delayMsBus.set(40);

// Delay H4 (index 3) by 80ms. Notice the delay is very prominent.
~delayIdxBus.set(0);
~delayMsBus.set(80);

// Return to perfect synchrony (fuses completely back into a single tone)
~delayMsBus.set(0);


3. MODULATE PARAMETERS WITH LIVE LFO PROXIES (Unsettling Effects)
// Modulate the delay amount dynamically with a slow triangle wave (0ms to 120ms)
~delayMsMod = { LFTri.kr(0.1).range(0, 120) }.play(outbus: ~delayMsBus);

// Modulate WHICH harmonic is delayed using a random noise step generator (selects H2 to H6)
~delayIdxMod = { LFNoise0.kr(0.4).range(1, 5).round }.play(outbus: ~delayIdxBus);

// Modulate BOTH at different speeds to create a shifting, uncanny timbre where overtones
// detach, float around as separate voices, and re-fuse mid-melody:
~delayMsMod.free;
~delayMsMod = { LFNoise1.kr(0.5).range(10, 150) }.play(outbus: ~delayMsBus);


4. CLEAN UP / STOP EVERYTHING
~delayMsMod.free;
~delayIdxMod.free;
Pbindef(\asynch_pattern).stop;
*/
