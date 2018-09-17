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

%}

%token DOUBLE INT BOOL ASSIGN OP TYPE CPAREN OPAREN COMMA NEWLINE IF COMP EQ NUM COLON DEF RETURN EOS ARROW FOR IN RANGE

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
    //    if(varible_is_def(&line)) {
    //        line.eltype = VARASSN;
    //    }
    //    else{
    //        line.eltype = VARINIT;
    //    }
       
       if(scope > 0){
        //    element e;
        //    e.scope = scope;
           assignment aas =get_assignment(&line);
           append(assns,aas);
        //    e.el = malloc(sizeof(assignment));
        //    memmove(e.el,&aas,sizeof(assignment));
           append_element(aas,assignment);
           if(varible_is_def2(aas.var)) {
               e.ct = VARASSN;
           }
           else {
               e.ct = VARINIT;
           }
        //    append(els,e);
           append(var_table2,aas.var);
       }
       
   }
   | FOR VAR IN RANGE OPAREN args CPAREN COLON { 
    //    block_num++;
       line.token_list = token_block;
       line.eltype = FORBLOCK;
       iterator it = get_range(&line); 
    //    element e;
    //    e.scope = scope;
    //    e.el = malloc(sizeof(iterator));
    //    memmove(e.el, &it, sizeof(iterator) );
       append_element(it,iterator);
       e.ct = FORBLOCK;
    //    append(els,e);
    }
   | args ASSIGN expression{ 

       line.token_list = token_block;
       line.r_type     = assign_type;
       line.eltype     = VARINIT;
   }
   | DEF VAR OPAREN CPAREN COLON {
 
       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
    //    element e;
    //    e.scope = scope;
    //    e.el = malloc(sizeof(function));
    //    memmove(e.el, &F, sizeof(function) );
       append_element(F,function);
       e.ct = FUNCDEF;
    //    append(els,e);
   }
   | DEF VAR OPAREN args CPAREN COLON   { 

       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_function(&line);
       append(func_table,F);
    //    element e;
    //    e.scope = scope;
    //    e.el = malloc(sizeof(function));
    //    memmove(e.el, &F, sizeof(function) );
       append_element(F,function);
       e.ct = FUNCDEF;
    //    append(els,e);
   }
   | DEF VAR OPAREN targs CPAREN ARROW VAR COLON  { 

       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_typed_function(&line);
       append(func_table,F);
    //    element e;
    //    e.scope = scope;
    //    e.el = malloc(sizeof(function));
    //    memmove(e.el, &F, sizeof(function) );
       append_element(F,function);
       e.ct = FUNCDEF;
    //    append(els,e);
   }
   | DEF VAR OPAREN CPAREN ARROW VAR COLON  { 

       block_num++;
       line.token_list = token_block;
       line.eltype = FUNCDEF;
       function F = get_typed_function(&line);
       append(func_table,F);
    //    element e;
    //    e.scope = scope;
    //    e.el = malloc(sizeof(function));
    //    memmove(e.el, &F, sizeof(function) );
       append_element(F,function);
       e.ct = FUNCDEF;
    //    append(els,e);
   }
   | NEWLINE { 
        //   if(line.eltype == VARINIT){
        //       variable varb = get_variables(&line);
        //       varb.scope = scope;
        //       append(var_table,varb);
        //   }
          if(prev_scope > scope){
            //   element e;
            for(int k = prev_scope; k > scope; k-- ){
              endel.scope = scope;
              append(els,endel);
            }
            //   append(els,e);
            //   e.ct = ENDBLOCK;
            //   e.scope = scope;
            //   append(els,e);
          } 
          append(els,e);
          e.ct = WHITESPACE;
          line.eltype = WHITESPACE;
          line.token_list = token_block;
          reset();                 
   }
    | RETURN expression {
        line.token_list = token_block;
        line.eltype = RET;
        // element e;
        // e.scope = scope;
        assignment aas = get_return(&line);
        append(assns,aas);
        // e.el = malloc(sizeof(assignment));
        // memmove(e.el, &aas, sizeof(assignment) );
        append_element(aas,assignment);
        e.ct = RETURN;
        // append(els,e);
   }
   ;
   | IF expression COLON           { printf("If block\n");    }
   | expression { printf("func call\n"); }
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
    block_num = 0;
    endel.ct = ENDBLOCK;
    token_block = new_block_token();
    //var_table   = new_block_variable();
    var_table2   = new_block_variable2();
    func_table  = new_block_function();
    els         = new_block_element();
    assns       = new_block_assignment();

    do{    
        yyparse();  
    }
    while (!feof(yyin));
 
    int pscp = 0;
    int scp  = 0;
    for(int j = 0; j < len(els); ++j){

        int type = getter(els,j).ct;
        pscp = scp;
        scp = getter(els,j).scope;
        // if(pscp > scp) {
        //     for(int k = 0;k<scp;++k) printf("\t");
        //     printf("}\n");
        // }
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
            case ENDBLOCK:
                c_print_scope(scp-1);
                //for(int k = 0;k<scp;++k) printf("\t");
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
