#include "fcomp.h"
#include "utilities.h"

/* defines functions for manipulating Token_block  */
dynamic_block_funcs(token);
dynamic_block_funcs(variable);
dynamic_block_funcs(variable2);
dynamic_block_funcs(function);
dynamic_block_funcs(element);
dynamic_block_funcs(assignment);



bool cmpchararr(char * one, char * other){
    bool exists = true;
    int n       = 0;
    while(*(one) && *(other))
        if(*(one++) != *(other++))
            return false;
        
    return true;
}

void set_token(int id, int sid){
   token t;
   t.id   = id; 
   t.sid  = sid;
   t.text = (char*)malloc(sizeof(char)*(yyleng+1));
   strcpy(t.text,yytext);
   setter(token_block,counter++,t);
}

void reset(){
    token_block = new_block_token();
    counter     = 0;
    prev_scope  = scope;
    scope       = 0;
}

//TODO: only works with form b = expr, no m,n = expr1,expr2
variable get_variables(codeline * c){
    variable v ;
    tblock expr = new_block_token();
    v.var_name  = getter(c->token_list,0);
    int  i;
    for(i=2; i < len(c->token_list)-1; ++i) 
    {
        append(expr,getter(c->token_list,i));
    }
    return v;
} 

assignment get_assignment(codeline * c){
    variable2 v ;
    assignment assn;
    v.var_name = getter(c->token_list,0);
    v.r_type   = assign_type;
    v.scope    = scope;
    assn.var   = v;
    assn.expr  = new_block_token();
    for(int i = 2; i < len(c->token_list); ++i){
        append(assn.expr,getter(c->token_list,i));
    }
    return assn;
} 


assignment get_return(codeline * c){
    variable2 v ;
    assignment assn;
    v.var_name = getter(c->token_list,0);
    v.r_type   = assign_type;
    v.scope    = scope;
    assn.var   = v;
    assn.expr  = new_block_token();
    for(int i = 1; i < len(c->token_list); ++i){
        append(assn.expr,getter(c->token_list,i));
    }
    return assn;
} 


function get_function(codeline * c){
    function F;
    varblock2 args = new_block_variable2();
    F.func_name    = getter(c->token_list,1);
    for(int i = 3; i < len(c->token_list); ++i)
    {
        token tok = getter(c->token_list , i);
        if(tok.id == CPAREN) break;
        if(tok.id == VAR) 
        {
            variable2 V;
            V.var_name = tok;
            V.scope    = 1;
            V.r_type   = DOUBLE;
            append(args, V); 
        }
    }
    F.args   = args;
    F.r_type = DOUBLE;
    return F;
} 

bool varible_is_def(  codeline * c  ){  
    token var_name = getter(c->token_list,0);
    for(int i = 0; i < len(var_table); ++i)
    {
        char * one   = getter(var_table,i).var_name.text;
        char * other = var_name.text;

        if(cmpchararr(one,other)) return true;
    }
    return false;
}