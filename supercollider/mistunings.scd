(
SynthDef(\mistuningDemo, { |out=0, freq=200, amp=0.1, mistune=1.0, harmonicIdx=2, fundamentalLevel=1.0, transitionTime=2|
    var numHarmonics = 6;
    var sig, harmonics;
    
    // Smooth the mistuning transition to avoid clicks and observe the "pop"
    var mistuneLag = Lag.kr(mistune, transitionTime);
    
    harmonics = Array.fill(numHarmonics, { |i|
        var hNum = i + 1;
        var hFreq, hAmp;
        
        // If this is the chosen harmonic, apply the mistuning multiplier
        hFreq = Select.kr(BinaryOpUGen('==', i, harmonicIdx), [
            freq * hNum, 
            freq * hNum * mistuneLag
        ]);
        
        // All harmonics at equal volume, fundamental scaled by fundamentalLevel
        hAmp = Select.kr(BinaryOpUGen('==', i, 0), [
            amp,
            amp * fundamentalLevel
        ]);
        
        SinOsc.ar(hFreq, 0, hAmp);
    });

    sig = harmonics.sum;
    Out.ar(out, Pan2.ar(sig, 0));
}).add;
)

// --- INTERACTIVE TEST ---

// 1. Start the sound (all in tune)
~synth = Synth(\mistuningDemo, [\freq, 200, \harmonicIdx, 2]); // Target the 3rd harmonic (index 2)

// 2. Mistune it by 10% over 3 seconds. 
// Listen for the "pop out" where it starts sounding like a whistle on top of a hum.
~synth.set(\mistune, 1.1, \transitionTime, 3);

// 3. Bring it back to 1.0 (perfectly in tune). 
// Does your brain keep tracking it as a separate whistle even when it's technically fused?
~synth.set(\mistune, 1.0, \transitionTime, 5);

// 4. Try it with a different harmonic (e.g., the 5th harmonic at index 4)
~synth.set(\harmonicIdx, 4);