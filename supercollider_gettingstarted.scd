// Notes & Exercises from "http://doc.sccode.org/Browse.html#Tutorials%3EGetting-Started"
// Last updated: 03 April 2018

////////////////////////////////////////////////////////////////////////////////////////////////////
// 02. First Steps
// 03. Start Your Engines
/* Execute a line -> CMD + <Enter>; Start server -> CMD + B
`f.value;` -> function’s value, called; evaluate this func now! */
(
"Hello World!".postln;
"Hello Jimmy!".postln;
)

Server.local.boot;  // equivalent to s.boot;
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.9)] }.play;

/* don't need to declare variables like f or s-> letters a to z are interpreter variables pre-declared when you start up SC, and have an unlimited, or 'global', scope; useful for quick tests or examples */

////////////////////////////////////////////////////////////////////////////////////////////////////
// 04. Functions and Other Functionality
{ [SinOsc.ar(400, 0, 0.1), SinOsc.ar(400, 0, 0.1)] }.play;

f = { "Function evaluated".postln; };
f.value;
f = { "Evaluating...".postln; 2 + 3; }; // `5` returned
f.value;

////////////////////////////////////////////////////////////////////////////////////////////////////
// 05. Functions and Sound
(
{
	var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(440, 0, ampOsc);
}.play;
)

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

g = {
    var freq;
    freq = [[660, 880], [440, 660], 1320, 880].choose;
    freq.postln;
};
g.value;

{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;
// equivalent to:
{ SinOsc.ar([440, 442], 0, 0.2) }.play;

////////////////////////////////////////////////////////////////////////////////////////////////////
// 07. Mix it Up
{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.play;
{ Mix.new([PinkNoise.ar(0.2), SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]) }.play;

// one channel
{ Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)]).postln }.play;
// combine two stereo arrays
(
{
    var a, b;
    a = [SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2)];
    b = [SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)];
    Mix([a, b]).postln;
}.play;
)

/* Saw is another type of oscillator, with a waveform that looks like a sawtooth; use a low value for mul -> the final output will be between -1 and 1, and not clip. */
(
{Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(662, 0.2),SinOsc.ar(442, 0, 0.2), Saw.ar(660, 0.2)])}.play;
)

/* Mix also has another class method called fill; takes two arguments (a number, which determines how many times the second argument, a Function, will be evaluated); results of the evaluations will be summed. */
(
    var n = 4;
    { Mix.fill(n, { SinOsc.ar(500 + 500.0.rand, 0, 1 / n) }) }.play;
)

////////////////////////////////////////////////////////////////////////////////////////////////////
// 08. Scoping & Plotting

// Scoping Out Some Plots

