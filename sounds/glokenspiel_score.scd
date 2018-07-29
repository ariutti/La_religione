// "vieni vieni" glokenspiel score
// 82 BPM means that a crochet note last 0.731 seconds

(
~notesA    = [60, 60, 60, 60, 60, 65, 65, 65, 65, 65, 65, 65, 63, 63, 63, 63, 65, 63, 62, 62];
~durationA = [1,1,0.5,1,0.5, 0.5,0.5,0.5,0.5,0.5,1,0.5,0.66,0.66,0.66,0.66,0.66,0.66,1,3];

~notesB    = [60, 60, 60, 60, 60, 65, 65, 65, 65, 65, 65, 65, 63, 63, 63, 63, 65, 63, 62, 62, 60, 59, 60];
~durationB = [1,1,0.5,1,0.5, 0.5,0.5,0.5,0.5,0.5,1,0.5,0.66,0.66,0.66,0.66,0.66,0.66,2,0.66,0.66,0.66,4];

~notesB1   = [63, 63, 63, 63, 65, 63, 62, 62, 60, 59, 60];
~durationB1 = [0.66,0.66,0.66,0.66,0.66,0.66,2,0.66,0.66,0.66,4];
)

(
Pbind(
	\instrument, \bell,
	//\fs,  (Pseq( ~notesA ++ ~notesB, inf ) + 3).midicps,
	\fs,  (Pseq( ~notesB1, inf ) + 3).midicps,
	//\dur, Pseq( ~durationA ++ ~durationB )*0.731*Pwhite(0.98, 1.1, inf),
	\dur, Pseq( ~durationB1 )*0.731*Pwhite(0.98, 1.1, inf),
	\t60, 4,
	\pitchy, 4
).play;
)

s.plotTree;