#include "fcomp.h"
#include "utilities.h"

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
    if(F.r_type == DOUBLE)
        printf("double ");
    if(F.r_type == INT)
        printf("int ");
    printf("%s",F.func_name.text);
    printf("( ");

    if(len(F.args) != 0){
        for(int i =0; i < len(F.args) -1; ++i){
            c_print_var(getter(F.args,i)); printf(", ");
        }
        c_print_var(getter(F.args,len(F.args)-1));
    }
    printf(")\n{\n");
}

void c_var_init(assignment A){
    c_print_var(A.var);
    printf(" = ");
    c_print_expr(A.expr);
    printf(";\n");
}

void c_var_assn(assignment A){
    printf("%s = ",A.var.var_name.text);
    c_print_expr(A.expr);
    printf(";\n");
}

void c_return(assignment A){
    printf("return ");
    c_print_expr(A.expr);
    printf(";\n");
}

void c_if(ifwhile iff){
    printf("if( ");
    c_print_expr(iff.expr);
    printf("){");
}

void c_while(ifwhile iff){
    printf("while( ");
    c_print_expr(iff.expr);
    printf("){");
}

void c_for_loop(iterator it){
    printf("for( ");
    printf("int %s = %s; %s < %s; %s+=(%s) ){\n",
    it.counter.text, it.start.text,
    it.counter.text, it.stop.text, 
    it.counter.text, it.step.text );
}