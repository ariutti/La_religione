// RELIGIONE Score

// GUI
(
~aux_gui_verb = Bus.audio(s, 1);
~gui_verb = Synth(\gui_fx, [\in, ~aux_gui_verb]);

~score_gui = Pbind(
	\instrument, \drop,
	\out, ~aux_gui_verb,
	\amp, 0.3,
	\drywet, Pgeom(1, 0.8, inf),
	\degree, Prand(Scale.majorPentatonic.degrees, inf).trace,
	\octave, Pseq([ 4, Pwrand([5, 6, 7],[1,4,6].normalizeSum, inf)],inf),
	\dur, Pwrand([0.25, 0.33, 0.125], [6,3, 8].normalizeSum, 3 )
).asEventStreamPlayer;
)


// Cello score
(
var y1 = 1;
var y2 = 0.5;

// load sound from disk.
~samples = Array.new;
//~folder = PathName.new("C:/Users/nicola/Music/philarmonic_orchestra/cello/renamed/wav/");
~folder = PathName.new("/home/nicola/Musica/philarmonic_orchestra/cello/renamed/wav/");
~folder.entries.do({
	arg path;
	//path.postln
	~samples = ~samples.add(Buffer.read(s, path.fullPath));
});
~samples.size;


~bass = Pbind(
	\instrument, \grain_cello,
	\out, 0,
	\octave, Pwrand([3,4],[7,3].normalizeSum, inf)*12, //Pwrand([3,4,6],[1,5,2].normalizeSum,inf)*12),
	\midinote, Pkey(\octave) + 0, //Prand([0, 3, 7, 8, 10, 12, 15], inf),
	\sndbuf, Pindex(~samples, Pkey(\midinote)-36),
	\dur, Pwhite(15, 20),
	\rt, 1.01, // the first sample is a bit out of tune
	\atk, 5,
	\rls, 5,
	\amp, 0.40,
	//\legato, 1,
	\type, Pwrand([\note, \rest], [7,1].normalizeSum, inf)
);


~violin = Pbind(
	\instrument, \grain_cello,
	\out, ~aux_cello_verb,
	\octave, Pwrand([4,5,6],[4,3,2].normalizeSum,inf)*12,
	//\midinote, (Pkey(\octave) + 5 + Prand([3, 7, 8, 10, 12, 15], inf)),
	\midinote, Pkey(\octave) + 0 + Prand( Scale.majorPentatonic.degrees, inf) ,
	\sndbuf, Pindex(~samples, Pkey(\midinote)-36),
	\dur, Pwhite(10, 15),
	\atk, 5,
	\rls, 5,
	\legato, Pwhite(0.25, 0.75),
	\amp, (((Pkey(\midinote)-56 )/ 24) * (y2-y1) + y1),
	//\type, Pwrand([\note, \rest], [7,3].normalizeSum, inf)
);



~score_violin = Ppar([~bass,~violin,~violin,~violin,~violin]).asEventStreamPlayer;
)



// FM score (w/ major Pentatonic)
(
~score_fm = Pbind(
	\instrument, \sineperc,
	//\midinote, (Prand([36, 48, 55, 67, 84],inf)).trace,
	\octave, 4, // +53
	\degree, Prand(Scale.majorPentatonic.degrees, inf),
	\dlytime, Prand([3, 4, 8], inf).reciprocal,
	\dynamic, Pexprand(0.01, 0.9, inf),
	\timbre, Pkey(\dynamic).reciprocal,
	\atk, Pkey(\dynamic) * 0.1,
	\rls, Pkey(\dynamic) * 0.5,
	\amp, Pwhite(0.15, 0.3, inf),
	//\amp, Pwhite(0.25, 0.5),
	\pos, Pwhite(-0.8, 0.8),
	\intervallo, Prand([10,7,9],inf),
	\dur, (Pkey(\dynamic).reciprocal).min(Pkey(\intervallo)),
	\out, 0//~auxRev
).asEventStreamPlayer;
)


// distant birds: score
(
~distant_bird = Synth(\distant_bird, [
	\f, rrand(3000, 10000),
	\dcy, rrand(1, 3),
	\amp, rrand(0.2, 0.6),
	\pos, rrand(-0.8, 0.8);
]);
)