#ifndef __STATIC_BLOCKS_H__
#define __STATIC_BLOCKS_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BLOCK_SIZE 20 

typedef int bool;
#define true 1
#define false 0 


#define dynamic_block(dtype) struct blocked_##dtype{\
    dtype block[BLOCK_SIZE];\
    struct blocked_##dtype * next;\
    dtype (*get)(struct blocked_##dtype *, int);\
    dtype * (*get_ptr)(struct blocked_##dtype *, int);\
    void  (*set)(struct blocked_##dtype *, int, dtype el);\
    int length;\
    bool needs_malloc;\
};\
struct blocked_##dtype * new_block_##dtype(void);\
void setitem_##dtype(struct blocked_##dtype * in, int indx, dtype el);\
dtype getitem_##dtype(struct blocked_##dtype * in, int indx);\

#define dynamic_block_funcs(dtype)\
void setitem_##dtype(struct blocked_##dtype * in, int indx, dtype el){\
    if(indx < BLOCK_SIZE){\
        in->block[indx] = el;\
    }\
    else if(in->next==NULL){\
        in->next = new_block_##dtype();\
        setitem_##dtype(in->next,indx-BLOCK_SIZE,el);\
    }\
    else if(in->next!=NULL){\
        setitem_##dtype(in->next,indx-BLOCK_SIZE,el);\
    }\
    if(indx >= in->length) in->length = indx+1;\
}\
\
dtype getitem_##dtype(struct blocked_##dtype * in, int indx){\
    if(indx < BLOCK_SIZE){\
        return in->block[indx];\
    }\
    if(in->next!=NULL){\
        return getitem_##dtype(in->next,indx-BLOCK_SIZE);\
    }\
}\
dtype * getitem_ptr_##dtype(struct blocked_##dtype * in, int indx){\
    if(indx < BLOCK_SIZE){\
        return &(in->block[indx]);\
    }\
    if(in->next!=NULL){\
        return (getitem_ptr_##dtype(in->next,indx-BLOCK_SIZE));\
    }\
}\
struct blocked_##dtype * new_block_##dtype(void){\
    struct blocked_##dtype * new = (struct blocked_##dtype *)malloc(sizeof(struct blocked_##dtype));\
    new->next = NULL;\
    new->get = getitem_##dtype;\
    new->set = setitem_##dtype;\
    new->get_ptr = getitem_ptr_##dtype;\
    new->length = 0;\
    new->needs_malloc = false;\
    return new;\
}\
\

#define getter(class, ind) (class->get(class,ind))
#define getter_ptr(class,ind) ((class->get_ptr(class,ind)))
#define setter(class, ind, el) (class->set(class,ind,el))
#define swap(class1,class2,ind) (setter(class1,ind,getter(class2,ind)))
#define len(class) (class->length)
#define append(class, el) (class->set(class,len(class),el))
#define last_ptr(class) (getter_ptr(class,(class->length)-1)) 

#endif //__STATIC_BLOCKS_H__
