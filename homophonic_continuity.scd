(
SynthDef(\homophonic, { |out=0, amp=0.25, peakAmp=1.0, riseTime=0.001, gate=1|
    var noise = WhiteNoise.ar(0.5);
    // Timing based on[cite: 1360]: 342ms steady, rise, 32ms peak, fall
    var env = EnvGen.ar(
        Env(
            [amp, amp, peakAmp, peakAmp, amp], 
            [0.342, riseTime, 0.032, riseTime, 0.348], 
            \lin
        ), 
        gate, 
        doneAction: 2
    );
    Out.ar(out, noise * env ! 2);
}).add;
)

// ABRUPT: Heard as TWO objects (Ghost sound joining) [cite: 1352, 1360]
Synth(\homophonic, [\riseTime, 0.001]); 

// GRADUAL: Heard as ONE object changing volume 
Synth(\homophonic, [\riseTime, 0.252]);