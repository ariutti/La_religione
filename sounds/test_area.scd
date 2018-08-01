// TEST AREA

(
s.meter;
s.plotTree;
s.freqscope;
)

~ctrl.sendMsg("/method/sound", 1);
~ctrl.sendMsg("/method/sound", 0);
~ctrl.sendMsg("/method/clicked", 7);
~ctrl.sendMsg("/method/released", 7);

(
// click all
8.do {
	|item|
	~ctrl.sendMsg("/method/clicked", item);
}
)

(
// release all
8.do {
	|item|
	~ctrl.sendMsg("/method/released", item);
}
)




