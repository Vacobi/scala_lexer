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
	#include <algorithm>
	std::string buff = "";
%}

ID [A-Za-z0-9_$]+

digit [0-9]
notZeroDigit [1-9]
binDigit [01]
hexDigit [0-9a-fA-F]

decimalLiteral 0|{notZeroDigit}({digit}|"_")*
hexLiteral 0(x|X){hexDigit}({hexDigit}|"_")*
binLiteral 0(b|B){binDigit}({binDigit}|"_")*

exponentPart [eE][+-]?{digit}+
floatSuffix [fFdD]
doubleLiteral ({digit}+\.{digit}+({exponentPart})?({floatSuffix})?)|(\.{digit}+({exponentPart})?({floatSuffix})?)|({digit}+{exponentPart}({floatSuffix})?)|({digit}+{floatSuffix})


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
    void printOperator(char* keyword);
    std::string remove_underscore(const char* text);
    long long to_int(const char* text, int base = 10);
    double to_double(const char* text);
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

{decimalLiteral} {
    long long val = to_int(yytext, 10);
    std::cout << "Decimal literal: " << yytext << " -> " << val << std::endl;
}

{hexLiteral} {
    long long val = to_int(yytext, 16);
    std::cout << "Hex literal: " << yytext << " -> " << val << std::endl;
}

{binLiteral} {
    std::string s = remove_underscore(yytext);
    // убираем префикс 0b/0B
    if (s.rfind("0b", 0) == 0 || s.rfind("0B", 0) == 0)
        s = s.substr(2);
    long long val = 0;
    for (char c : s) {
        val = (val << 1) | (c - '0');
    }
    std::cout << "Binary literal: " << yytext << " -> " << val << std::endl;
}

{doubleLiteral} {
    double val = to_double(yytext);
    std::cout << "Double literal: " << yytext << " -> " << val << std::endl;
}

ID { std::cout << "Identifier: " << yytext << std::endl; }


Int { printf("Integer type: %s\n", yytext); }

Char { printf("Character type: %s\n", yytext); }

String { printf("String type: %s\n", yytext); }

Boolean { printf("Boolean type: %s\n", yytext); }

Unit { printf("Unit type: %s\n", yytext); }

Array { printf("Array type: %s\n", yytext); }

Double { printf("Double type: %s\n", yytext); }



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

std::string remove_underscore(const char* text) {
    std::string s(text);
    s.erase(std::remove(s.begin(), s.end(), '_'), s.end());
    return s;
}

long long to_int(const char* text, int base = 10) {
    std::string s = remove_underscore(text);
    return strtoll(s.c_str(), NULL, base);
}

double to_double(const char* text) {
    std::string s = remove_underscore(text);
    return atof(s.c_str());
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

void printOperator(char* keyword) {
    printf("Operator: %s\n", keyword);
}
