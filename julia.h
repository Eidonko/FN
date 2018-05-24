/*
	julia.h
 */
#ifndef _CHAOS_INCLUDED
#define _CHAOS_INCLUDED

#include <stdio.h>
#include <stdlib.h>

#define MAXX 1600
#define MAXY 1600
 /*
#define MAXX 512
#define MAXY 512
#define MAXX 256
#define MAXY 256
*/

#define THRESHOLD  10e6

typedef double Real;
#define RealRead  "%lf"
#define RealWrite "%f"
typedef int    Row;
typedef int    Col;

extern Real x, y, x_0, y_0, x_1, y_1, cr, ci;
extern Real va, vb, vp,
            ha, hb, hp;
extern Row  n, maxy;
extern Col  m, maxx;

#include "fn.h"

void ppmwrite(FILE *f, FN *re, FN *im, char *s);
void pset(int col);
void psetcol(int i, int j, int col);
void azzera_mat();
void julia1(Real ha, Real hb, Real va, Real vb, FN* re, FN* im, int iter, int verb);
void juliasim(Real h, Real v, FN *re, FN *im, int iter, int verb);
void julianonsim(Real ha, Real hb, Real va, Real vb, FN *re, FN *im, int iter);

#endif /* _CHAOS_INCLUDED */

