%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
        #include "fcomp.h"
%}

%token DOUBLE INT BOOL ASSIGN OP TYPE CPAREN OPAREN COMMA NEWLINE IF COMP EQ NUM COLON DEF

%union {
  char *s;
}

%token<s> VAR



%%
assignments: assignment assignments
   | assignment
   ;
assignment: 
   TYPE VAR ASSIGN expression { printf("Assignment.\n"); }
   | VAR ASSIGN expression    { printf("var assign\n");

       v.token_list = token_block;
       v.r_type     = assign_type;
       v.eltype = VARINIT;
   }
   | args ASSIGN expression{ printf("var assign\n");

       v.token_list = token_block;
       v.r_type     = assign_type;
       v.eltype = VARINIT;
   }
   | DEF VAR OPAREN args CPAREN COLON   { printf("Func def\n"); 

       v.token_list = token_block;
       v.eltype = FUNCDEF;
   }
   | VAR                      { printf("Func def\n");    }
   | NEWLINE{ 
          //print_code(&v);
          if(v.eltype == VARINIT){
              variable varb = get_variables(&v);
              varb.scope = scope;
          }
              
          reset();                 
   }
   | IF expression            { printf("If block\n");    }
   ;
args:
    VAR
   | args COMMA VAR
   ;
expression:
   number 
   | expression OP number
   | OPAREN expression CPAREN
   ;
number:
   DOUBLE { assign_type = DOUBLE; }
   | INT  { assign_type = INT; }
   | BOOL 
   | DOUBLE COMMA number
   ;
%%

extern FILE *yyin;
int main()
{
 counter = 0;
 scope = 0;
 token_block = new_block_token();
 var_table   = new_block_variable();

 do{    yyparse();   }
 while (!feof(yyin));
 
}
void yyerror(char *s)
{

   fprintf(stderr, "%s\n", s);
}
