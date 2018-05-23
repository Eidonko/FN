#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fn.h"

/* cc -o fntest fntest.c libfn.a -ll -ly -lm */

int main()
{
	FN *f;
	float d;
	double *x, *y, z;
	char s[2];
	char function[512];

	printf("Please give me a functional form using variables x and y.\n");
    scanf("%s", function);
    printf("'%s'\n", function);
    strcat(function, "\n");
	f=fnopen_s(function);

	x = fnmemory(f, 'x');
	y = fnmemory(f, 'y');

	printf("Please give me values for x and y :\n x = ");

	scanf("%f", &d);
	*x = d;

	printf("\n y = ");
	scanf("%f", &d);
	*y = d;

	printf("(x,y)=(%lf,%lf)\n", *x, *y);

	printf("result = %lf\n", fnread(f));

	while (1)
	  {
		  z = fnread(f);
		  printf("I now set x with the f(x,y): %lf\n", z);
		  *x = z;
		  printf("Insert a character and press return... ");
		  scanf("%s", s);
	  }
}

int yywrap() { return 1; }
