#include "fcomp.h"
#include "utilities.h"

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