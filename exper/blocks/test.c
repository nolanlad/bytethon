#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "static_blocks.h"
#include "variable_blocks.h"

typedef struct point{
    int x;
    int y;
} Point;

dynamic_block(float);
dynamic_block(int);
dynamic_block(Point);

dynamic_block_funcs(Point);
dynamic_block_funcs(int);
dynamic_block_funcs(float);

typedef char* str;

variable_block(str);

int main(){
    float k ;
    int   k2;
    Point p = {1,2};

    struct blocked_float * b  = new_block_float();
    struct blocked_int   * b2 = new_block_int();
    struct blocked_Point * b3 = new_block_Point();
    struct blocked_str   * str_block = new_block_str();

    setter(str_block,0,"Hello!");
    setter(str_block,1,"This is a really long string, this is to test if my flimsy implementation is up to the task.");
    setter(b3,0,p);
    p = getter(b3,0);
    printf("%s\n",getter(str_block,1));

    for(int i = 0; i < 10000; ++i)
    {
        setter(b2,i,3);
        setter(b,i,getter(b2,i));
    }

    k  = 0.0;
    k2 = 0;

    for(int i = 0; i < 10000; ++i)
    {
        k2+=getter(b2,i);
        k+=getter(b,i);
    }

    printf("sum %f\n",k);
    printf("sum %d\n",k2);
    printf("length = %d\n",b2->length);
    return 0;
}
