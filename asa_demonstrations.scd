/*
 * Auditory Scene Analysis Demonstrations
 * Based on Bregman & Ahad (1990)
 */

(
// 1. Homophonic Continuity (Demo 32)
// Toggle between a gradual rise (one object) and an abrupt one (two objects).
SynthDef(\asa_homophonic, {
    arg out=0, amp=0.2, baseLevel=0.25, riseTime=0.25, freq=440, gate=1;
    var sig, env, trig;
    
    // Using WhiteNoise as in the original demo, or a Sine tone
    sig = WhiteNoise.ar(amp); 
    
    // A trigger that fires every 2 seconds
    trig = Impulse.kr(0.5);
    
    // Envelope that stays at baseLevel, then rises to 1.0
    // We use a Select to switch between the rise styles
    env = EnvGen.kr(
        Env([baseLevel, baseLevel, 1.0, 1.0, baseLevel], [0.5, riseTime, 0.5, 0.1], \lin),
        trig
    );
    
    Out.ar(out, (sig * env).dup);
}).add;

// 2. Stream Segregation / Galloping Rhythm (Demo 1 & 3)
// High (H) and Low (L) tones in an L-H-L- pattern.
// At slow speeds, it's one melody. At fast speeds, it splits into two streams.
SynthDef(\asa_streaming, {
    arg out=0, freq=440, amp=0.1, gate=1, atk=0.01, rel=0.05;
    var sig, env;
    sig = SinOsc.ar(freq);
    env = EnvGen.ar(Env.perc(atk, rel), gate, doneAction: 2);
    Out.ar(out, (sig * env * amp).dup);
}).add;

// 3. Harmonic Mistuning (Demo 18)
// A harmonic complex where one partial can be mistuned.
SynthDef(\asa_mistuning, {
    arg out=0, fund=200, amp=0.1, mistune=1.0, targetPartial=3;
    var sig;
    sig = 8.collect({ |i|
        var pNum = i + 1;
        var f = fund * pNum;
        if(pNum == targetPartial) { f = f * mistune };
        SinOsc.ar(f, 0, 1/(i+1));
    }).sum;
    Out.ar(out, (sig * amp).dup);
}).add;

// 4. Perceptual Continuity / Picket Fence (Demo 28)
// A tone with a gap. If noise fills the gap, the tone sounds continuous.
SynthDef(\asa_continuity, {
    arg out=0, toneFreq=1000, toneAmp=0.1, noiseAmp=0.4, useNoise=0;
    var tone, noise, env, gate;
    
    // Tone pulses: 0.9s on, 0.1s off
    gate = LFPulse.kr(1, 0, 0.9);
    tone = SinOsc.ar(toneFreq, 0, toneAmp) * gate;
    
    // Noise bursts in the gap
    // If useNoise is 0, you hear the gap. If 1, the noise masks the gap.
    noise = WhiteNoise.ar(noiseAmp) * (1 - gate) * useNoise;
    
    Out.ar(out, (tone + noise).dup);
}).add;

// 5. Old-plus-New Capturing (Demo 25)
// Playing Tone A first "captures" it out of the following A+B chord.
SynthDef(\asa_capture, {
    arg out=0, freqA=440, freqB=660, amp=0.1, gate=1, capture=1;
    var sigA, sigB, envA, envB;
    
    // Tone A starts at 0s
    sigA = SinOsc.ar(freqA);
    envA = EnvGen.ar(Env([0, 1, 1, 0], [0.1, 1.8, 0.1]), gate, doneAction: 2);
    
    // Tone B starts at 1s
    sigB = SinOsc.ar(freqB);
    envB = EnvGen.ar(Env([0, 0, 1, 0], [1.0, 0.1, 0.8, 0.1]), gate);
    
    // If capture is 0, we don't play the lead-in for A
    sigA = sigA * envA * (if(capture > 0, {1}, {LFPulse.kr(0, 0, 0, 0, 1)} /* simplified logic */));
    
    Out.ar(out, ((sigA + (sigB * envB)) * amp).dup);
}).add;

// 6. Crossing Trajectories (Demo 17)
// Two glissandi cross. Do they "bounce" or "cross"?
SynthDef(\asa_crossing, {
    arg out=0, startA=400, endA=1600, startB=1600, endB=400, dur=2, amp=0.1;
    var sigA, sigB, env, freqA, freqB;
    
    env = EnvGen.ar(Env([0, 1, 1, 0], [0.1, dur-0.2, 0.1]), doneAction: 2);
    
    // Logarithmic frequency sweeps
    freqA = XLine.kr(startA, endA, dur);
    freqB = XLine.kr(startB, endB, dur);
    
    sigA = SinOsc.ar(freqA);
    sigB = SinOsc.ar(freqB);
    
    Out.ar(out, ((sigA + sigB) * env * amp).dup);
}).add;
)

/* --- Testing --- */

// --- Demo 32: Homophonic Continuity ---
x = Synth(\asa_homophonic, [\riseTime, 0.25]); // Gradual: One noise getting louder
x.set(\riseTime, 0.001); // Abrupt: A second noise joins the first
x.free;

// --- Demo 1: Streaming ---
(
t = Routine({
    var freqs = [400, 800, 400]; // L-H-L
    var tempo = 0.2; // 0.2 = slow (gallop), 0.05 = fast (two streams)
    loop {
        freqs.do { |f|
            Synth(\asa_streaming, [\freq, f, \amp, 0.1, \rel, tempo * 0.8]);
            tempo.wait;
        };
        (tempo * 1.5).wait; // gap between triplets
    }
}).play;
)
t.stop;

// --- Demo 18: Mistuning ---
m = Synth(\asa_mistuning, [\fund, 200, \mistune, 1.0]); // Purely harmonic timbre
m.set(\mistune, 1.04); // The 3rd partial "pops out" as a separate tone
m.free;

// --- Demo 28: Perceptual Continuity ---
c = Synth(\asa_continuity, [\useNoise, 0]); // You clearly hear the gaps
c.set(\useNoise, 1); // Tone sounds continuous behind the noise bursts
c.free;

// --- Demo 25: Old-plus-New Capturing ---
// Play a chord A+B. Hard to separate them.
(
Routine({
    "Fused Chord...".postln;
    Synth(\asa_streaming, [\freq, 440, \rel, 1]);
    Synth(\asa_streaming, [\freq, 660, \rel, 1]);
    2.wait;
    "Captured Tone A...".postln;
    Synth(\asa_capture, [\freqA, 440, \freqB, 660]); // A starts early, B joins
}).play;
)

// --- Demo 17: Crossing Trajectories ---
// Most listeners hear two "V" shapes (bouncing) rather than an X (crossing)
Synth(\asa_crossing, [\dur, 2]);
