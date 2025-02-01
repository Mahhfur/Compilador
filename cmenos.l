/****************************************************/
/* File: cmenos.l                                  */
/* Lex specification for Cmenos                    */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]  
number      {digit}+   /* Qualquer numero */
letter      [a-zA-Z]   /* Qualquer letra */
identifier  {letter}+   /* ID */
newline     \n
whitespace  [ \t]+    /* Espaços e quebras de linha */

%%

"if"            { return IF; }
"else"          { return ELSE; }
"int"           { return INT; }
"void"          { return VOID; }
"while"         { return WHILE; }
"return"        { return RETURN; }

/* Operadores e símbolos especiais */
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return OVER; }
"<"         { return LT; }
"<="        { return LE; }
">"         { return GT; }
">="        { return GE; }
"=="        { return EQ; }
"!="        { return NE; }
"="         { return ASSIGN; }
";"         { return SEMI; }
","         { return COMMA; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }

/* Comentários (ignorar) */
"/*"        {
               char c, prev = 0;
               while ((c = input()) != EOF) {
                   if (prev == '*' && c == '/') break;
                   if (c == '\n') lineno++; /* Conta linhas */
                   prev = c;
               }
            }

/* Identificadores e números */
{identifier}   { return ID; }
{number}       { return NUM; }

/* Contagem de linhas */
{newline}       { lineno++; }

/* Ignorar espaços em branco */
{whitespace}    { /* skip whitespace */ }

/* Erro léxico */
.               { printf("ERRO LÉXICO: %s\n", yytext); return ERROR; }

%%

/* Função getToken */
TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (TraceScan) {
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}
