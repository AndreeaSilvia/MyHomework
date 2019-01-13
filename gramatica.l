%{
	#include "y.tab.h"
	extern int yyval;
	extern bool writeflag;
	extern bool readflag;
	extern bool forflag;
	int lineNo=1;
	int colNo=1;
%}

%%
"PROGRAM"			{ colNo+=strlen(yytext); return TOK_PROGRAM; }
"BEGIN"				{ colNo+=strlen(yytext); return TOK_BEGIN; }
"END"				{ colNo+=strlen(yytext); return TOK_END; }
"READ"				{ colNo+=strlen(yytext); readflag=true; return TOK_READ; }
"WRITE"				{ colNo+=strlen(yytext); writeflag=true; return TOK_WRITE; }
"FOR"				{ colNo+=strlen(yytext); forflag=true; return TOK_FOR; }
"DO"				{ colNo+=strlen(yytext); return TOK_DO; }
"TO"				{ colNo+=strlen(yytext); return TOK_TO; }
"VAR"				{ colNo+=strlen(yytext); return TOK_DECLARE; }
"INTEGER"			{ colNo+=strlen(yytext); return TOK_TYPE; }
"DIV"				{ colNo+=strlen(yytext); return TOK_DIVIDE; }
0|[1-9][0-9]*		{ colNo+=strlen(yytext); yylloc.first_line = lineNo; yylloc.first_column = colNo; yylval.val = atoi(yytext); return TOK_NUMBER; }
[a-zA-Z][a-zA-Z0-9]*		{ yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.sir = new char[strlen(yytext)+1]; strcpy(yylval.sir,yytext); return TOK_NAME; }
":="				{ colNo++; return TOK_ASSIGN; }
"+"				{ colNo++; return TOK_PLUS; }
"-"				{ colNo++; return TOK_MINUS; }
"*"				{ colNo++; return TOK_MULTIPLY; }
"("				{ colNo++; return TOK_LEFT; }
")"				{ colNo++; return TOK_RIGHT; }
";"				{ colNo++; return ';'; }
":"				{ colNo++; return ':'; }
","				{ colNo++; return ','; }
"\t"			{ colNo+=8; }
\r\n			{ lineNo++; colNo=1; }
\n				{ lineNo++; colNo=1; }
" "				{ colNo++; }
%%
