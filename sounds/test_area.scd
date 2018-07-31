// TEST AREA

(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 2);
~ctrl.sendMsg("/method/released",2);


(
// Synth for launch buffer play
SynthDef(\Attack, {
	|
	out=0, bufnum=0, amp=1.0
	atk=0.01, rls=5, c=(-1)
	|
	var sig, env;
	env = EnvGen.ar(Env.perc(atk, rls, curve:c), doneAction:2);
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) );
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)


~path_samples = PathName.new( thisProcess.nowExecutingPath );


// CATTOLICESIMO (procedural)
~path_cattolicesimo_samples

// BUDDISMO (procedural)
~path_buddismo_samples

// INDUISMO (procedural)
~path_induismo_samples

(
// SICK (single sample)
~path_sick_samples = PathName(~path_samples.pathOnly+/+"samples/windchimes/windchime.wav");
~sample_sick = Buffer.read(s, ~path_sick_samples.fullPath);

// ISLAM (single sample)
~path_islam_samples = PathName(~path_samples.pathOnly+/+"samples/muezzin/muezzin.wav");
~sample_islam = Buffer.read(s, ~path_islam_samples.fullPath);

// ATEISMO (single sample)
~path_ateismo_samples = PathName(~path_samples.pathOnly+/+"samples/gaber/mono/gaber1.wav");
~sample_ateismo = Buffer.read(s, ~path_ateismo_samples.fullPath);

// PROTESTANTESIMO (sample from and array of samples)
~path_protestantesimo_samples = PathName(~path_samples.pathOnly+/+"samples/organ/mono");
~samples_protestantesimo = ~samples_protestantesimo ? [];
~path_protestantesimo_samples.entries.do({
	| entry |
	//entry.postln;
	if(entry.isFile,
		{
			~samples_protestantesimo = ~samples_protestantesimo.add(Buffer.read(s, entry.fullPath));
	});
});
~samples_protestantesimo.size;

// EBRAISMO (sample from and array of samples)
~path_ebraismo_samples = PathName(~path_samples.pathOnly+/+"samples/harp/");
~samples_ebraismo = ~samples_ebraismo ? [];
~path_ebraismo_samples.entries.do({
	| entry |
	//entry.postln;
	if(entry.isFile,
		{
			~samples_ebraismo = ~samples_ebraismo.add(Buffer.read(s, entry.fullPath));
	});
});
~samples_ebraismo.size;



~parseReligion = {
	|msg|
	switch(msg,
		0, {
			"cattolicesimo".postln;
		},
		1, {
			"ebraismo".postln;
			Synth(\Attack,
				[
					\bufnum, ~samples_ebraismo.choose,
					\rls, 7,
					\amp, 1.0,
					\out, msg
				]
			);

		},
		2, {
			"Sikh".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_sick,
					\amp, 1.0,
					\out, 0
				]
			);
		},
		3, {"Induismo".postln;},
		4, {
			"islam".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_islam,
					\rls, 6,
					\amp, 1.0,
					\out, 0
				]
			);
		},
		5, {"buddismo".postln;},
		6, {
			"ateismo".postln;
			Synth(\Attack,
				[
					\bufnum, ~sample_ateismo,
					\rls, 6,
					\amp, 1.0,
					\out, 0
				]
			);
		},
		7, {
			"protestantesimo".postln;
			Synth(\Attack,
				[
					//\bufnum, ~samples_protestantesimo.choose,
					\bufnum, ~samples_protestantesimo[1],
					\rls, 7,
					\amp, 1.0,
					\out, 0
				]
			);
		}
	)
}
)



// PROSPETTO SUONI
// Cattolicesimo   - Glockenspiel (procedurale/campionato)
// Sick            - riproduzione audio file Wind chimes (campionato)
// Protestantesimo - Organo selezione randomica campioni.
// Islam           - riproduzione audio file muezzin, già riverberato(campionato)
// Induismo - Tabla partitura procedurale di campione.
// Ebraismo - Arpa selezione randomica campioni.
// Ateismo  - riproduzione audio file Gaber(campionato)
// Buddismo - campana (procedurale/campionato)

