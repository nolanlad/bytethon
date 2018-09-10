#ifndef __FCOMP_H__
#define __FCOMP_H__
#include <stdio.h>
#include "y.tab.h"
#include "blocks/static_blocks.h"


typedef struct blocked_token     * tblock;
typedef struct blocked_variable  * varblock;
typedef struct blocked_variable2 * varblock2;
typedef struct blocked_function  * funcblock;

typedef enum {
    VARINIT,
    FUNCDEF,
    RET,
    VARASSN,
    WHITESPACE,
    IFBLOCK,
    FORBLOCK,
    WHILEBLOCK,
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

typedef struct {
    token var_name;
    int scope;
    int r_type;
} variable2;

typedef struct {
    variable2 var;
    tblock expr;
} assignment;

typedef struct {
    token func_name;
    int r_type;
    varblock2 args;
} function;



/**********************************
 *  Super abstract code holder    *
 **********************************/

typedef struct {
    void * el;
    codetype ct;
} element;

dynamic_block(token);
dynamic_block(variable);
dynamic_block(variable2);
dynamic_block(function);
tblock token_block;
varblock var_table;
funcblock func_table;

void set_token(  int id, int sid  );
void print_code(  codeline  * v  );
void var_init_c(  codeline  * v  );
void reset();
void set_token(  int id, int sid   );

variable    get_variables(  codeline * c  );
function    get_function (  codeline * c  );
assignment get_assignment(  codeline * c  );
bool varible_is_def   (  codeline * c  );

bool cmpchararr(  char * one, char * other  );

void yyerror( char * ); 
int  yylex( void );
int  yyparse();

int counter;
int scope ;
int prev_scope ;


int yyleng;
char * yytext;
int assign_type;
codeline line;

element el;

#endif //__FCOMP_H__
