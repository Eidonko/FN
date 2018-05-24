# FN
A class of C functions to interpret functional forms.
By Eidon (eidon@tutanota.com) -- 20180523

FN is a C class to interpret functional forms. A functional form object is similar to a FILE object: one declares it via

  FN *descriptor;

and constructs it via

  descriptor = fnopen(string);

string is a char* such as "x*x-y*y+0.997" and represents a functional forms. Variables can be any of the letters of the English alphabet (here, 'x' and 'y'). Such variables map to 26 predefined double precision variables, which can be accessed via function fnmemory:

  double *fnmemory(FN *descriptor, int);
  
In order to compute the function in string, which makes use of the two variables x and y, I first need to map the internal variables x and y to double pointers, as in

  double *x, *y;
  x = fnmemory(f, 'x');
  y = fnmemory(f, 'y');
  
I can then use x and y to set input / get output values of the descriptor object. 

The function is then evaluated by calling fnread(descriptor).

fntest.c is a simple test program that exemplifies the use of FN.

A more complex example is given by jmain.c (see also the other j* functions), which defines two FN descriptors representing the real and imaginary part of a complex function. Said function is iterated so as to produce the graph of the corresponding Julia set. The executable of this program is called 'julia'. Type 'julia' for a description of the expected arguments.

test.bash loops julia so as to create a number of frames representing a Julia set a different 'distances'. The frames are converted into an animated gif via ImageMagick's 'convert'

A simple Makefile is available to compile the FN class and the test programs
