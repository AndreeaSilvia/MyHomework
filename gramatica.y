%{
	#include <stdio.h>
	#include <string.h>

	#define UNSETVALUE 30000

	int yylex();
	int yyerror(const char *msg);

	int EsteCorecta = 0;
	char msg[200];

	bool declareflag=true;
	bool readflag=false;
	bool writeflag=false;
	bool forflag=false;

	int nrexcutii;

	class TVAR
	{
	    char* nume;
		char* var_type;
	    int valoare;
	    TVAR* next;
	  
	public:
		static TVAR* head;
	    static TVAR* tail;

	    TVAR(char* n, int v = UNSETVALUE);
	    TVAR();
	    int exists(char* n);
        void add(char* n, int v = UNSETVALUE);
        int getValue(char* n);
	    void setValue(char* n, int v);
	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;

	TVAR::TVAR(char* n,  int v)
	{
		this->nume = new char[strlen(n)+1];
	 	strcpy(this->nume,n);
		//strcpy(this->var_type,"INTEGER");
	 	this->valoare = v;
	 	this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
		if(strcmp(tmp->nume,n) == 0)
	    return 1;
        tmp = tmp->next;
	  }
	  return 0;
	}

	void TVAR::add(char* n, int v)
	{
		TVAR* elem = new TVAR(n, v);
	    if(head == NULL)
	    {
	    	TVAR::head = TVAR::tail = elem;
	    }
	    else
	    {
	    	TVAR::tail->next = elem;
	    	TVAR::tail = elem;
	   	}
	}

	int TVAR::getValue(char* n)
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	    	if(strcmp(tmp->nume,n) == 0)
	    	return tmp->valoare;
	    	tmp = tmp->next;
	    }
	    return UNSETVALUE;
	}

	void TVAR::setValue(char* n, int v)
	{
		TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	    	if(strcmp(tmp->nume,n) == 0)
	    	{
				tmp->valoare = v;
			}
	      	tmp = tmp->next;
	    }
	}

	TVAR* ts = NULL;
%}

%union { char* sir; int val; }

%token TOK_PROGRAM TOK_BEGIN TOK_END TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_DECLARE TOK_TYPE TOK_DIVE TOK_ASSIGN TOK_PLUS TOK_MINUS TO_MULTIPLY TOK_LEFT TOK_RIGHT
%token <val> TOK_NUMBER
%token <sir> TOK_NAME

%type <val> factor term exp

%start prog

%left TOK_PLUS TOK_MINUS
%left TOK_MULTIPLY TOK_DIVIDE

%%
prog : TOK_PROGRAM prog_name TOK_DECLARE dec_list TOK_BEGIN smt_list TOK_END 
	{ 
		EsteCorecta=1;
	}
	;
prog_name : TOK_NAME
	;
dec_list : dec
	{
		declareflag=false;
	}
	|
	dec ';' dec_list
	;
dec : id_list ':' type
	;
type : TOK_TYPE
	;
id_list : TOK_NAME 
	{
		if (declareflag==true)
		{
			if (ts != NULL)
			{
				if (ts->exists($<sir>1)==0)
				{
					ts->add($<sir>1);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $<sir>1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($<sir>1);
			}
		}
		if (writeflag==true) 
		{
			if (ts!=NULL)
			{
				if (ts->exists($<sir>1)==1)
				{
					if (ts->getValue($<sir>1)==UNSETVALUE)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>1);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						printf("Valoarea lui %s este %d\n",$<sir>1,ts->getValue($<sir>1));
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>1);
					yyerror(msg);
					YYERROR;	
				}
			}
			else 
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>1);
				yyerror(msg);
				YYERROR;
			}
		}
		if (readflag==true)
		{
			if (ts!=NULL)
			{
				if (ts->exists($<sir>1)==1) 
				{
					int temp;
					char buf[20];
					printf("Introduceti valoarea lui %s\n",$<sir>1);
					fgets(buf, 20, stdin);
					temp=atoi(buf);
					ts->setValue($<sir>1, temp);
				}
				else 
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
				yyerror(msg);
				YYERROR;
			}
		}
	}
	|
	id_list ',' TOK_NAME
	{
		if (declareflag==true)
		{
			if (ts != NULL)
			{
				if (ts->exists($<sir>3)==0)
				{
					ts->add($<sir>3);
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Declaratii multiple pentru variabila %s!", @1.first_line, @1.first_column, $<sir>3);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				ts = new TVAR();
				ts->add($<sir>3);
			}
		}
		if (writeflag==true) 
		{
			if (ts!=NULL)
			{
				if (ts->exists($<sir>3)==1)
				{
					if (ts->getValue($<sir>3)==UNSETVALUE)
					{
						sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>3);
						yyerror(msg);
						YYERROR;
					}
					else
					{
						printf("Valoarea lui %s este %d\n",$<sir>3,ts->getValue($<sir>3));
					}
				}
				else
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>3);
					yyerror(msg);
					YYERROR;	
				}
			}
			else 
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>3);
				yyerror(msg);
				YYERROR;
			}
		}
		if (readflag==true)
		{
			if (ts!=NULL)
			{
				if (ts->exists($<sir>3)==1) 
				{
					int temp;
					printf("Introduceti valoarea lui %s\n",$<sir>3);
					scanf("%d",&temp);
					ts->setValue($<sir>3, temp);
				}
				else 
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>3);
					yyerror(msg);
					YYERROR;
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>3);
				yyerror(msg);
				YYERROR;
			}
		}
	}
	;
