s.options.memSize = s.options.memSize * 512;
s.options.memSize;


// TODO: fix the exagerate resonance that happens sometimes,
// expecially at lower frequencies;
(
SynthDef(\drone, {
	|freq = 64, amp=0.125, drywet=0.5, detune=1, reso_f=1|
	var sig, w, reso;
	reso = LFNoise1.kr( reso_f ).exprange(0.05, 0.5);

	freq = freq + LFNoise1.kr( Rand(3, 7) ).range(-1*detune, detune);
	//freq.poll;
	w = LFNoise1.kr(0.3).range(0.1, 0.9);
	sig = VarSaw.ar(freq, width:w);

	sig = BLowPass.ar(sig, freq * LFNoise1.kr( Rand(0.1, 0.5) ).range(1, 8), reso);

	//sig = FreeVerb.ar(sig, drywet);
	//sig = sig + CombN.ar(sig, 1.8, drywet, 1.5);

	sig = sig * amp * LFNoise1.kr( Rand(0.1, 0.5) ).range(0.1, 1.0);

	Out.ar(0, Pan2.ar(sig,LFNoise1.kr( Rand(0.05, 0.2) )) );
}).add;
)

(
Synth(\drone, [\freq, 32, \mix, 0.1,  \detune, 0.5, \amp, 0.7]);
Synth(\drone, [\freq, 64, \mix, 0.3,  \detune, 1, \amp, 0.25]);
Synth(\drone, [\freq, 96, \mix, 0.5,  \detune, 1.1, \amp, 0.25*0.9]);
Synth(\drone, [\freq, 128,\mix, 0.7,  \detune, 1.2, \amp, 0.25*0.7]);
Synth(\drone, [\freq, 192,\mix, 0.9,  \detune, 1.4, \amp, 0.25*0.5]);
Synth(\drone, [\freq, 256,\mix, 0.99, \detune, 1.6,  \amp, 0.25*0.2]);
Synth(\drone, [\freq, 320,\mix, 0.99, \detune, 2,  \amp, 0.25*0.3]);
)


s.freqscope;
s.meter;


// TODO: add some tabla + some whistle (high E to Eb)


