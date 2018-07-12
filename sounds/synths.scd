// RELIGION SYNTHS

// All synths are tuned to a "RA Music scale".
// 8Hz is the fundamental tone;
// 256Hz is a reference frequency.




// create the synth definitions
SynthDef(\outputStage, {
	|in=0, out=0, level=0, lagTime=5 | //gate_fade=1, lowLevel = 0.01, highLevel=1.0, inTime=5, outTime=0.5|
	var sig; //, fade;
	sig = In.ar( in );
	//fade = EnvGen.ar(Env.new([lowLevel, highLevel, lowLevel],[inTime, outTime],releaseNode:1), gate_fade);
	sig = sig * VarLag.kr( level, lagTime ); //*fade;
	Out.ar(out, sig);
}).add;




// define tibetan voices synths
SynthDef(\drone, {
	|freq=64, amp=0.125, drywet=0.5, detune=1, reso_f=1, out=0|
	var sig, w, reso;
	//reso = LFNoise1.kr( reso_f ).exprange(0.05, 0.5);
	// make it less resonant
	reso = LFNoise1.kr( reso_f ).exprange(0.1, 0.5);

	freq = freq + LFNoise1.kr( Rand(3, 7) ).range(-1*detune, detune);
	//freq.poll;
	w = LFNoise1.kr(0.3).range(0.1, 0.9);
	sig = VarSaw.ar(freq, width:w);

	sig = BLowPass.ar(sig, freq * LFNoise1.kr( Rand(0.1, 0.5) ).range(1, 8), reso);

	//sig = FreeVerb.ar(sig, drywet);
	//sig = sig + CombN.ar(sig, 1.8, drywet, 1.5);

	sig = sig * LFNoise1.kr( Rand(0.1, 0.5) ).range(0.1, 1.0) * amp * 0.5;

	// stereo pan
	//Out.ar(0, Pan2.ar(sig,LFNoise1.kr( Rand(0.05, 0.2) )) );
	// multichannel pan
	Out.ar(out, PanAz.ar( s.options.numOutputBusChannels, sig, LFNoise1.kr( Rand(0.05, 0.2) ), width:4.0) );
}).add;



SynthDef(\firefly, {
	|freq=256, amp=0.5, out=0|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01, 3), doneAction:2);
	sig = SinOsc.ar(freq) * env * amp;
	Out.ar(out, sig);
}).add;



// Religion synths

// create the synth definitions
SynthDef(\protestantesimo, {
	| amp=1.0, rate=1.0, out=0, bufnum |
	var sig; //, fade;
	sig = PlayBuf.ar();
	sig = sig * amp;
	Out.ar(out, sig);
}).add;