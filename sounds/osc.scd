// RELIGION OSC

~ctrl = NetAddr("127.0.0.1", 15300);




// clicked function
~osc_clicked = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Clicked (index" + msg[1] + ").");
	if( msg[1]>=0 && msg[1]<8,
		{
			//"true condition".postln;

			// fade out on the "i" output stage
			~array_out[ msg[1] ].set(\level, 0.05, \lagTime, 0.5);

			// call a function to play more than one firefly
			// at the selected speaker position
			//~func_clicked_firefly.value( msg[1] );

			// call the function to play the
			// corresponding religion sound
			~parseReligion.value( msg[1] );
		},
		{
			//"condizione falsa".postln;
			"Invalid index".postln;
		}
	);
}, "/method/clicked", recvPort:15300);



// released function
~osc_released = OSCFunc({
	| msg, time, addr, recvPort |
	postln("Relesaed (index" + msg[1] + ").");
	if( msg[1]>=0 && msg[1]<8,
		{
			//"condizione vera".postln;
			~array_out[ msg[1] ].set(\level, 1.0, \lagTime, 5);
		},
		{
			//"condizione falsa".postln;
			"Invalid index".postln;
		}
	);
}, "/method/released", recvPort:15300);





// TODO: add a "statup sound" OSC function
~osc_sound = OSCFunc({
	| msg, time, addr, recvPort |
	postln("func 'sound' " ++ msg[1] );

	if( msg[1]==1, {
		~array_out.do{
			|item|
			//item.postln;
			item.set(\level, 1.0, \lagTime, 5);
		};
		~task_firefly.start;
	},
	{
		~array_out.do{
			|item|
			//item.postln;
			item.set(\level, 0.0, \lagTime, 3);
		};
		~task_firefly.stop;
	});
}, "/method/sound", recvPort:15300);






/*
// TEST STUFF /////////////////////////////////////////////////////////////////

~ctrl.sendMsg("/method/clicked", 0);
~ctrl.sendMsg("/method/released", 1);
~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);


~osc_sound.free;
~osc_sound


(
8.do({
	|item|
	item.postln;
	//~ctrl.sendMsg("/method/clicked", item );
	//~ctrl.sendMsg("/method/clicked", item );
	~ctrl.sendMsg("/method/released", item );
});
)
*/

/*
// QUIT function
~osc_quit = OSCFunc({
| msg, time, addr, recvPort |
postln("func quit");
if( msg[1]==1 && s.serverRunning, {
s.freeAll;
s.quit;
},{} );
}, "/method/sound", recvPort:15300);
*/