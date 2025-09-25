%option noyywrap never-interactive
%x MULTILINE_COMMENT
%x STRING
%x CHARACTER
%x INT

%{
	#include <iostream>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <string>
	#include <cstring>
	#include <stdbool.h>
	#include <stack>
	std::string buff = "";
%}

digit [0-9]
hexDigit [0-9a-fA-F]
notZeroDigit [1-9]
decimalNumeral 0|{notZeroDigit}({digit}|"_")*
hexNumeral 0(x|X){hexDigit}({hexDigit}|"_")*
UnicodeEscape \\u+{hexDigit}{4}
latinLetter [a-zA-Z]

%%

%{
    void printTypeDefinitionKeyword(char* keyword);
    void printModificatorKeyword(char* keyword);
    void printMembersDeclarationKeyword(char* keyword);
    void printControlStructureKeyword(char* keyword);
    void printInheritKeyword(char* keyword);
    void printObjectDefinitionKeyword(char* keyword);
    void printContextKeyword(char* keyword);
    void printConstantKeyword(char* keyword);
%}

"//".* { printf("Oneline comment: %s", yytext + 2); }

"/*" { BEGIN(MULTILINE_COMMENT); buff = ""; }
<MULTILINE_COMMENT>[^*]+ { buff += yytext; }
<MULTILINE_COMMENT>\*+[^/] { buff += yytext; }
<MULTILINE_COMMENT>\*+\/ { std::cout << "Multiline comment: " << buff << std::endl; BEGIN(INITIAL); }

class       { printTypeDefinitionKeyword(yytext); }
trait       { printTypeDefinitionKeyword(yytext); }
object      { printTypeDefinitionKeyword(yytext); }
enum        { printTypeDefinitionKeyword(yytext); }
given       { printTypeDefinitionKeyword(yytext); }
type        { printTypeDefinitionKeyword(yytext); }
opaque      { printTypeDefinitionKeyword(yytext); }
open        { printTypeDefinitionKeyword(yytext); }
extension   { printTypeDefinitionKeyword(yytext); }

abstract    { printModificatorKeyword(yytext); }
final       { printModificatorKeyword(yytext); }
sealed      { printModificatorKeyword(yytext); }
override    { printModificatorKeyword(yytext); }
implicit    { printModificatorKeyword(yytext); }
inline      { printModificatorKeyword(yytext); }
lazy        { printModificatorKeyword(yytext); }
transparent { printModificatorKeyword(yytext); }
private     { printModificatorKeyword(yytext); }
protected   { printModificatorKeyword(yytext); }
derives     { printModificatorKeyword(yytext); }

def         { printMembersDeclarationKeyword(yytext); }
val         { printMembersDeclarationKeyword(yytext); }
var         { printMembersDeclarationKeyword(yytext); }
package     { printMembersDeclarationKeyword(yytext); }
import      { printMembersDeclarationKeyword(yytext); }
export      { printMembersDeclarationKeyword(yytext); }
as          { printMembersDeclarationKeyword(yytext); }
using       { printMembersDeclarationKeyword(yytext); }

if          { printControlStructureKeyword(yytext); }
then        { printControlStructureKeyword(yytext); }
else        { printControlStructureKeyword(yytext); }
while       { printControlStructureKeyword(yytext); }
do          { printControlStructureKeyword(yytext); }
for         { printControlStructureKeyword(yytext); }
yield       { printControlStructureKeyword(yytext); }
match       { printControlStructureKeyword(yytext); }
case        { printControlStructureKeyword(yytext); }
try         { printControlStructureKeyword(yytext); }
catch       { printControlStructureKeyword(yytext); }
finally     { printControlStructureKeyword(yytext); }
throw       { printControlStructureKeyword(yytext); }
return      { printControlStructureKeyword(yytext); }

extends     { printInheritKeyword(yytext); }
with        { printInheritKeyword(yytext); }

new         { printObjectDefinitionKeyword(yytext); }
super       { printObjectDefinitionKeyword(yytext); }
this        { printObjectDefinitionKeyword(yytext); }

end         { printContextKeyword(yytext); }
infix       { printContextKeyword(yytext); }

true        { printConstantKeyword(yytext); }
false       { printConstantKeyword(yytext); }
null        { printConstantKeyword(yytext); }












%%

int main(int argc, char **argv)
{
    if(argc < 2)
    {
        printf("\nNot enough arguments. Please specify filename.\n");
        return -1;
    }
    if((yyin = fopen(argv[1], "r")) == NULL)
    {
        printf("\nCannot open file %s.\n", argv[1]);
        return -1;
    }
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
    return 0;
}

void printTypeDefinitionKeyword(char* keyword) {
    printf("Type definition keyword: %s\n", keyword);
}

void printModificatorKeyword(char* keyword) {
    printf("Modificator definition keyword: %s\n", keyword);
}

void printMembersDeclarationKeyword(char* keyword) {
    printf("Member declaration keyword: %s\n", keyword);
}

void printControlStructureKeyword(char* keyword) {
    printf("Control structure keyword: %s\n", keyword);
}

void printInheritKeyword(char* keyword) {
    printf("Inherit keyword: %s\n", keyword);
}

void printObjectDefinitionKeyword(char* keyword) {
    printf("Object definition keyword: %s\n", keyword);
}

void printContextKeyword(char* keyword) {
    printf("Context keyword: %s\n", keyword);
}

void printConstantKeyword(char* keyword) {
    printf("Constant keyword: %s\n", keyword);
}