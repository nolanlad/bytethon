#ifndef __FCOMP_H__
#define __FCOMP_H__
#include <stdio.h>
#include "y.tab.h"
#include "blocks/static_blocks.h"


typedef struct blocked_token     * tblock;
typedef struct blocked_variable2 * varblock2;
typedef struct blocked_function  * funcblock;
typedef struct blocked_element   * elblock;
typedef struct blocked_assignment* asblock;

typedef enum {
    VARINIT,
    FUNCDEF,
    RET,
    VARASSN,
    WHITESPACE,
    IFBLOCK,
    FORBLOCK,
    WHILEBLOCK,
    ENDBLOCK
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
    int scope;
    int r_type;
    int block_num;
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

typedef struct {
    token start;
    token stop;
    token step;
    token counter;
} iterator;

typedef struct {
    tblock expr;
} ifwhile;

/**********************************
 *  Super abstract code holder    *
 **********************************/

typedef struct {
    void * el;
    codetype ct;
    bool is_block_start;
    elblock theblock;
    int scope;
} element;

dynamic_block(token);
dynamic_block(variable2);
dynamic_block(function);
dynamic_block(element);
dynamic_block(assignment);

tblock token_block;
varblock2 var_table2;
funcblock func_table;
elblock els;
asblock assns;

void print_code(  codeline  * v  );
void var_init_c(  codeline  * v  );
void c_func_def(function F);
void c_var_init(assignment A);
void c_var_assn(assignment A);
void c_return(assignment A);
void c_print_scope(int scope);
void c_for_loop(iterator it);
void c_if(ifwhile iff);
void c_while(ifwhile iff);

void yyerror( char * ); 
int  yylex( void );
int  yyparse();

int counter;
int scope;
int block_num;
int prev_scope;

int yyleng;
char * yytext;
int assign_type;
codeline line;
element el;
element e;
element endel;

#endif //__FCOMP_H__
