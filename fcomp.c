#include "fcomp.h"

/* defines functions for manipulating Token_block  */
dynamic_block_funcs(token);
dynamic_block_funcs(variable);
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

void print_code(codeline  * line){
    if(line->eltype == VARINIT || line->eltype == VARASSN)
        var_init_c(line);
    else
        printf("unimplemented code type\n");
}

void reset(){
    token_block = new_block_token();
    counter = 0;
    scope = 0;
}

//TODO: only works with form b = expr, no m,n = expr
variable get_variables(codeline * c){
    variable v ;
    tblock expr = new_block_token();
    v.var_name = getter(c->token_list,0);
    int  i;
    for(i=2; i < len(c->token_list)-1; ++i){
        append(expr,getter(c->token_list,i));
        printf("%s ", getter(c->token_list,i).text);
        
    }
    printf("\n");
    return v;
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
    
         




