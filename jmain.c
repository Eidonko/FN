#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "julia.h"

int main(int argc, char *argv[])
{
	Real ha, hb, va, vb;
	Real cr, ci;
	int  iter;
	FILE *f;
	char param[256];
	FN *re, *im;
	Real atof();
    char *re_s, *im_s;
	int l;

	printf("This program demonstrates the use of class FN by generating a Julia set\n");

	if(argc<8) {
		fprintf(stderr, "Usage: julia left right bottom top iterations real-part imaginary-part.\n");
 		exit(1);
	}

	ha=atof(argv[1]);
	hb=atof(argv[2]);
	va=atof(argv[3]);
	vb=atof(argv[4]);
	iter=atoi(argv[5]);
    l=strlen(argv[6]);
    re_s=malloc(l+2);
	strcpy(re_s, argv[6]);
    l=strlen(argv[7]);
    im_s=malloc(l+2);
	strcpy(im_s, argv[7]);
	strcat(re_s, "\n");
	strcat(im_s, "\n");

	printf("h(%f,%f), v(%f,%f); %d iterations\n" ,ha,hb,va,vb,iter);

	printf("Please insert a functional form:\n");
	printf("Real part : ");
	re=fnopen_s(re_s);
	printf("Imaginary part : ");
	im=fnopen_s(im_s);

	free(re_s), free(im_s);

	printf("Generating Julia set with algorithm no. 1\n");
	julia1(ha, hb, va, vb, re, im, iter);

	/*
	sprintf(param, "c=%f+i%f\n", cr,ci);
	*/
	ppmwrite(f, re, im, "frac.ppm");
	fnclose(re), fnclose(im);
}