smt_list : smt
	|
	smt_list ';' smt
	;
smt : assign
	|
	read
	|
	write
	|
	for
	;
assign : TOK_NAME TOK_ASSIGN exp
	{
		if (ts!=NULL)
		{
			if (ts->exists($<sir>1)==1) 
			{
				ts->setValue($<sir>1,$<val>3);
			}
			else 
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
			yyerror(msg);
			YYERROR;
		}
	}
	;
exp : term
	{
		$$=$1;
	}
	|
	exp TOK_PLUS term 
	{
		$$=$1+$3;
	}
	|
	exp TOK_MINUS term 
	{
		$$=$1-$3;
	}
	;
term : factor
	{
		$$=$1;
	}
	|
	term TOK_MULTIPLY term
	{
		$$=$1*$3;
	}
	|
	term TOK_DIVIDE term 
	{ 
	  if($3 == 0) 
	  { 
	      sprintf(msg,"%d:%d Eroare semantica: Impartire la zero!", @1.first_line, @1.first_column);
	      yyerror(msg);
	      YYERROR;
	  } 
	  else
	  {
		  $$=$1/$3;
	  }
	}
	;
factor : TOK_NAME
	{
		if (ts!=NULL) 
		{
			if (ts->exists($<sir>1)==1)
			{
				if (ts->getValue($<sir>1)==UNSETVALUE)
				{
					sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost initializata!", @1.first_line, @1.first_column, $<sir>1);
					yyerror(msg);
					YYERROR;
				}
				else 
				{
					$$=ts->getValue($<sir>1);
				}
			}
			else
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
				yyerror(msg);
				YYERROR;
			}
		}
		else 
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
			yyerror(msg);
			YYERROR;
		}
	}
	|
	TOK_NUMBER 
	{
		$$ = $<val>1;
	}
	|
	TOK_LEFT exp TOK_RIGHT 
	{
		$$ = $<val>2;
	}
	;
read : TOK_READ TOK_LEFT id_list TOK_RIGHT
	{
		readflag=false;
	}
	;
write : TOK_WRITE TOK_LEFT id_list TOK_RIGHT
	{
		writeflag=false;
	}
	;
for : TOK_FOR index_exp TOK_DO body
	{
		if (forflag==true)
		{
			for (int i=0; i<nrexcutii; i++)
			{
				//$<context>TOK_DO = push_context ();
				printf("Just testing\n");
			}
			forflag=false;
		}
		//pop_context ($<context>TOK_DO);
	}
	;
index_exp : TOK_NAME TOK_ASSIGN exp TOK_TO exp
	{
		if (ts!=NULL)
		{
			if (ts->exists($<sir>1)==1) 
			{
				nrexcutii=$5-$3;
				ts->setValue($<sir>1,nrexcutii);
			}
			else 
			{
				sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
				yyerror(msg);
				YYERROR;
			}
		}
		else
		{
			sprintf(msg,"%d:%d Eroare semantica: Variabila %s este utilizata fara sa fi fost declarata!", @1.first_line, @1.first_column, $<sir>1);
			yyerror(msg);
			YYERROR;
		}
	}
	;
body : smt
	|
	TOK_BEGIN smt_list TOK_END
	;
%%
int main()
{
	yyparse();
	 
	if (EsteCorecta==1) {
		printf("CORECTA\n");
	}

    return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s\n", msg);
	return 1;
}
