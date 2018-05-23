#include "julia.h"
char s[2];

void julia1(Real ha, Real hb, Real va, Real vb, FN* re, FN* im, int iter)
{
	void juliasim(), julianonsim();


	azzera_mat();

	juliasim(hb, vb, re, im, iter);
}

void juliasim(Real h, Real v, FN *re, FN *im, int iter)
{
	int i;
	/* int step = 65536*256/45; */
	int step = 65536*256/iter;
	double *rememx, *rememy;
	double *immemx, *immemy;

	printf("step=%d\n", step);
	rememx = fnmemory(re, 'x');
	rememy = fnmemory(re, 'y');
	immemx = fnmemory(im, 'x');
	immemy = fnmemory(im, 'y');

	hp = (2*h) / MAXX,  vp = (2*v) / MAXY;

	for (n=0; n<MAXY; n++) {
		printf("run %d/%d\n", n+1, MAXY);
		for (m=0; m<MAXX; m++) {
			x_0 = -h + m*hp;
			*rememx = x_0;
			*immemx = x_0;
			y_0 = v - n*vp;
                        *rememy = y_0;
			*immemy = y_0;
#ifdef HARDEBUG
printf("x = %lf, y=%lf\n", *rememx, *rememy);
scanf("%s", s);
#endif

			for (i=iter; i>0; i--) {
				x_1 = fnread(re);
				y_1 = fnread(im);
#ifdef HARDEBUG
printf("loop: iterazione %d\n", i);
printf("x = %lf, y=%lf\n", x_1, y_1);
scanf("%s", s);
#endif
				if (x_0 == x_1 && y_0 == y_1)
					break;

				x_0 = *rememx = *immemx = x_1;
				y_0 = *rememy = *immemy = y_1;
			/*
				x_0 = x_1;
				y_0 = y_1;
				x_1 = x_0*x_0 - y_0*y_0 + cr;
				y_0 = 2*x_0*y_0 + ci;
				x_0 = x_1;
			 */

				if (x_0*x_0+y_0*y_0 > THRESHOLD) 
					break;
			}

			pset(i*step);
		}/* for(m) */
	}/* for(n) */
}


void julianonsim(Real ha, Real hb, Real va, Real vb, FN *re, FN *im, int iter)
{
	int i;
	double *rememx, *rememy;
	double *immemx, *immemy;

	printf("julianonsim\n");

	rememx = fnmemory(re, 'x');
	rememy = fnmemory(re, 'y');
	immemx = fnmemory(im, 'x');
	immemy = fnmemory(im, 'y');

	hp = (hb-ha) / MAXX,  vp = (va-vb) / MAXY;

	printf("hp=%f, vp=%f\n", hp, vp);

	for (n=0; n<MAXY; n++) {
		printf("run %d/%d\n", n+1, MAXY);
		y_0 = va + n*vp;
		*rememy = *immemy = y_0;

		for (m=0; m<MAXX; m++) {
			x_0 = ha + m*hp;
			*rememx = *immemx = x_0;
			for (i=iter; i>0; i--) {
				x_1 = fnread(re);
				y_1 = fnread(im);
				*rememx = *immemx = x_1;
				*rememy = *immemy = y_1;
				x_0 = x_1;
				y_0 = y_1;

				if (x_1*x_1+y_1*y_1 > THRESHOLD) break;
				}
			if(!i)psetcol(m,n, 100);
		}/* for(m) */
	}/* for(n) */
}
