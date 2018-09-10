#include "fcomp.h"

/* defines functions for manipulating Token_block  */
dynamic_block_funcs(token);
dynamic_block_funcs(variable);
dynamic_block_funcs(variable2);
dynamic_block_funcs(function);
/* */


void set_token(int id, int sid){
   token t;
   t.id = id; 
   t.sid = sid;
   t.text = (char*)malloc(sizeof(char)*(yyleng+1));
   strcpy(t.text,yytext);
   setter(token_block,counter++,t);
}

void print_block(tblock block){
   for(int i=0; i< block->length; ++i){
      token t = getter(block,i);
   }
}

void var_init_c(codeline * line){
    bool expr = false;
    if( line->eltype == VARINIT){
        if(line->r_type == DOUBLE)
            printf("double ");
        else
            printf("int ");
    }
    for(int i =0; i< (line->token_list)->length; ++i){
        token _t = getter(line->token_list,i);
        if(_t.id == COMMA && !expr)
            printf(" , ");
        if(expr && _t.id != NEWLINE)
            printf("%s",_t.text);
        if(_t.id == VAR && !expr)
            printf("%s",_t.text);
        if(_t.id == ASSIGN){
            printf(" = ");
            expr = true;
        }
        
    }
    printf(";\n");
}

void ret_c(codeline * line){
    for(int i =0; i< len(line->token_list)-1; ++i){
         token _t = getter(line->token_list,i);
         printf("%s ",_t.text);
    }
    printf(";\n");
}



void func_def_c(codeline * line){
    for(int i = 1; i < len(line->token_list) -2; ++i){
        if(getter( line->token_list , i ).id == VAR )
          printf("double ");
          printf("%s ",  getter( line->token_list , i ).text);
    }
    printf("{\n");
}


void print_code(codeline  * line){
    for(int i = 0; i < scope; ++i) printf("\t");
    if(line->eltype == VARINIT || line->eltype == VARASSN){
        var_init_c(line);
        return;
    }
    if (line->eltype == FUNCDEF){
        func_def_c(line);
        return;
    }
    if (line->eltype == RET){
        ret_c(line);
        return;
    }
    printf("\n");
}

void reset(){
    token_block = new_block_token();
    counter = 0;
    prev_scope = scope;
    scope = 0;
}

//TODO: only works with form b = expr, no m,n = expr
variable get_variables(codeline * c){
    variable v ;
    tblock expr = new_block_token();
    v.var_name = getter(c->token_list,0);
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
    v.r_type = assign_type;
    v.scope = scope;
    assn.var = v;
    assn.expr = new_block_token();
    for(int i = 2; i < len(c->token_list); ++i){
        append(assn.expr,getter(c->token_list,i));
    }
    return assn;
} 



function get_function(codeline * c){
    function F;
    varblock2 args = new_block_variable2();
    F.func_name = getter(c->token_list,1);
    for(int i = 3; i < len(c->token_list); ++i)
    {
        token tok = getter(c->token_list , i);
        if(tok.id == CPAREN) break;
        if(tok.id == VAR) 
        {
            variable2 V;
            V.var_name = tok;
            V.scope = 1;
            V.r_type = DOUBLE;
            append(args, V); 
        }
    }
    F.args = args;
    F.r_type = DOUBLE;
    return F;
}

bool cmpchararr(char * one, char * other){
    bool exists = true;
    int n = 0;
    while(*(one) && *(other))
        if(*(one++) != *(other++))
            return false;
        
    return true;
}
    

bool varible_is_def(  codeline * c  ){  
    token var_name = getter(c->token_list,0);
    for(int i = 0; i < len(var_table); ++i){
        char * one = getter(var_table,i).var_name.text;
        char * other = var_name.text;
        if(cmpchararr(one,other)) return true;
    }
    return false;
}

    
         




