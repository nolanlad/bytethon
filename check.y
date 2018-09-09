%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	#include <string.h>
    #include "fcomp.h"
%}

%token DOUBLE INT BOOL ASSIGN OP TYPE CPAREN OPAREN COMMA NEWLINE IF COMP EQ NUM COLON DEF RETURN EOS

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
           line.eltype = VARASSN;
       }
       else{
           line.eltype = VARINIT;
       }
   }
   | args ASSIGN expression{ 

       line.token_list = token_block;
       line.r_type     = assign_type;
       line.eltype = VARINIT;
   }
   | DEF VAR OPAREN CPAREN COLON {
 
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
   }
   | DEF VAR OPAREN args CPAREN COLON   { 

       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
   }
   | NEWLINE { 
          if(line.eltype == VARINIT){
              variable varb = get_variables(&line);
              varb.scope = scope;
              append(var_table,varb);
          }
          if(prev_scope > scope) printf("}\n");
          print_code(&line);  
          line.eltype = WHITESPACE;
          line.token_list = token_block;
          reset();                 
   }
   | IF expression            { printf("If block\n");    }
   | RETURN expression {
          line.token_list = token_block;
          line.eltype = RET;
   }
   | expression { printf("func call\n"); }
   | EOS {return 0;}
   ;
args:
    VAR
   | number
   | args COMMA VAR
   | args COMMA number
   ;
expression:
   number 
   | func_call
   | expression OP func_call
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
func_call:
   VAR OPAREN args CPAREN
   | VAR OPAREN CPAREN
   ;
%%

extern FILE *yyin;
int main()
{
 counter = 0;
 scope = 0;
 prev_scope = 0;
 token_block = new_block_token();
 var_table   = new_block_variable();
 func_table  = new_block_function();
 
 
 do{    yyparse();   }
 while (!feof(yyin));
 
 printf(" /* functions defined:\n");
 for(int i = 0; i < len(func_table); ++i)
 {
     function F = getter(func_table,i);
     printf("%s ",F.func_name.text);
     printf("args = ( ");
     for(int j = 0; j < len(F.args); ++j)
     {
         variable V = getter(F.args,j);
         printf("%s ", V.var_name.text);
     }
     printf(")\n");
 }
 printf("*/\n");
}
void yyerror(char *s)
{

   fprintf(stderr, "%s\n", s);
}
