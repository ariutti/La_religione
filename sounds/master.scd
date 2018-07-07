// RELIGIONE Master!


s.options.memSize = s.options.memSize * 100;
s.options.memSize;
s.plotTree;


// define Synths


// following lines seem not to work
~score_gui.play;
~score_gui.stop;

~score_violin.play;
~score_violin.stop;

~score_fm.play;
~score_fm.stop;






// Filtered Noise: score
// make an array of noises here.
(
~noises = Array.new;
// populate the array of noise synths
4.do({
	"a".postln;
	~noises = ~noises.add(Synth(\filtered_noise));
});
)

// stop the noises
(
~noises.do({
	|synth|
	synth.set(\gate, 0);
});
)