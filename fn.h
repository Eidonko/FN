#ifndef CHTULHU
#define CHTULHU

#define MAXMEM 512
#define MAXCODE 256
#define MAX_CATSTRING 256

#define MALLOC    -1
#define PUSH2     -2
#define POP2      -3
#define DIVBYZERO -4

#define FNDEBUG 1
extern int fndebug;
extern double mem[MAXMEM];
extern int    code[MAXCODE];

static int new_mem(char *);
static int new_code(int);
void Cats(unsigned char[]);
extern int memn, coden;

typedef struct {  int memn, coden;
          int *code;
          double *mem;
          char *s;
} FN;
double fnread(FN*);
FN *fnopen(void);
FN *fnopen_s(char*);
void fnclose(FN*);
double *fnmemory(FN*,int);
void fnsetmem(FN*, int, double);
double fngetmem(FN*, int);
const char *fn(FN*);
#endif
