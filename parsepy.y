%{
	#include <stdio.h>
       
        int yyerror(char *s);
        int yylex();
        int scope;
        int md_temp_num;
        int as_temp_num;
        int is_first_add;
        int is_first_mul;
        int mul_temp1;
        int mul_temp2;
        int add_temp1;
        int add_temp2;
        typedef struct{
            int le;
            int re;
        } expr;

        expr e;

        void start_first_add();
        void start_first_mul();
%}

%token INDENT DEF IF VAR OP ASSIGN OPAREN CPAREN COLON NEWLINE
%token ADD SUB MUL DIV EQ LT GT LE GE NE
%token<du> INT DOUBLE

%union {
	double du;
}

%type<du> number

%%
final:
    thing
    | thing final
    ;
thing:
    assign
    | func_def
    | indents thing
    ; 
assign:
    VAR ASSIGN number { printf("assign\n");}
    | VAR ASSIGN expression { printf("assign\n");}
    ;
number:
    DOUBLE {  $$ = $1; /* printf("Double %f ",e.le);*/}
    | INT  {  $$ = $1;  /*printf("Int ");*/}
    ;
indents:
    INDENT { printf("indent\n");}
    | INDENT indents  { printf("indents\n");}
    ;
func_def:
    DEF VAR OPAREN CPAREN COLON	 { printf("func def\n"); }
    ; 

expression:
    muldiv
    | addsub 
    ;
muldiv:
    | number DIV number { 
          start_first_mul(); 
          mul_temp2 = md_temp_num;
          printf("%%md%d = div nsw i32  %f, %f\n",md_temp_num++,$1,$3); 
    }
    | number MUL number { 
          start_first_mul(); 
          mul_temp2 = md_temp_num;
          printf("%%md%d = mul nsw i32  %f, %f\n",md_temp_num++,$1,$3);
    }
    | muldiv MUL number {
           start_first_mul();  
           mul_temp2 = md_temp_num;
           printf("%%md%d = mul nsw i32  %%md%d, %f\n",md_temp_num,md_temp_num-1,$3); ++md_temp_num;
    }
    | muldiv DIV number { 
           start_first_mul(); 
           mul_temp2 = md_temp_num;
           printf("%%md%d = div nsw i32  %%md%d, %f\n",md_temp_num,md_temp_num-1,$3); ++md_temp_num;
    }
    ;
addsub:
    number ADD number { printf("Add %f %f \n",$1,$3); }
    | number SUB number { printf("Sub %f %f \n",$1,$3); }
    | muldiv ADD muldiv { 
          start_first_add(); 
          add_temp2 = as_temp_num;
          printf("%%as%d = add nsw %%md%d, %%md%d\n",
                 as_temp_num++, mul_temp1, mul_temp2); 
    }
    | muldiv ADD number { printf("Add temp1 %f \n",$3); }
    | muldiv SUB number { printf("Add temp1 %f \n",$3); }
    | addsub ADD number { printf("Add temp1 %f \n",$3); }
    | addsub SUB number { printf("Sub temp2 %f \n",$3); }
    | muldiv SUB muldiv { printf("Sub mul1 mul2 \n"); }
    | addsub ADD addsub { 
          
          add_temp2 = as_temp_num;
          printf("%%as%d = add nsw as%d, as%d\n",
                 as_temp_num++,add_temp1,add_temp2); 
    }
    | addsub SUB addsub { printf("Sub add1 add2\n"); }
    | addsub ADD muldiv { 
          
          add_temp2 = as_temp_num;
          printf("%%as%d = add nsw %%as%d, %%md%d\n",as_temp_num++,add_temp1, mul_temp1); }
    ;
%%

extern FILE *yyin;

void start_first_add(){
   if(is_first_add){
      is_first_add = 0;
      is_first_mul = 1;
      add_temp1 = as_temp_num;
   }
}
   

void start_first_mul(){
   if(is_first_mul){
      mul_temp1 = md_temp_num;
      is_first_mul = 0;
      is_first_add = 1;
   }
}   

int main()
{
        scope = 0;
        md_temp_num = 1;
        as_temp_num = 1;
        is_first_add = 1;
        is_first_mul = 1;
	do {
		yyparse();
	}while(!feof(yyin));
}

int yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}
