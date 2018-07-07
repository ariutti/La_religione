(
var path;

~samples_tabla_lowflick = ~samples_tabla_lowflick ? [];
~samples_tabla_hiflick = ~samples_tabla_hiflick ? [];
~samples_tabla_dead = ~samples_tabla_dead ? [];
~samples_tabla_hihit = ~samples_tabla_hihit ? [];
~samples_tabla_lower = ~samples_tabla_lower ? [];

path = PathName.new( thisProcess.nowExecutingPath );
path = PathName(path.pathOnly+/+"tabla");
//path.postln;

~dic_tabla = ();

path.entries.do({
	| subfolder |
	//subfolder.folderName.postln;

	if(subfolder.isFolder){
		var array = [];
		//"is folder".postln;
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

~dic_tabla.keys;
~dic_tabla.values;
~dic_tabla.getPairs;
~dic_tabla.associationAt(\lower);
~dic_tabla.[\lower].size;
~dic_tabla.[\hihit].size;


{PlayBuf.ar(2, ~dic_tabla[\hihit][ ~dic_tabla.[\hihit].size.rand ], 1, doneAction:2); }.play;
{PlayBuf.ar(2, ~dic_tabla[\hi_flick][ ~dic_tabla.[\hi_flick].size.rand ], 1, doneAction:2); }.play;
{PlayBuf.ar(2, ~dic_tabla[\dead][ ~dic_tabla.[\dead].size.rand ], 1, doneAction:2); }.play


(
// create the tabla player synth
SynthDef(\tabla, {
	| amp=0.75, buf=0, rate=1.0 |
	var sig, env;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, doneAction:2);

	sig = FreeVerb.ar(sig, 0.05, 2);
	sig = sig * amp;
	Out.ar(0, sig!2);
}).add;
)


x = Synth(\tabla, [\buf, ~dic_tabla[\hihit][0]]);
(0..(~dic_tabla[\hihit].size-1))



// create the tabla score
(
var keys = [\hihit, \low_flick, \lower, \hi_flick, \dead ];
~tabla_score = Pbind(
	\instrument, \tabla,
	\list, Pindex(keys, Prand((0..5), 1), inf).trace,
	//\buf, Pindex( ~dic_tabla[\hihit], Prand((0..(~dic_tabla[\hihit].size-1)), inf),inf),
	//\buf, Pindex( Pdict(~dic_tabla[Pkey(\list)], Prand((0..(~dic_tabla[Pkey(\list)].size-1)), inf),inf),
	\dur, Pwhite(0.125, 1, inf)
).play;
)
~tabla_score.stop;


