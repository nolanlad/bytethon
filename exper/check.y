%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>

   int yylex(void);
   int yyleng;
   char * yytext;
   int assign_type;
void yyerror(char *s);
   

%}

%token DOUBLE INT BOOL ASSIGN OP TYPE CPAREN OPAREN 
%token COMMA NEWLINE IF COMP EQ NUM COLON DEF RETURN 
%token EOS ARROW FOR IN RANGE WHILE CLASS INDENT

%union {
  char *s;
}

%token<s> VAR


%%
assignments: assignment assignments
   | assignment
   ;
assignment: 
   VAR ASSIGN expression    { 
       printf("variable\n");
       
   }
   | CLASS VAR COLON {
       printf("class\n");
   }
   | FOR VAR IN RANGE OPAREN args CPAREN COLON { 
       printf("for loop\n");
       
    }
   | IF expression COLON {
       printf("if block\n");
       
   }
   | WHILE expression COLON {
       printf("while block\n");
   }

   | DEF VAR OPAREN CPAREN COLON {
       printf("func def\n");
   }
   | DEF VAR OPAREN args CPAREN COLON   { 
       printf("func def\n");
   }
   | DEF VAR OPAREN targs CPAREN ARROW VAR COLON  { 
       printf("func def\n");
   }
   | DEF VAR OPAREN CPAREN ARROW VAR COLON  { 
       printf("func def\n");
    
   }
   | NEWLINE { 
       printf("newline\n");           
   }
    | RETURN expression {
        printf("return\n");
   }
    | tabs{
        printf("indent ");
   }
   ;
   | EOS {return 0;}
   ;
args:
    VAR
   | number
   | args COMMA VAR
   | args COMMA number
   ;
targs:
    VAR COLON VAR
   | targs COMMA VAR COLON VAR
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
   DOUBLE { printf("double "); }
   | INT  { printf("int "); }
   | BOOL { printf("bool "); }
   | DOUBLE COMMA number
   ;
func_call:
   VAR OPAREN args CPAREN
   | VAR OPAREN CPAREN
   ;
tabs:
   INDENT
   | INDENT tabs
   ;
%%

extern FILE *yyin;
int main()
{
    
 //   counter = 0;
/*
    scope = 0;
    prev_scope = 0;
    block_num = 0;
    endel.ct = ENDBLOCK;
    token_block = new_block_token();
    var_table2  = new_block_variable2();
    func_table  = new_block_function();
    els         = new_block_element();
    assns       = new_block_assignment();
*/
    do{    
        yyparse();  
    }
    while (!feof(yyin));
/*
    printf("\n");
    int pscp = 0;
    int scp  = 0;
    for(int j = 0; j < len(els); ++j){

        int type = getter(els,j).ct;
        pscp = scp;
        scp = getter(els,j).scope;
        for(int k = 0;k<scp;++k) printf("\t");
        switch(type){
            function F;
            case FUNCDEF:
                F = *(function*)(getter(els,j).el);
                c_func_def(F);
                break;
            assignment a;
            case VARINIT:
                a = *(assignment*)(getter(els,j).el);
                c_var_init(a);
                break;
            case VARASSN:
                a = *(assignment*)(getter(els,j).el);
                c_var_assn(a);
                break;
            case RETURN:
                a = *(assignment*)(getter(els,j).el);
                c_return(a);
                break;
            case FORBLOCK:
                c_print_scope(scope);
                iterator it = *(iterator*)(getter(els,j).el);
                c_for_loop(it);
                break;
            case IFBLOCK:
                c_print_scope(scope);
                ifwhile iff = *(ifwhile*)(getter(els,j).el);
                c_if(iff);
                break;
            case WHILEBLOCK:
		        c_print_scope(scope);
		        ifwhile whi = *(ifwhile*)(getter(els,j).el);
                c_while(whi);
                break;
	    case ENDBLOCK:
                c_print_scope(scp-1);
                printf("}\n");
                break;
            case WHITESPACE:
                printf("\n");
                break;
        }
    }  
*/
}

    
void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}
