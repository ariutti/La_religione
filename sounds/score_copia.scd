// RELIGION SCORE

~score_firefly = Pfinval(2.rrand(4),
	Pbind(
		\instrument, \firefly,
		\group, ~grp_syn,
		\multiplier, Prand( [4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.5,1,inf),
		\out, Pindex(~array_bus, Prand((0..7), inf) )
)).asEventStreamPlayer;

~task_firefly = Task({
	inf.do({
		~score_firefly.reset;
		~score_firefly.play(quant:0);
		5.rrand(15).wait;
	});
});

~func_clicked_firefly = {
	| idx |
	idx.postln;

	Pbind(
		\instrument, \firefly,
		\multiplier, Prand( [2, 4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.125,0.25, 3),
		\out, idx
	).play(quant:0);
};

/*
// function to launch religion
~playBuf = {
	|pathSec, type|
	// set the right path for the number of sample
	var finalP, n, buf, sig;
	if(type == "r", {//multiple available samples
		n = (5.rand + 1);
		finalP = ~samplesPath ++ "/" ++ pathSec ++ "/" ++ pathSec ++ n ++ ".wav";
	},{//single sample
		n = "single file";
		finalP = ~samplesPath ++ "/" ++ pathSec ++ "/" ++ pathSec ++ ".wav";
	});

	("n sample: "++n).postln;
	buf = Buffer.read(s, finalP);
	sig = Synth(\Attack, [\bufnum, buf]);
};
//get the message argument and play the right religion attack
~parseReligion = {
	|msg|
	switch(msg,
		0, {"cattolicesimo".postln;},
		1, {"ebraismo".postln; if(true, {~playBuf.value("harp", "r")}, {"".postln;})},
		2, {"Sikh".postln;},
		3, {"Induismo".postln;},
		4, {"islam".postln; if(true, {~playBuf.value("muezzin", "s")}, {"".postln;})},
		5, {"buddismo".postln;},
		6, {"ateismo".postln;},
		7, {"protestantesimo".postln; if(true, {~playBuf.value("organ", "r")}, {"".postln;})},
	)
}
*/

// samples management


/*
// TEST STUFF ///////////////////////////////////////////////////////////////////////
~func_clicked_firefly.value(0);
{SinOsc.ar(384*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(384 )*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(320*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
*/
