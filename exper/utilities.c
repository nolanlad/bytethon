#include "fcomp.h"
#include "utilities.h"

/* defines functions for manipulating Token_block  */
dynamic_block_funcs(token);
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
    return *(one) == *(other);
        
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

assignment get_assignment(codeline * c){
    variable2 v ;
    assignment assn;
    v.var_name = getter(c->token_list,0);
    v.r_type   = assign_type;
    v.scope    = scope;
    v.block_num= block_num;
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
            append(var_table2,V);
        }
    }
    F.args   = args;
    F.r_type = DOUBLE;
    return F;
} 

function get_typed_function(codeline * c){
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
            i+=2;
            token ty = getter(c->token_list , i);
            if(ty.id == VAR){
                if(cmpchararr(ty.text,"int")){
                    V.r_type = INT;
                }
                if(cmpchararr(ty.text,"float")){
                    V.r_type = DOUBLE;
                }
                if(cmpchararr(ty.text,"bool")){
                    V.r_type = BOOL;
                }
                if(cmpchararr(ty.text,"bool")){
                    V.r_type = TYPE;
                }
                
                append(args, V);
                append(var_table2,V);
            }
            else{
                printf("/* type is all boned up */\n");
                V.r_type   = DOUBLE;
            }
        }
    }
    F.args   = args;
    token tok = getter(c->token_list , len(c->token_list)-2);
    if(cmpchararr(tok.text,"int")){
        F.r_type = INT;
    }
    if(cmpchararr(tok.text,"float")){
        F.r_type = DOUBLE;
    }
    if(cmpchararr(tok.text,"bool")){
        F.r_type = BOOL;
    }
    return F;
} 

ifwhile get_ifwhile(codeline * c){
    ifwhile out;
    out.expr = new_block_token();
    for(int i = 1; i < len(c->token_list);++i){
        append(out.expr, getter(c->token_list,i) );
    }
    return out;
}

bool varible_is_def(  codeline * c  ){  
    token var_name = getter(c->token_list,0);
    for(int i = 0; i < len(var_table2); ++i)
    {
        char * one   = getter(var_table2,i).var_name.text;
        char * other = var_name.text;

        if(cmpchararr(one,other)) return true;
    }
    return false;
}

bool varible_is_def2(  variable2 v  ){  
    token var_name = v.var_name;
    for(int i = 0; i < len(var_table2); ++i)
    {
        char * one   = getter(var_table2,i).var_name.text;
        char * other = var_name.text;
        if(cmpchararr(one,other)) {
            if(getter(var_table2,i).block_num == v.block_num){
                return true;
            }
        }
    }
    return false;
}

iterator get_range(  codeline * c  )
{
    iterator it;
    token default_start;
    default_start.id = NUM; 
    default_start.sid = INT; 
    default_start.text = "0";
    token default_step;
    default_step.id = NUM; 
    default_step.sid = INT; 
    default_step.text = "1";
    token var_name = getter(c->token_list,1);
    it.counter = var_name;
    int i = 5;
    if(getter(c->token_list,i+1).id == COMMA){
        it.start = getter(c->token_list,i);
        it.stop = getter(c->token_list,i+2);
        if( getter(c->token_list,i+3).id == COMMA){
            it.step = getter(c->token_list,i+4);
        }
        else
            it.step  = default_step;
    }
    else{
        it.stop  = getter(c->token_list,i);
        it.start = default_start;
        it.step  = default_step;
    }
    return it;
}
