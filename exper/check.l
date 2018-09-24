%{
	#include <stdio.h>
	#include "y.tab.h"
	#include "float.h"
	#include "math.h"
	#include <string.h>
        int yyparse();
%}

%option noyywrap

%%
[ ]{4}                              //  {/* scope++;  */       //  return INDENT; }
<<EOF>>                               { return EOS; }
[\t]                                 // {/* scope++;  */      //   return INDENT; }
"def"                                 { return DEF;    }
"return"                              { return RETURN; }
"in"                                  { return IN;     }
"for"                                 { return FOR;    }
"range"                               { return RANGE;  }
":"                                   { return COLON;  }
"class"                               {  return CLASS;  }
"if"                                  { return IF;     }
"while"                               {return WHILE;  }
"->"                                  { return ARROW;  }
-?[0-9]+                              { return INT;    }
-?([0-9]*\.[0-9]+)([eE]?[+-]?[0-9]+)? {  return DOUBLE; }
-?[0-9]*\.                            { return DOUBLE; }
[_a-zA-Z]+                            { return VAR;    } 
"<"|">"|"<="|">="|"!="                { return OP;     } 
={1}                                  { return ASSIGN; }
={2}                                  { return OP;     }
[+\-\*\/]                             { return OP;     }
\(                                    { return OPAREN; }
\)                                    { return CPAREN; }
\,                                    { return COMMA;  }
[\n]                                  { return NEWLINE;}

. ECHO;
%%


