(
{
    var f0 = 1000;
    var toneToggle = LFPulse.ar(1, 0, 0.9); // 900ms tone, 100ms gap [cite: 1230]
    var noiseToggle = 1 - toneToggle;
    
    var tone = SinOsc.ar(f0, 0, 0.2) * toneToggle;
    // MouseX controls noise amplitude relative to tone [cite: 1226]
    var noise = WhiteNoise.ar(MouseX.kr(0, 0.8)) * noiseToggle;
    
    (tone + noise) ! 2;
}.play;
)