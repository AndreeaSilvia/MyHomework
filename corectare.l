%{
    int trigger=0;
    int tabno=1;
    int i;
%}

%%
"PROGRAM"			{ 
                        if (trigger==0) fprintf(yyout,"\n");
                        else trigger=0;
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }

"BEGIN"				{ 
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"END"				{ 
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"READ"				{ 
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"WRITE"				{ 
                        if (trigger==0) fprintf(yyout,"\n");
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"FOR"				{
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"DO"				{ 
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"TO"				{ 
                        if (trigger==1) 
                            { 
                                if (tabno<0) tabno=0; 
                                for(i=0; i<tabno; i++) 
                                    fprintf(yyout,"\t"); 
                                trigger=0;
                            }
                        fprintf(yyout, "%s", yytext); 
                    }
"VAR"				{ 
                        if (trigger==0) fprintf(yyout,"\n"); 
                        else trigger=0; 
                        if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                        fprintf(yyout, "%s", yytext); 
                    }
"INTEGER"			{ 
                        if (trigger==1) 
                        { 
                            if (tabno<0) tabno=0; 
                            for(i=0; i<tabno; i++) 
                                fprintf(yyout,"\t"); 
                            trigger=0;
                        }
                        fprintf(yyout, "%s", yytext);
                    }
"DIV"				{ 
                        if (trigger==1) 
                        { 
                            if (tabno<0) tabno=0; 
                            for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                                trigger=0;
                        }
                        fprintf(yyout, "%s", yytext); 
                    }
-?0|[1-9][0-9]*	    { 
                        if (trigger==1) 
                        { 
                            if (tabno<0) tabno=0; 
                            for(i=0; i<tabno; i++) 
                            fprintf(yyout,"\t"); 
                            trigger=0;
                        }
                        fprintf(yyout, "%s", yytext); 
                    }
^[a-zA-Z][a-zA-Z0-9]*		{ 
                                if (trigger==0) fprintf(yyout,"\n"); 
                                if (tabno<0) tabno=0; 
                                for(i=0; i<tabno; i++) 
                                    fprintf(yyout,"\t"); 
                                yytext[0]=(char)toupper(yytext[0]); 
                                fprintf(yyout, "%s", yytext); 
                            }
[a-zA-Z][a-zA-Z0-9]*		{ 
                                if (trigger==1) 
                                { 
                                    if (tabno<0) tabno=0; 
                                    for(i=0; i<tabno; i++) 
                                    fprintf(yyout,"\t"); trigger=0;
                                }
                                yytext[0]=(char)toupper(yytext[0]); 
                                fprintf(yyout, "%s", yytext); 
                            }
":="				{ fprintf(yyout, "%s", yytext); }
"+"				{ 
                    fprintf(yyout, "%s", yytext); 
                }
"-"				{ 
                    fprintf(yyout, "%s", yytext); 
                }
"*"				{ 
                    fprintf(yyout, "%s", yytext); 
                }
"("				{ 
                    fprintf(yyout,"\n"); 
                    if (tabno<0) tabno=0; 
                    for(i=0; i<tabno; i++) 
                        fprintf(yyout,"\t"); 
                    tabno++; 
                    fprintf(yyout, "%s", yytext); 
                    fprintf(yyout,"\n"); trigger=1; 
                }
")"				{ 
                    tabno--; 
                    fprintf(yyout,"\n"); 
                    if (tabno<0) tabno=0; 
                        for(i=0; i<tabno; i++) 
                    fprintf(yyout,"\t"); 
                    fprintf(yyout, "%s", yytext); 
                    fprintf(yyout,"\n"); trigger=1; 
                }
";"				{ 
                    fprintf(yyout, "%s", yytext); 
                }
":"				{ 
                    fprintf(yyout, "%s", yytext); 
                }
","				{ 
                    fprintf(yyout, "%s", yytext);
                }
^" "+ 			{     
                }
" "+ 			{ 
                    fprintf(yyout, " ");
                }
\r\n			{
                    fprintf(yyout, "%s", yytext);
                }
\n				{ 
                    fprintf(yyout, "%s", yytext); 
                }
%%

int main(int argc, char *argv[]) { 
    yyin = fopen(argv[1], "r"); 
    yyout = fopen("grammar_fixed.txt", "w"); 
    yylex(); 
    fclose(yyin); 
    fclose(yyout);
}