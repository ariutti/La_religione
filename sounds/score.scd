// RELIGION SCORE

~score_firefly = Pfinval(2.rrand(4),
	Pbind(
		\instrument, \firefly,
		\multiplier, Prand( [4, 8], inf),
		\freq, Prand([ 384, 320 ], inf) * Pkey(\multiplier),
		\dur, Pwhite(0.5,1,inf)
)).asEventStreamPlayer;

y = Task({
	inf.do({
		~score_firefly.reset;
		~score_firefly.play(quant:0);
		10.rrand(30).wait;
	});
});



/*
{SinOsc.ar(384*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(384 )*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
{SinOsc.ar(320*4)*EnvGen.ar(Env.perc(0.01, 3), doneAction:2) * 0.25;}.play;
*/


