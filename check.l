%{
	#include <stdio.h>
	#include "y.tab.h"
	#include "float.h"
	#include "math.h"
	#include <string.h>
    #include "fcomp.h"
	#include "utilities.h"
%}

%option noyywrap

%%
[ ]+ ;
<<EOF>>                               { return EOS; }
[\t]                                  { scope++;    }
"def"                                 { set_token(DEF,0);      return DEF;    }
"return"                              { set_token(RETURN,0) ;  return RETURN; }
"in"                                  { set_token(IN,0) ;      return IN;     }
"for"                                 { set_token(FOR,0) ;     return FOR;    }
"range"                               { set_token(RANGE,0) ;   return RANGE;  }
":"                                   { set_token(COLON,0);    return COLON;  }
"if"                                  { set_token(IF,0);       return IF;     }
"->"                                  { set_token(ARROW,0);    return ARROW;  }
-?[0-9]+                              { set_token(NUM,INT);    return INT;    }
-?([0-9]*\.[0-9]+)([eE]?[+-]?[0-9]+)? { set_token(NUM,DOUBLE); return DOUBLE; }
-?[0-9]*\.                            { set_token(NUM,DOUBLE); return DOUBLE; }
[a-zA-Z]+                             { set_token(VAR,0);      return VAR;    } 
"\.EQ\."                              { set_token(OP,EQ);      return COMP;   } 
[=]                                   { set_token(ASSIGN,0);   return ASSIGN; }
[+\-\*\/]                             { set_token(OP,0);       return OP;     }
\(                                    { set_token(OPAREN,0);   return OPAREN; }
\)                                    { set_token(CPAREN,0);   return CPAREN; }
\,                                    { set_token(COMMA,0);    return COMMA;  }
[\n]                                  { set_token(NEWLINE,0);  return NEWLINE;}

. ECHO;
%%


