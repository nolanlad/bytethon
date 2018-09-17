#ifndef __UTILS_H__
#define __UTILS_H__
#include <stdio.h>
#include "y.tab.h"
#include "blocks/static_blocks.h"

bool cmpchararr(char * one, char * other);
void set_token(int id, int sid);
void reset();

// variable   get_variables (  codeline * c  );
assignment get_assignment(  codeline * c  );
function   get_function  (  codeline * c  );
bool       varible_is_def(  codeline * c  );
bool       varible_is_def2(  variable2 v  );
assignment get_return    (  codeline * c  );
function   get_typed_function(codeline * c);
iterator   get_range     (  codeline * c  );

#endif //__UTILS_H__