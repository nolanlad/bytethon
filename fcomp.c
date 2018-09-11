#include "fcomp.h"
#include "utilities.h"

// void print_block(tblock block){
//    for(int i=0; i< block->length; ++i){
//       token t = getter(block,i);
//    }
// }

// void var_init_c(codeline * line){
//     bool expr = false;
//     if( line->eltype == VARINIT){
//         if(line->r_type == DOUBLE)
//             printf("double ");
//         else
//             printf("int ");
//     }
//     for(int i =0; i< (line->token_list)->length; ++i){
//         token _t = getter(line->token_list,i);
//         if(_t.id == COMMA && !expr)
//             printf(" , ");
//         if(expr && _t.id != NEWLINE)
//             printf("%s",_t.text);
//         if(_t.id == VAR && !expr)
//             printf("%s",_t.text);
//         if(_t.id == ASSIGN){
//             printf(" = ");
//             expr = true;
//         }
        
//     }
//     printf(";\n");
// }

// void ret_c(codeline * line){
//     for(int i =0; i< len(line->token_list)-1; ++i){
//          token _t = getter(line->token_list,i);
//          printf("%s ",_t.text);
//     }
//     printf(";\n");
// }



// void func_def_c(codeline * line){
//     for(int i = 1; i < len(line->token_list) -2; ++i){
//         if(getter( line->token_list , i ).id == VAR )
//           printf("double ");
//           printf("%s ",  getter( line->token_list , i ).text);
//     }
//     printf("{\n");
// }


// void print_code(codeline  * line){
//     for(int i = 0; i < scope; ++i) printf("\t");
//     if(line->eltype == VARINIT || line->eltype == VARASSN){
//         var_init_c(line);
//         return;
//     }
//     if (line->eltype == FUNCDEF){
//         func_def_c(line);
//         return;
//     }
//     if (line->eltype == RET){
//         ret_c(line);
//         return;
//     }
//     printf("\n");
// }

void c_print_scope(int scope){
    for(int i = 0; i < scope; ++i){
        printf("\t");
    }
}

void c_print_var(variable2 V){
    if(V.r_type == DOUBLE){
        printf("double ");
    }
    if(V.r_type == INT){
        printf("int ");
    }
    if(V.r_type == BOOL){
        printf("bool ");
    }
    printf("%s ",V.var_name.text);
}


void c_print_expr(tblock ex){
    for(int i = 0; i < len(ex)-1; ++i){
        printf("%s ",getter(ex,i).text);
    }
}

void c_func_def(function F){
    printf("double ");
    printf("%s",F.func_name.text);
    printf("( ");

    if(len(F.args) != 0){
        for(int i =0; i < len(F.args) -1; ++i){
            c_print_var(getter(F.args,i)); printf(", ");
        }
        printf("double %s ",getter(F.args,len(F.args)-1).var_name.text);
    }
    printf(")\n{\n");
}

void c_var_init(assignment A){
    c_print_scope(A.var.scope);
    c_print_var(A.var);
    printf(" = ");
    c_print_expr(A.expr);
    printf(";\n");
}

void c_var_assn(assignment A){
    c_print_scope(A.var.scope);
    printf("%s = ",A.var.var_name.text);
    c_print_expr(A.expr);
    printf(";\n");
}

void c_return(assignment A){
    c_print_scope(A.var.scope);
    printf("return ");
    c_print_expr(A.expr);
    printf(";\n");
}