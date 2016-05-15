
parser grammar CompilationUnitParser;

@header {
  package barlom.parsers;
}


options {
  tokenVocab=BarlomLexer;
}


parse : compilationUnit;


///////////////////////////////////////////////////////////////////////////////////////////////////


compilationUnit
    : packageDeclaration /* TODO: importDeclaration* */ packageContent+
    ;


functionDeclaration
    : FUNCTION Identifier LPAREN /*TODO: parameters*/ RPAREN LBRACE /*TODO: statements*/ RBRACE
    ;


packageContent
    : functionDeclaration
    // TODO: more alternatives ...
    ;


packageDeclaration
    : PACKAGE qualifiedIdentifier SEMICOLON
    ;


qualifiedIdentifier
    : Identifier ( DOT Identifier )*
    ;

