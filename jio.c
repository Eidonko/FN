#include <stdio.h>
#include "julia.h"

unsigned long mat[MAXX][MAXY];
unsigned long *mp;

void ppmwrite(FILE *f, FN *re, FN *im, char *s)
{
int i, N;
f=fopen(s, "w");

fprintf(f, "P6\n# Creato da Enzo De Florio, 1994,96. re(x,y)=%s, im(x,y)=%s\n",
	fn(re), fn(im));
fprintf(f, "%d %d\n255\n", MAXX, MAXY);

N=MAXX*MAXY;
mp=(unsigned long *)mat;

for (i=0; i<N; i++, mp++) {
	    fputc ( (int) *mp & 0xff , f );
	    *mp >>= 8;
	    fputc ( (int) *mp & 0xff , f );
	    *mp >>= 8;
	    fputc ( (int) *mp & 0xff , f );
	}
}

void pset(int col)
{
static unsigned long *mpi = &mat[0][0];
/*
static unsigned long *mpf = &mat[MAXX-1][MAXY-1];
*/

*mpi++ = col;
}

void psetcol(int i, int j, int col)
{
if(i<MAXX && i<MAXY)
mat[i][j] = (unsigned char)col;
else
printf("Errore in psetcol: i=%d,j=%d\n", i, j);
}

void azzera_mat()
{
int N=MAXX*MAXY;
mp=(unsigned long *)mat;

while (N--) *mp++ = 16777215;
}
