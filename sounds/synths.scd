// RELIGIONE Synth Defs


// GUI
(
SynthDef(\drop, {
	arg out=0, drywet=0, freq=440, cutoff=880, bwr=0.01, sus=0.5, tatk=0.001, tdecay=0.04, tsus=0.5, trel=0.5, amp=0.25;
	var sig, env;
	env = EnvGen.kr(Env([0, 1, sus, sus*0.8, 0], [tatk, tdecay, tsus, trel]), doneAction:2 );
	sig = SinOsc.ar(freq!2) * env * amp;
	//sig = BLowPass.ar(sig, XLine.kr(freq, freq*3, tdecay), 100);
	//Out.ar(dryOut, sig * drywet);
	//Out.ar(wetOut, sig * (1.0-drywet) );
	Out.ar(out, sig );
}).add;

SynthDef(\gui_fx, {
	|in=0, out=0|
	var sig = In.ar(in, 1);
	//sig = CombN.ar(sig, 7, 0.25, 3);
	//sig = FreeVerb.ar(sig, 0.7, 0.5, 0.7);
	Out.ar(out, sig!2);
}).add;
)

// violins
(
SynthDef(\grain_cello, {
	|out=0, gate=1, amp=0.9, sndbuf, atk=5, rls=5, rt=1|
    var sig, pan=0, env;

	//var density = LFNoise0.kr(25).range(10, 15);
	var density = LFNoise0.kr(25).range(1, 5);
	var trigger = Impulse.kr( density );
	var pos = 0.5 + TRand.kr(trigger, -0.125, 0.125);
	var rate = rt;// + TRand.kr(trigger, -0.005, 0.005);
	var length = 1 + TRand.kr(trigger, 0.25, 0.35);

	env = EnvGen.kr(Env.asr(atk, 1, rls, -4), gate, doneAction:2);

    sig = GrainBuf.ar(1,
		trigger,
		length,
		sndbuf,
		rate,
		pos,
		2,
		pan: pan);

	sig = sig * amp * env;
	//sig = BRF.ar(sig, 1500, 1);
	Out.ar(out, sig!2);
}).add;


SynthDef(\rev, {
	|in=0, out=0|
	var sig;
	sig = In.ar(in);
	//sig = AllpassN.ar(sig, 7, 0.5, 6);
	sig = FreeVerb.ar(sig, 0.7, 0.9, 0.7);
	Out.ar(out, sig!2);
}).add;

~aux_cello_verb = Bus.audio(s, 1);
~rev_cello = Synth(\rev, [\in, ~aux_cello_verb]);
)



// FM

(
SynthDef(\sineperc, {
	|amp=0.25, pos=0, midinote=67, dlytime=0.25, dcytime=4, timbre=1, atk=0.001, rls=0.01, out=0|
	var sig, env, freq;
	env = EnvGen.ar(Env.perc(atk, rls));
	//sig = SinOsc.ar( midinote.midicps )*env;
	freq = midinote.midicps;
	sig = PMOsc.ar(freq, freq*10, timbre) * env;
	sig = sig + AllpassN.ar(sig, 5, dlytime, dcytime);
	sig = LPF.ar(sig, 5000);
	sig = sig * amp;
	DetectSilence.ar(sig, 0.0001, 0.4, doneAction:2);
	//Out.ar(out, PanAz.ar(sig, pos));
	//[timbre, freq.cpsmidi, dlytime, amp].poll(label: [\timbre, \midi, \dlytime, \amp]);
	Out.ar(out, Pan2.ar(sig, pos));
}).add;
)


// filter noise
(
SynthDef(\filtered_noise, {
	| amp = 0.25, gate=1|
	var sig,freq, env;
	env = EnvGen.kr(Env.asr(5,1,5),gate,doneAction:2);
	sig = WhiteNoise.ar();
	sig = sig * env;
	freq = LFNoise2.kr(0.1).range(3500, 6000);
	sig = BPF.ar(sig, freq, 0.001);
	sig = sig * amp;
	Out.ar(0, sig!2);
}).add;
)

// distant bird
(
SynthDef(\distant_bird, {
	| amp=0.75, f=8000 ,dcy=2, pos=0|
	var sig,freq,env;
	env = EnvGen.ar(Env.perc(0.1, dcy), doneAction:2);
	sig = WhiteNoise.ar() * env;
	freq = SinOsc.kr(Line.ar(0,1, dcy).exprange(1,7)).range(f, f*2) ;
	sig = BPF.ar(sig, freq, 0.001);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pos));
}).add;
)