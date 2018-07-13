// RELIGION SCORE

~score_firefly = Pfinval(2.rrand(4),
	Pbind(
		\instrument, \firefly,
		\group, ~grp_syn,
		\multiplier, Prand( [4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.5,1,inf),
		\out, Pindex(~array_bus, Prand((0..7), inf).trace )
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
// TEST STUFF
~func_clicked_firefly.value(0);
{SinOsc.ar(384*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(384 )*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(320*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
*/
