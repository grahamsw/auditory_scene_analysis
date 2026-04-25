// Auditory Scene analysis:
// =======================

// From Bergman in "Thinking in Sound", McAdams and Bigand

/* create two sounds, same pitch, tone. One left, one right (not nec)
when one of them increases and decreases slowly, in a triangle, it sounds as
if there is one sound, getting louder and softer, moving from left to right and back.
When the change is more abrupt, more like a square pulse, it sounds like the left
sound is constant, and there is a second intermittent sound.

When you vary the shape, and find the "sweet spot", it creates unease and
discomfort. You can't pick a model.

Something like a nekker cube - but potentially more disturbing
*/


(
SynthDef(\tone, {
    |out = 0, freq = 300, amp = 0.1, pan = 0, atk = 0.01, rel = 0.01, gate=1|
    var sig = SinOsc.ar(freq);
    var env = EnvGen.ar(Env.asr(atk, 1, rel),gate, doneAction:2);
    OffsetOut.ar(out, sig * env * amp);
}).add;

SynthDef(\morphEnv, {
    arg out = 0, freq = 1, shape = 0, amp=0.1;

    // Map shape [0..1] → k [0.1..20] exponentially.
    // Exponential mapping gives perceptually even steps across the full range.
    var k       = shape.linexp(0, 1, 0.1, 20);

    // Audio-rate triangle base oscillator, range −1 … +1
    var tri     = LFTri.ar(freq);

    // Soft-clip and normalise so the peaks always reach exactly ±1.
    // At low k the curve is essentially linear (triangle).
    // At high k it saturates fast on both sides, giving a near-square.
    var morphed = (k * tri).tanh / k.tanh;

    // Remap bipolar [−1, +1] → unipolar [0, 1] for amplitude use.
    Out.ar(out, ((morphed + 1) * 0.5) * amp);
}).add;

)



(
~left = Synth(\tone, [\out, 0, \amp, 0.1]);
~right = Synth(\tone, [\out, 1, \amp, 0.1]);
~right_bus = Bus.audio;
~right_amp = Synth(\morphEnv, [\out, ~right_bus]) ;
~right.map(\amp, ~right_bus);

)

~right_amp.set(\shape, 0.1, \amp, 0.2, \freq, 0.5)



