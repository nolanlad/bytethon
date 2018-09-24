%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>
    #include "fcomp.h"
    #include "utilities.h"

    #define append_element(ell,elt) \
        e.scope = scope; \
        e.el = malloc(sizeof(elt));\
        memmove(e.el, &ell, sizeof(elt) );

    #define append_element2(ep,ell,elt) \
        ep->scope = scope; \
        ep->el = malloc(sizeof(elt));\
        memmove(ep->el, &ell, sizeof(elt) );

    #define append_element3(ep,ell,elt) \
        ep->scope = scope; \
        ep->el = malloc(sizeof(elt));\
        memmove(ep->el, &ell, sizeof(elt) );\
        append(els,(*ep));

    #define append_element4(ells,ell,elt) \
        element * ep = &e;\
        ep->scope = scope; \
        ep->el = malloc(sizeof(elt));\
        memmove(ep->el, &ell, sizeof(elt) );\
        append(ells,(*ep));

    #define is_end_block()\
        if(prev_scope > scope){\
            for(int k = prev_scope; k > scope; k-- ){\
              endel.scope = scope;\
              append(els,endel);\
            }\
          } 

%}

%token DOUBLE INT BOOL ASSIGN OP TYPE CPAREN OPAREN 
%token COMMA NEWLINE IF COMP EQ NUM COLON DEF RETURN 
%token EOS ARROW FOR IN RANGE WHILE CLASS

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
       is_end_block();
       line.token_list = token_block;
       line.r_type     = assign_type;
       
       if(scope > 0){
           assignment aas =get_assignment(&line);
           append(assns,aas);
           if(varible_is_def2(aas.var)) {
               e.ct = VARASSN;
           }
           else {
               e.ct = VARINIT;
           }
           append_element4(els,aas,assignment);
           e.ct = WHITESPACE;
           append(var_table2,aas.var);
       }
       
   }
   | CLASS VAR COLON {
       block_type = CLASS;
       line.token_list = token_block;
       line.eltype = FORBLOCK;
       e.ct = WHITESPACE;
       append(els,e);
   }
   | FOR VAR IN RANGE OPAREN args CPAREN COLON { 
       block_type = FORBLOCK;
       is_end_block();
       line.token_list = token_block;
       line.eltype = FORBLOCK;
       iterator it = get_range(&line); 
       e.ct = FORBLOCK;
       append_element4(els,it,iterator);
       
    }
   | IF expression COLON {
       is_end_block();
       line.token_list = token_block;
       line.eltype = FORBLOCK;
       ifwhile iff = get_ifwhile(&line);
       e.ct = IFBLOCK;
       append_element4(els,iff,ifwhile);
       
   }
   | WHILE expression COLON {
       is_end_block();
       line.token_list = token_block;
       line.eltype = WHILEBLOCK;
       ifwhile iff = get_ifwhile(&line);
       e.ct = WHILEBLOCK;
       append_element4(els,iff,ifwhile);
   }
   | args ASSIGN expression{ 

       line.token_list = token_block;
       line.r_type     = assign_type;
       line.eltype     = VARINIT;
   }
   | DEF VAR OPAREN CPAREN COLON {
       is_end_block();
       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
       e.ct = FUNCDEF;
       append_element4(els,F,function);
   }
   | DEF VAR OPAREN args CPAREN COLON   { 
       is_end_block();
       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
       element * ep = &e;
       e.ct = FUNCDEF;
       append_element3(ep,F,function);
   }
   | DEF VAR OPAREN targs CPAREN ARROW VAR COLON  { 
       is_end_block();
       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_typed_function(&line);
       append(func_table,F);
       element * ep = &e;
       e.ct = FUNCDEF;
       append_element3(ep,F,function);
   }
   | DEF VAR OPAREN CPAREN ARROW VAR COLON  { 
       is_end_block();
       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_typed_function(&line);
       append(func_table,F);
       element * ep = &e;
       e.ct = FUNCDEF;
       append_element3(ep,F,function);
    
   }
   | NEWLINE { 
        // is_end_block();
          e.ct = WHITESPACE;
          line.eltype = WHITESPACE;
          line.token_list = token_block;
          reset();                 
   }
    | RETURN expression {
        is_end_block();
        line.token_list = token_block;
        line.eltype = RET;
        assignment aas = get_return(&line);
        append(assns,aas);
        element * ep = &e;
        e.ct = RETURN;
        append_element3(ep,aas,assignment);
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
   DOUBLE { assign_type = DOUBLE; }
   | INT  { assign_type = INT; }
   | BOOL { assign_type = BOOL; }
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
    block_num = 0;
    endel.ct = ENDBLOCK;
    token_block = new_block_token();
    var_table2  = new_block_variable2();
    func_table  = new_block_function();
    els         = new_block_element();
    assns       = new_block_assignment();

    do{    
        yyparse();  
    }
    while (!feof(yyin));
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
}
    
void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}
