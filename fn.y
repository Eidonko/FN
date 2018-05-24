%{
# include <stdio.h>
# include <ctype.h>
# include <string.h>
# include <stdarg.h>
# include <math.h>

# include "fn.h"
int fndebug;
double mem[MAXMEM];
int    code[MAXCODE];
int memn, coden;

int yyerror(char *s) { fprintf(stderr, "Error: %s\n", s); }
%}

%token INDEX

/* precedenze/associativita' */
%left '+' '-'
%left '*' '/'
%left '^'
%left SIN ACOS ASIN ATAN LOG LOG10 EXP COS TAN SQRT CEIL FABS FLOOR
%left UMINUS 

/* %left UMINUS */

%%	/* Da qui hanno inizio le regole di produzione */
line	: 	expr	'\n'
		{
		if (fndebug)
			printf("line: line expr '\\n'\n");
		return 0;
		}
	| 	error	'\n'
		{ printf("? Redo from start.\n"); yyclearin; yyerrok; }
		line
		{ return 0; }
	;

expr	:	'(' expr ')'
                        { $$ = $2; }
	|	expr '^' expr
			{
			if (fndebug)
				printf("expr: expr ^ expr\n");
			new_code('^');
			}
	|	expr '*' expr	%prec '*'
			{
			if (fndebug)
				printf("expr: expr * expr\n");
			new_code('*');
			}
	|	expr '/' expr	%prec '*'
			{
			if (fndebug)
				printf("expr: expr / expr\n");
			new_code('/');
			}
	|	expr '+' expr	%prec '+'
			{
			if (fndebug)
				printf("expr: expr + expr\n");
			new_code('+');
			}
	|	expr '-' expr	%prec '-'
			{
			if (fndebug)
				printf("expr: expr - expr\n");
			new_code('-');
			}
	|	'-' expr 			%prec UMINUS
			{
			if (fndebug)
				printf("expr: '-' expr\t\t%d\n", $2);
			new_code(UMINUS);
			}
	|	SIN	expr
			{
			if (fndebug)
				printf("expr: func expr\t\t%d\n", $1);
			new_code($1);
			}
	|	COS	expr
			{
			if (fndebug)
				printf("expr: func expr\t\t%d\n", $1);
			new_code($1);
			}
	|	TAN	expr
			{
			if (fndebug)
				printf("expr: func expr\t\t%d\n", $1);
			new_code($1);
			}
	|	INDEX
			{
			if (fndebug)
				printf("expr: INDEX\t\t%d\n", $1);
			new_code(- $1);  /* operand are negative values */
			}
	;
%%	/* Zona programmi */
static int sp2;

static int init_stack() { sp2=0; }

static int push2(double d)
{
  mem[sp2++] = d;
#ifdef HARDEBUG
printf("%lf = push()\n", d);
#endif
  if (sp2 >= MAXMEM) return 0;
  return 1;
}

static int pop2(double *d)
{
  if (sp2 <= 0) return 0;
  *d = mem[--sp2];
#ifdef HARDEBUG
printf("%lf = pop()\n", *d);
#endif
  return 1;
}

#include "lex.yy.c"

fnerr(int s)
{
fprintf(stderr, "class fn error: ");
switch(s)
  {
    case MALLOC: fprintf(stderr, "allocation error"); break;
    default: fprintf(stderr, "unknown error"); break;
  }
fprintf(stderr, ".\n");
}

// From https://stackoverflow.com/questions/39133560/how-to-parse-a-c-string-with-bison
/* Declarations */
void set_input_string(const char* in);
void end_lexical_scan(void);

/* This function parses a string */
int parse_string(const char* in) {
  set_input_string(in);
  int rv = yyparse();
  end_lexical_scan();
  return rv;
}


