
parser grammar CompilationUnitParser;

@header {
  package barlom.parsers;
}


options {
  tokenVocab=BarlomLexer;
}

///////////////////////////////////////////////////////////////////////////////////////////////////


parse : compilationUnit;


///////////////////////////////////////////////////////////////////////////////////////////////////


compilationUnit
    : packageDeclaration importDeclarations packagedElements
    ;


constantDeclaration
    : LET Identifier ASSIGN expression SEMICOLON
    ;


expression
    : StringLiteral
    ;


functionDeclaration
    : FUNCTION Identifier LPAREN /*TODO: parameters*/ RPAREN LBRACE /*TODO: statements*/ RBRACE
    ;


importDeclaration
    : IMPORT qualifiedIdentifier SEMICOLON
    ;

importDeclarations
    : importDeclaration*
    ;


packagedElement
    : constantDeclaration
    | functionDeclaration
    // TODO: more alternatives ...
    ;

packagedElements
    : packagedElement+
    ;


packageDeclaration
    : PACKAGE qualifiedIdentifier SEMICOLON
    ;


qualifiedIdentifier
    : Identifier ( DOT Identifier )*
    ;


///////////////////////////////////////////////////////////////////////////////////////////////////

