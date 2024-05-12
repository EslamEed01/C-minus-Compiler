/******************************/
/* File: tiny.flex            */
/* Lex specification for TINY */
/******************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "util.c"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}({letter}|{digit})*
newline     \n
whitespace  [ \t]+
comment     ("//"(.*)\n)|("/*".*"*/")


/* This tells flex to read only one input file */
%option noyywrap

%%
"if"            {return IF;}
"else"          {return ELSE;}
"while"          {return WHILE;}
"for"            { return FOR;}
"void"           { return VOID;}
"return"           { return RETURN;}
"read"           { return READ;}
"write"           { return WRITE;}
"int"           { return INT;}
"="            {return ASSIGN;}
"=="             {return EQ;}
"!="            { return NE;}
"<"             {return LT;}
"<="             {return LE;}
">"             {return GT;}
">="             {return GE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
","             {return COMMA;}
"["             {return LBRACKET;}
"]"             {return RBRACKET;}
"{"             {return LEFT_CURLY_BRACKET;}
"}"             {return RIGHT_CURLY_BRACKET;}

{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
{comment}       {/* Skip comments */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == '\n') lineno++;
                    
                  } while (c != '}');
                }
.               {return ERROR;}

%%
TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = fopen("tiny.txt", "r+");
    yyout = fopen("result.txt","w+");
listing = yyout;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  
  return currentToken;
}

int main()
{
	printf("welcome to the flex scanner: ");
	while(getToken())
	{
		printf("a new token has been detected...\n");
	}
	return 1;
}