// Function-plot
// makes a graph of the signal produced by the output of the Function
{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.plot;

// Function-scope
// will play sound and show an oscilloscope-like display of the Function's output
{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.scope;
// can also work for multiple channels
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.scope;
// and zoom
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.scope(zoom: 10);

// Scoping on Demand
// can scope output of server with `.scope` method or clicking on the server window and pressing 's' key
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;
s.scope;

////////////////////////////////////////////////////////////////////////////////////////////////////
// 09. Getting Help

// Classes and Methods
/* anything in the code that begins with an uppercase letter is a class
most classes have help files; if you select a class by double-clicking on it, and press Cmd - d, the help file for that class will open if it exists */

// Syntax Shortcuts
/* http://doc.sccode.org/Reference/Syntax-Shortcuts.html
example: these do the same thing */
{ SinOsc.ar(440, 0, 0.2) }.play;
play({ SinOsc.ar(440, 0, 0.2) });

// Snooping, etc.
/* look up internal information on classes and functions
http://doc.sccode.org/Guides/Internal-Snooping.html
http://doc.sccode.org/Guides/More-On-Getting-Help.html */

////////////////////////////////////////////////////////////////////////////////////////////////////
// 10. SynthDefs and Synths

// Meet the SynthDef
/* server doesn't understand Functions, or OOP, or the SC language; wants information on how to create audio output in a special form called a synth definition
synth def: data about UGens and how they're interconnected, sent in 'byte code'
synths: things that make or process sound, or produce control signals to drive other synths
SynthDef and related classes: to create necessary byte code and deal with synth defs in an OOP way
Function's audio creating methods ->  corresponding instance of SynthDef is created 'behind the scenes'; necessary byte code is generated and sent to the server, where a synth is created to play the desired audio */
// two equivalent examples
{ SinOsc.ar(440, 0, 0.2) }.play;
SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;
// SynthDef-new arguments: a name, usually in the form of a String; a Function, called a UGen Graph Function, as it tells the server how to connect together its various UGens

// SynthDefs vs. Functions
/* UGen Graph Function we used in the second example above has an extra UGen called Out; Out writes out an ar or kr signal to one of the server's busses (mixer channels or outputs; used for playing audio out of the computer, and for reading it in from sources such as microphones).  Out takes two arguments: The first is the index number of the bus to write out on. These start from 0, which on a stereo setup is usually the left output channel. The second is either a UGen or an Array of UGens. If you provide an array (i.e. a multichannel output) then the first channel will be played out on the bus with the indicated index, the second channel on the bus with the indicated index + 1, and so on.  When you use Function-play an Out UGen is created for you if you do not explicitly create one; default bus index for this Out UGen is 0. */
// stereo vs non-stereo
(
SynthDef.new("tutorial-SinOsc-stereo", { var outArray;
    outArray = [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)];
    Out.ar(0, outArray)
}).play;
)
(
SynthDef.new("tutorial-SinOsc-stereo", {
    Out.ar(0, SinOsc.ar(442, 0, 0.2))
	}).play;
)

/* Function-play and SynthDef-play return a Synth object (reps synth on a server); if you store this object by assigning it to a variable you can control it's behaviour in various ways; the method 'free' causes the synth on the server to stop playing and its memory and cpu resources to be freed; more flexible than Cmd-., which frees all synths at once. */
x = { SinOsc.ar(660, 0, 0.2) }.play;
y = SynthDef.new("tutorial-SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).play;
x.free;    // free just x
y.free;    // free just y

/* More often, you will want to send the corresponding byte code to the server app without immediately creating a synth; can play any number of copies of the SynthDef without the overhead of compiling or sending a network of unit generators; more efficient than repeatedly calling play on the same Function, as it saves the effort of evaluating the Function, compiling the byte code, and sending it multiple times -> in many cases saving in CPU usage is so small as to be largely insignificant, but when doing things like 'mass producing' synths, this can be important; in almost all cases, use 'add'.*/
// execute first, by itself
SynthDef.new("tutorial-PinkNoise", { Out.ar(0, PinkNoise.ar(0.3)) }).add;
// then:
x = Synth.new("tutorial-PinkNoise");
y = Synth.new("tutorial-PinkNoise");
x.free; y.free;
/* limitation to working with SynthDefs directly is that the UGen Graph Function in a SynthDef is evaluated once and only once; less flexible */
// first with a Function. Note the random frequency each time 'play' is called.
f = { SinOsc.ar(440 + 200.rand, 0, 0.2) };
x = f.play;
y = f.play;
z = f.play;
x.free; y.free; z.free;
// Now with a SynthDef. No randomness!
SynthDef("tutorial-NoRand", { Out.ar(0, SinOsc.ar(440 + 200.rand, 0, 0.2)) }).add;
x = Synth("tutorial-NoRand");
y = Synth("tutorial-NoRand");
z = Synth("tutorial-NoRand");
x.free; y.free; z.free;

// Creating Variety with SynthDefs
/* many ways of getting variety out of SynthDefs; e.g. randomness can be accomplished with various UGens (using Rand, which calculates a random number between low and high values when a synth is first created); more here -> http://doc.sccode.org/Browse.html#UGens */
SynthDef("tutorial-Rand", { Out.ar(0, SinOsc.ar(Rand(440, 660), 0, 0.2)) }).add;
x = Synth("tutorial-Rand");
y = Synth("tutorial-Rand");
z = Synth("tutorial-Rand");
x.free; y.free; z.free;
/* most common way of creating variables is through putting arguments into the UGen Graph Function -> allows you to set different values when the synth is created; passed in an array as the second argument to Synth-new; array should contain pairs of arg names and values */
(
SynthDef("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
x = Synth("tutorial-args");                // no args, so default values
y = Synth("tutorial-args", ["freq", 660]);        // change freq
z = Synth("tutorial-args", ["freq", 880, "out", 1]);    // change freq and output channel
x.free; y.free; z.free;

// More About Synth
/* Synth understands some methods which allow you to change the values of args after a synth has been created; e.g.'set'/Synth-set takes pairs of arg names and values. */
(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0;
    Out.ar(out, SinOsc.ar(freq, 0, 0.2));
}).add;
)
s.scope; // scope so you can see the effect
x = Synth.new("tutorial-args");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;

// Some Notes on Symbols, Strings, SynthDef and Arg Names
/* SynthDef names and argument names can be either a String or a Symbol; symbols written in one of two ways, either enclosed in single quotes: 'tutorial-SinOsc' or preceded by a backslash: \tutorial-SinOsc.
The difference between Strings and Symbols is that all Symbols with the same text are guaranteed to be identical, i.e. the exact same object, whereas with Strings this might not be the case; can test for this using '==='.
*/
"a String" === "a String";     // this will post false
\aSymbol === 'aSymbol';        // this will post true

////////////////////////////////////////////////////////////////////////////////////////////////////
// 11. Busses

s.quit;
