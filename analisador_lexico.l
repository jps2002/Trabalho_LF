%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

//Definindo os tokens da linguagem LF
typedef enum _TOKEN {
eof = -1, OPR = 0, RESERVADAS = 1, ID = 2, LITERALINT = 3, LITERALFLOAT = 4, ERROR = 5, IF = 6, 
ELSE = 7, WHILE = 8, VAR = 9, CONST = 10, RETURN = 11, FN = 12, ATRIB = 13,
BOOL = 14, INT = 15, FLOAT = 16, TRU =17, FALS = 18, OPAR = 19, CPAR = 20, OBRAC = 21, 
CBRAC = 22, SCOL = 23, COL = 24
} TOKEN;


/*
%option yylineno é uma variável nativa do flex que aramzena em que linha da entrada está o analisador.
É incremmentado em 1 toda vez que uma quebra de linha é lida

a variável 'line' recebe o valor da linha atual ao iniciar um comentário de múltiplas linhas, pois
se todos os cometários não forem fechados o analisador será capaz de mostrar a linha que se iniciou o 
comentário. E a variável 'colComment' guarda a coluna para o mesmo propósito

'col' controlará a qual coluna cada token pertence e ela se inicia em 1

'nivel_comment' guarda quantos comentários do tipo "/*" foram abertos e ao fechar todos voltamos pro
estado inicial do analisador
*/
int line, col = 1, nivel_comment = 0, colComment;

%}
LETRAMIN [a-z]
LETRAMAIS [A-Z]
LETRA [a-zA-Z]
NUM [0-9]
QUEBRA [\n]
TAB [\t]
SPACE [ ]


%option yylineno
%x COMMENT_LINE
%x COMMENT
%%

<INITIAL><<eof>> {return eof;}
<INITIAL>{QUEBRA} {col = 1;}
<INITIAL>"//" {col += 2; BEGIN(COMMENT_LINE);}

<COMMENT_LINE>{QUEBRA} {col=1; BEGIN(INITIAL);}
<COMMENT_LINE>{TAB} {col += 4;}
<COMMENT_LINE>(.) {col++;}
<COMMENT_LINE><<eof>> {return eof;}

<INITIAL>"/*" {line = yylineno; colComment = col; col += 2; nivel_comment++; BEGIN(COMMENT);}

<COMMENT>"/*" {line = yylineno; col += 2; nivel_comment++;}
<COMMENT>"*/" {col += 2; nivel_comment--; if(nivel_comment == 0) BEGIN(INITIAL);}
<COMMENT>{QUEBRA} {col = 1;}
<COMMENT>{TAB} {col += 4;}
<COMMENT>{SPACE} {col++;}
<COMMENT>(.) {col++;}
<COMMENT><<eof>> {return ERROR;}


<INITIAL>{TAB} {col += 4;}
<INITIAL>{SPACE} {col++;}
<INITIAL>"+"|"*"|"==" {return OPR;}
<INITIAL>"if" {return IF;}
<INITIAL>"else" {return ELSE;}
<INITIAL>"while" {return WHILE;}
<INITIAL>"var" {return VAR;}
<INITIAL>"const" {return CONST;}
<INITIAL>"return" {return RETURN;}
<INITIAL>"fn" {return FN;}
<INITIAL>"=" {return ATRIB;}
<INITIAL>"bool" {return BOOL;}
<INITIAL>"int" {return INT;}
<INITIAL>"float" {return FLOAT;}
<INITIAL>"true" {return TRU;}
<INITIAL>"false" {return FALS;}
<INITIAL>"(" {return OPAR;}
<INITIAL>")" {return CPAR;}
<INITIAL>"{" {return OBRAC;}
<INITIAL>"}" {return CBRAC;}
<INITIAL>";" {return SCOL;}
<INITIAL>":" {return COL;}
<INITIAL>({LETRA}|_)({LETRA}|{NUM}|_)* {return ID;}
<INITIAL>0|[1-9]{NUM}* {return LITERALINT;}
<INITIAL>(0|[1-9][0-9]*)\.[0-9]+ {return LITERALFLOAT;}


%%

/*Function yywrap is called by lex when input is exhausted.
Return 1 if you are done or 0 if more processing is required.*/
int yywrap(void) { return 1; }

int main(int argc, char *argv[]) {
    TOKEN token_atual;

    yyin = fopen(argv[1], "r");
    // out = fopen(argv[2], "w");

    token_atual = (TOKEN) yylex();

    do{
        if(token_atual == ERROR){
            printf("(ERROR,\"/*\",%d,%d)\n", line, colComment);
            break;
        }else if(token_atual == OPR){
            printf("(OPR,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == IF){
            printf("(IF,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == ELSE){
            printf("(ELSE,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == WHILE){
            printf("(WHILE,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == VAR){
            printf("(VAR,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == CONST){
            printf("(CONST,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == RETURN){
            printf("(RETURN,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == FN){
            printf("(FN,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == ATRIB){
            printf("(ATRIB,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == BOOL){
            printf("(BOOL,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == INT){
            printf("(INT,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == FLOAT){
            printf("(FLOAT,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == TRU){
            printf("(TRU,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == FALS){
            printf("(FALS,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == OPAR){
            printf("(OPAR,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == CPAR){
            printf("(CPAR,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == OBRAC){
            printf("(OBRAC,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == CBRAC){
            printf("(CBRAC,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == SCOL){
            printf("(SCOL,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == COL){
            printf("(COL,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == ID){
            printf("(ID,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == LITERALINT){
            printf("(LITERALINT,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }else if(token_atual == LITERALFLOAT){
            printf("(LITERALFLOAT,\"%s\",%d,%d)\n", yytext, yylineno, col);
            col += strlen(yytext);
        }
    }while((token_atual = (TOKEN) yylex()) != EOF);

    printf("(EOF,%d,%d)\n", yylineno, col);


    fclose(yyin);
    

    return 0;
}