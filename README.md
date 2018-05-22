# FN
A class of C functions to interpret functional forms

I define FN, a class to interpret functional forms. A functional form object is similar to a FILE object: one declares it via
  FN *descriptor;
and "opens" it via
  descriptor = fnopen();
The user then is requested to input a functional form in the two variables x and y.
Twenty-six predefined double precision variables are accessible via function fnmemory:
  double *fnmemory(FN *descriptor, int);
For instance if I need to make use of two variables, called x and y, then I use
  double *x, *y;
  x = fnmemory(f, 'x');
  y = fnmemory(f, 'y');
I can then use x and y to set input / get output values of the descriptor object.

