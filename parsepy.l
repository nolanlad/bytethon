%{
	#include <stdio.h>
	#include "y.tab.h"
%}

%%


[ ]{4}                                {  return INDENT; }
[\t]                                  {  return INDENT; }
[ ]+ ;
"def"                                 { return DEF;    }
"if"                                  { return IF;     }
":"                                   { return COLON;  }
-?[0-9]+                              { yylval.du = atoi(yytext); return INT;  }
-?([0-9]*\.[0-9]+)([eE]?[+-]?[0-9]+)? { yylval.du = atof(yytext); return DOUBLE; }
-?[0-9]*\.                            { return DOUBLE; }
[_a-zA-Z]+                            { return VAR;    } 
"<"|">"|"<="|">="|"!="                { return OP;     } 
={1}                                  { return ASSIGN; }
={2}                                  { return OP;     }
"+"                                   { return ADD;    }
"-"                                   { return SUB;    }
"*"                                   { return MUL;    }
"/"                                   { return DIV;    }
\(                                    { return OPAREN; }
\)                                    { return CPAREN; }
. ;

%%
