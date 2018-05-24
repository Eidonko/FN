
double fnread(FN*);
FN *fnopenv(void);
FN *fnopen(char*);
void fnclose(FN*);
double *fnmemory(FN*,int);
void fnsetmem(FN*, int, double);
double fngetmem(FN*, int);
const char *fn(FN*);
