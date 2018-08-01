(
var path;

~samples_tabla_lowflick = ~samples_tabla_lowflick ? [];
~samples_tabla_hiflick = ~samples_tabla_hiflick ? [];
~samples_tabla_dead = ~samples_tabla_dead ? [];
~samples_tabla_hihit = ~samples_tabla_hihit ? [];
~samples_tabla_lower = ~samples_tabla_lower ? [];

path = PathName.new( thisProcess.nowExecutingPath );
path = PathName(path.pathOnly+/+"samples/tabla");
//path.postln;

~dic_tabla = ();

path.entries.do({
	| subfolder |
	//subfolder.folderName.postln;

	if(subfolder.isFolder) {
		var array = [];
		"is folder".postln;
		subfolder.entries.do({
			|file|
			if( (file.isFile).and(file.extension=="wav")) {
				// it is a wav file!
				array = array.add( Buffer.read(s, file.fullPath) );
			};
		});

		("folder '"+subfolder.folderName+"' contains "+array.size+"soundfiles!").postln;
		~dic_tabla.put(subfolder.folderName.asSymbol, array);
	};
});
("tabla dictionary now contains "+~dic_tabla.size+" lists!").postln;
//~dic_tabla.values;

)


(
// create the tabla player synth
SynthDef(\tabla, {
	| amp=1, buf=0, rate=1.0 |
	var sig, env;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, doneAction:2);

	//sig = FreeVerb.ar(sig, 0.05, 2);
	sig = sig * amp * 3;
	Out.ar(0, sig!2);
}).add;
)

// test a single sound
x = Synth(\tabla, [\buf, ~dic_tabla[\hihit][0]]);

// we can create a Pbind for each family of samples
(
~score_tabla_hihit = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \hihit ], Prand((0..(~dic_tabla[ \hihit ].size-1)), 1), 1),
	\dur, 0.182 //Pwhite(0.125, 1, 1)
);

~score_tabla_dead = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \dead ], Prand((0..(~dic_tabla[ \dead ].size-1)), 1), 1),
	\dur, 0.035 //Pwhite(0.125, 1, 1)
);

~score_tabla_lower = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \lower ], Prand((0..(~dic_tabla[ \lower ].size-1)), 1), 1),
	\dur, 0.35 //Pwhite(0.125, 1, 1)
);

~score_tabla_hiflick = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \hi_flick ], Prand((0..(~dic_tabla[ \hi_flick ].size-1)), 1), 1),
	\dur, 0.400 //Pwhite(0.125, 1, 1)
);

~score_tabla_lowflick = Pbind(
	\instrument, \tabla,
	\buf, Pindex( ~dic_tabla[ \low_flick ], Prand((0..(~dic_tabla[ \low_flick ].size-1)), 1), 1),
	\dur, 0.151 //Pwhite(0.125, 1, 1)
);
)


(
~score_tabla = Pseq([
	Pif(Pfunc({ 0.7.coin }), ~score_tabla_hiflick),
	Pif(Pfunc({ 0.9.coin }), ~score_tabla_lower),
	Pif(Pfunc({ 0.6.coin }), ~score_tabla_hihit),
	Pif(Pfunc({ 0.8.coin }), ~score_tabla_lowflock),
	Pif(Pfunc({ 0.6.coin }), ~score_tabla_dead),
], Prand([1,2],1).trace ).asEventStreamPlayer;
)

~score_tabla.play(doReset:true);


/*
// OLD STUFF /////////////////////////////////////////////////////////////////////////

// create the tabla score
(
var keys = [ \hihit, \lower, \dead ]; //\low_flick, \hi_flick,
~tabla_score = Pbind(
	\instrument, \tabla,
	\list, \hihit, //Pindex(keys, Prand((0..5), 1), inf).trace,
	\buf, Pindex( ~dic_tabla[ Pkey(\list) ], Prand((0..(~dic_tabla[ Pkey(\list) ].size-1)), inf),inf),
	//\buf, Pindex( Pdict(~dic_tabla, Prand((0..(~dic_tabla[Pkey(\list)].size-1)), inf),inf),
	//\buf, Pindex(Pdict( ~dic_tabla, Prand( ~dic_tabla.keys.asArray, 3).asSymbol, inf) ).trace,
	\buf, ~dic_tabla[\hihat][0],
	\dur, 2 //Pwhite(0.125, 1, inf)
).play;
)


(
~tabla_score = Pbind(
	\instrument, \tabla,
	\list, \dead, //Prand(  [ \hihit, \lower, \dead ], inf).trace,
	\buf, Pindex(Psym( Pkey(\list), ~dic_tabla, inf).asArray, 1, inf),
	\dur, 2
).play;
)
~tabla_score.stop;


~dic_tabla[\hihit][0].duration;
~dic_tabla[\hihit][1];

(
~task_play_tabla = Task({

	var list, buffer, duration;

	list =
	buffer = ~dic_tabla[\hihit][0];
	duration = buffer.duration;
	Synth(\tabla, [\buf, buffer]);
	duration.wait;

	buffer = ~dic_tabla[\hihit][1];
	duration = buffer.duration;
	Synth(\tabla, [\buf, buffer]);
	duration.wait;

	buffer = ~dic_tabla[\hihit][2];
	duration = buffer.duration;
	Synth(\tabla, [\buf, buffer]);
	duration.wait;

});
)

~task_play_tabla.play(quant:0);

~dic_tabla[\hihit][0].duration

// TEST stuff /////////////////

~dic_tabla.keys;
~dic_tabla.values;
~dic_tabla.getPairs;
~dic_tabla.associationAt(\lower);
~dic_tabla[\lower].size;
~dic_tabla[\hihit].size;

{PlayBuf.ar(2, ~dic_tabla[\hihit][ ~dic_tabla.[\hihit].size.rand ], 1, doneAction:2); }.play;
{PlayBuf.ar(2, ~dic_tabla[\hi_flick][ ~dic_tabla.[\hi_flick].size.rand ], 1, doneAction:2); }.play;
{PlayBuf.ar(2, ~dic_tabla[\dead][ ~dic_tabla.[\dead].size.rand ], 1, doneAction:2); }.play
{PlayBuf.ar(2, ~dic_tabla[\lower][ ~dic_tabla.[\lower].size.rand ], 1, doneAction:2); }.play
{PlayBuf.ar(2, ~dic_tabla[\low_flick][ ~dic_tabla.[\low_flick].size.rand ], 1, doneAction:2); }.play




~dic_tabla.keys.asArray[0].asSymbol
(0..(~dic_tabla[\hihit].size-1))

Psym
Pdic
Ptuple
Pdict
*/