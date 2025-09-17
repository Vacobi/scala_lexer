%{
#include <stdio.h>
%}
%option noyywrap

%%
[0-9]+      { printf("NUMBER: %s\n", yytext); }
[a-zA-Z]+   { printf("WORD: %s\n", yytext); }
[ \t\n]+    { /* пропускаем пробелы и переводы строк */ }
.           { printf("UNKNOWN: %s\n", yytext); }
%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror("File can not be open\n");
            return 1;
        }
        yyin = f;
    }
    yylex();
    return 0;
}
