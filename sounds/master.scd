// RELIGION MASTER

(
// server settings;
s=Server.local;
s.options.numOutputBusChannels = 8; // we will have a speaker for each religion (8)
s.options.numInputBusChannels = 0;
s.meter;
s.plotTree;

s.waitForBoot({

	// Synth definitions:
	"synths.scd".loadRelative;

	s.sync;

	// Routing:
	// create the groups
	~grp_out = Group.new();
	~grp_syn = Group.new(~grp_out, \addBefore);

	// create the arrays
	//~array_syn = ~array_syn ? [];
	~array_bus = ~array_bus ? [];
	~array_out = ~array_out ? [];

	/*
	* Populate the arrays:
	* - create busses;
	* - create output stages;
	*/
	s.options.numOutputBusChannels.do(
		{
			|item|
			//("Item "+item).postln;
			~array_bus = ~array_bus.add(
				Bus.audio(s, 1);
			);

			~array_out = ~array_out.add(
				Synth(\outputStage, [\in, ~array_bus[item], \out, item], target:~grp_out);
			);
	});

	// TODO: create the tibetan voices and pass them the bus array
	Synth(\drone, [\out, ~array_bus, \freq, 32, \mix, 0.1,  \detune, 0.5, \amp, 0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 64, \mix, 0.3,  \detune, 1,   \amp, 0.25], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 96, \mix, 0.5,  \detune, 1.1, \amp, 0.25*0.9], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 128,\mix, 0.7,  \detune, 1.2, \amp, 0.25*0.7], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 192,\mix, 0.9,  \detune, 1.4, \amp, 0.25*0.5], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 256,\mix, 0.99, \detune, 1.6, \amp, 0.25*0.2], target:~grp_syn);
	Synth(\drone, [\out, ~array_bus, \freq, 320,\mix, 0.99, \detune, 2,   \amp, 0.25*0.3], target:~grp_syn);


	// Score creation:
	"score.scd".loadRelative;

	// OSC controls:
	"osc.scd".loadRelative;

});
)

/*
Server;
s.serverRunning;
s.makeGui;

s.plotTree;
s.meter;
s.freeAll;
s.queryAllNodes;

~busArray[0];
~synthArray[7];
~outArray[4];

~bus  = Bus.audio(s, 1);
~fade = Synth(\outputStage, [\in, ~bus, \out, 0]);
~sine = Synth(\sine, [\out, ~bus], ~fade, \addBefore);
~fade.set(\in, ~bus);
~sine.set(\out, ~bus);
~fade.set(\gate_fade, 0);
~fade.set(\lowLevel, 0.25);
*/