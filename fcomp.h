#ifndef __FCOMP_H__
#define __FCOMP_H__
#include <stdio.h>
#include "y.tab.h"
#include "../blocks/static_blocks.h"


typedef struct blocked_token * tblock;
typedef struct blocked_variable * varblock;

typedef enum {
    VARINIT,
    FUNCDEF,
    RET,
    VARASSN
} codetype;

typedef struct {
    int id;
    int sid;
    char * text;
}  token;


typedef struct {
    tblock token_list;
    int eltype;
    int r_type;
} codeline ;

typedef struct {
    token var_name;
    tblock expr;
    int scope;
} variable;

dynamic_block(token);
dynamic_block(variable);
tblock token_block;
varblock var_table;

void set_token(int id, int sid);
void print_code(codeline  * v);
void var_init_c(codeline * v);
void reset();
void set_token(int id, int sid);
variable get_variables(codeline * c);

void yyerror(char *); 
int  yylex(void);
int  yyparse();

int counter;
int scope ;
int yyleng;
char * yytext;
int assign_type;
codeline v;

#endif //__FCOMP_H__
