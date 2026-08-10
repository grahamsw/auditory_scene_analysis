/*
 * dynEnv.scd
 * ==========
 * A repeating envelope effect that shapes the volume of any audio passing
 * through it.  Works like a reverb or master-volume insert: declare it with
 * an in bus and an out bus, route source synths to the in bus, and the
 * envelope is applied automatically.
 *
 *
 * USAGE (three steps)
 * -------------------
 *
 *   // 1. Create a private bus and route your source synth(s) through it.
 *   ~bus = Bus.audio(s, 2);
 *   ~src = Synth(\default, [\out, ~bus, \freq, 220]);
 *
 *   // 2. Instantiate the effect — it sits at the tail, after all sources.
 *   ~fx = ~makeEnvEffect.(~bus, 0, freq: 2);
 *
 *   // 3. Change the envelope shape at any time, click-free.
 *   ~fx.setEnv([0, 1, 0], [1, 1], \sin);
 *   ~fx.setEnv([0, 1, 1, 0], [1, 6, 1], \sin);
 *   ~fx.setFreq(4);
 *   ~fx.free();
 *
 *
 * setEnv arguments
 * ----------------
 *   levels   — amplitude breakpoints (first == last for a clean loop)
 *   times    — segment durations in any unit; normalised automatically
 *   curves   — \lin \sin \wel \sqr \cub \exp or a Float (per-segment array ok)
 *   fadeTime — crossfade duration in seconds when changing shape (default 0.05)
 *
 * setFreq argument
 * ----------------
 *   hz — envelope cycles per second
 *
 * The effect starts transparent (flat envelope = unity gain) until you
 * call setEnv for the first time.
 */
Synth(\default)

// ============================================================
// STEP 1 — Register the SynthDef (run once after booting)
// ============================================================
(
SynthDef(\envEffect, {
    arg in = 0, out = 0, bufA, bufB, freq = 1, xfade = -1, fadeTime = 0.05;
    var numFrames, phase, envA, envB, env, sig;

    numFrames = BufFrames.ir(bufA);
    phase     = Phasor.ar(0, freq * numFrames / SampleRate.ir, 0, numFrames);

    envA = BufRd.ar(1, bufA, phase, loop: 1, interpolation: 2);
    envB = BufRd.ar(1, bufB, phase, loop: 1, interpolation: 2);
    env  = XFade2.ar(envA, envB, Lag.kr(xfade, fadeTime));

    // Read two channels from the in bus, scale by envelope, pass through.
    sig  = In.ar(in, 2) * env;
    Out.ar(out, sig);
}).add;
)


// ============================================================
// STEP 2 — Factory function (run once, keep the result)
// ============================================================
(
/*
 * ~makeEnvEffect.(inBus, outBus, freq: 1)
 *
 * Returns a controller Event with methods:
 *   .setEnv(levels, times, curves, fadeTime)
 *   .setFreq(hz)
 *   .free()
 *
 * Note: SC passes the Event itself as the first argument when you call a
 * method on it, so each function below declares |self, ...| and ignores self.
 */
~makeEnvEffect = { |inBus, outBus, freq = 1|
    var resolution, bufA, bufB, synth, activeBuf;

    resolution = 2048;
    activeBuf  = \A;

    bufA = Buffer.alloc(s, resolution);
    bufB = Buffer.alloc(s, resolution);

    // Unity gain (flat at 1.0) = fully transparent until setEnv is called.
    bufA.setn(0, Array.fill(resolution, 1.0));
    bufB.setn(0, Array.fill(resolution, 1.0));

    // addToTail ensures the effect runs after any synth writing to inBus.
    synth = Synth(\envEffect,
        [\in, inBus, \out, outBus, \bufA, bufA, \bufB, bufB, \freq, freq],
        s, \addToTail);

    (
        setEnv: { |self, levels, times, curves = \lin, fadeTime = 0.05|
            var totalT, env, dur, data, xfadeTarget;

            totalT = times.sum;
            if (totalT <= 0) { Error("times must sum to a positive value").throw };
            if (levels.size != (times.size + 1)) {
                Error("levels must have exactly one more element than times").throw };

            env  = Env(levels, times / totalT, curves);
            dur  = env.duration;
            data = Array.fill(resolution, { |i| env.at(i / resolution * dur) });

            // Write to the inactive buffer, then crossfade to it.
            if (activeBuf == \A, {
                bufB.setn(0, data);
                xfadeTarget = 1;
                activeBuf   = \B;
            }, {
                bufA.setn(0, data);
                xfadeTarget = -1;
                activeBuf   = \A;
            });

            synth.set(\xfade, xfadeTarget, \fadeTime, fadeTime);
        },

        setFreq: { |self, hz| synth.set(\freq, hz) },

        free: { |self| synth.free; bufA.free; bufB.free; }
    )
};
)


// ============================================================
// EXAMPLE
// ============================================================

~busLeft = Bus.audio(s, 1);
~busRight = Bus.audio(s, 1);
~left = Synth(\tone, [\out, 0, \freq, 400], s, \addToHead);

~right = Synth(\tone, [\out, ~busRight, \freq, 400], s, \addToHead);
~fx = ~makeEnvEffect.(~busRight, 1, freq:1);

~left.set(\amp, 0.1)
~right.set(\amp, 0.4)

// Create a stereo bus and a source synth writing to it.
~bus = Bus.audio(s, 2);
~src = Synth(\default, [\out, ~bus, \freq, 400], s, \addToHead);

// Wrap it with the envelope effect.
~fx = ~makeEnvEffect.(~bus, 0, freq: 2);

// Shape examples — evaluate any line while the sound runs.
~fx.setEnv([0, 1, 0],          [1, 1],    \lin);
~fx.setEnv([0, 1, 0],          [1, 1],    \sin);
~fx.setEnv([0, 1, 1, 0],       [1, 6, 1], \sin);
~fx.setEnv([0, 1, 0.6, 0, 0],  [1, 3, 2, 1], [\sin, \lin, \lin, \lin]);
~fx.setEnv([0, 1, 1, 0 ], [1, 0.1, 1])
~fx.setFreq(0.5);
~fx.setFreq(4);

// Cleanup.
~src.free; ~fx.free(); ~bus.free;