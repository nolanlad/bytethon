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
   | VAR ASSIGN expression    { 

       line.token_list = token_block;
       line.r_type     = assign_type;
       if(varible_is_def(&line)) {
           printf("variable assign\n");
           line.eltype = VARASSN;
       }
       else{
           printf("variable init\n");
           line.eltype = VARINIT;
       }
   }
   | args ASSIGN expression{ printf("var assign\n");

       line.token_list = token_block;
       line.r_type     = assign_type;
       line.eltype = VARINIT;
   }
   | DEF VAR OPAREN args CPAREN COLON   { printf("Func def\n"); 

       line.token_list = token_block;
       line.eltype = FUNCDEF;
   }
   | VAR                      { printf("Func def\n");    }
   | NEWLINE{ 
          if(line.eltype == VARINIT){
              variable varb = get_variables(&line);
              varb.scope = scope;
              append(var_table,varb);
          }
          print_code(&line);  
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
   | VAR
   | expression OP VAR
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
 
 if(cmpchararr("this","that")) printf("JJJ\n"); 
 
 do{    yyparse();   }
 while (!feof(yyin));
 
}
void yyerror(char *s)
{

   fprintf(stderr, "%s\n", s);
}