FN *fnopenv(void)
{
 FN *fnp; int i;


 memn=26; coden=0;

 Catstring[0] = '\0';
 fndebug = FNDEBUG;

 yyparse();

 fnp = (FN*) malloc(sizeof(FN));
 if (! fnp) fnerr(MALLOC);
 fnp->mem = (double*) malloc(memn*sizeof(double));
 if (!fnp->mem) fnerr(MALLOC);

 fnp->code = (int*)malloc(coden*sizeof(int));
 if (!fnp->code) fnerr(MALLOC);

 fnp->memn = memn;
 fnp->coden = coden;

 for (i=0; i<memn; i++) fnp->mem[i] = mem[i];
 for (i=0; i<coden; i++) fnp->code[i] = code[i];

 fnp->s = (char*)strdup((char*)Catstring);
 if (!fnp->s) fnerr(MALLOC);
 printf("fun=%s\n", fnp->s);

 return fnp;
}

FN *fnopen(char *s)
{
 FN *fnp; int i;


 memn=26; coden=0;

 Catstring[0] = '\0';
 fndebug = FNDEBUG;

 parse_string(s);

 fnp = (FN*) malloc(sizeof(FN));
 if (! fnp) fnerr(MALLOC);
 fnp->mem = (double*) malloc(memn*sizeof(double));
 if (!fnp->mem) fnerr(MALLOC);

 fnp->code = (int*)malloc(coden*sizeof(int));
 if (!fnp->code) fnerr(MALLOC);

 fnp->memn = memn;
 fnp->coden = coden;

 for (i=0; i<memn; i++) fnp->mem[i] = mem[i];
 for (i=0; i<coden; i++) fnp->code[i] = code[i];

 fnp->s = (char*)strdup((char*)Catstring);
 if (!fnp->s) fnerr(MALLOC);
 printf("fun=%s\n", fnp->s);

 return fnp;
}

double fnread(FN* f /* , ... */)
{
  va_list ap;
  char v[26];
  int nv=0;
  int i, op;
  double op1, op2;

/*
  va_start(ap, f);
  while ( (v[nv++] = va_arg(ap, char)) 
  fmt = va_arg(ap, );
*/

  init_stack();

  if (fndebug>=2)
    {
      printf("coden=%d\n", f->coden);
      for (i=0; i<f->coden; i++)
        printf("%d ", f->code[i]);
      printf("\n");
    }


  for (i=0; i<f->coden; i++)
    if (f->code[i] < 0)
	{
	if (!push2(f->mem[ - f->code[i] ]) )
		fnerr(PUSH2);
	}
    else
       switch(f->code[i]) {
         case '+':
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!pop2(&op1))
		fnerr(POP2);
	   if(!push2(op1 + op2))
		fnerr(PUSH2);
	   break;

         case '-':
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!pop2(&op1))
		fnerr(POP2);
	   if(!push2(op1 - op2))
		fnerr(PUSH2);
	   break;

         case '/':
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!pop2(&op1))
		fnerr(POP2);
	   if (op2 == 0) fnerr(DIVBYZERO);
	   if(!push2(op1 / op2))
		fnerr(PUSH2);
	   break;

         case '*':
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!pop2(&op1))
		fnerr(POP2);
	   if(!push2(op1 * op2))
		fnerr(PUSH2);
	   break;

         case SIN:
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!push2(sin(op2)))
		fnerr(PUSH2);
	   break;

         case COS:
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!push2(cos(op2)))
		fnerr(PUSH2);
	   break;

         case TAN:
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!push2(tan(op2)))
		fnerr(PUSH2);
	   break;

         case UMINUS:
	   if(!pop2(&op2))
		fnerr(POP2);
	   if(!push2(- op2))
		fnerr(PUSH2);
	   break;
	}

  if(!pop2(&op1))
	fnerr(POP2);
  return op1;
}
 
void fnclose(FN* fn)
{
  free(fn->mem), free(fn->code), free(fn->s);
  free(fn);
}

double *fnmemory(FN* f, int c)
{
  if (isalpha(c)) return & f->mem[toupper(c)-'A'];
  return NULL;
}

void fnsetmem(FN* f, int c, double d)
{
  if (isalpha(c)) 
    f->mem[toupper(c)-'A'] = d;
}
double fngetmem(FN* f, int c)
{
  if (isalpha(c)) 
    return f->mem[toupper(c)-'A'];
}

const char *fn(FN* f) { return f->s; }

/* eof fn.y */
