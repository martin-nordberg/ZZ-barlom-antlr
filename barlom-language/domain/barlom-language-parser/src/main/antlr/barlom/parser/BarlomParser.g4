
parser grammar BarlomParser;

@header {
  package barlom.parser;
}

options {
  tokenVocab=BarlomLexer;
}

//-------------------------------------------------------------------------------------------------
// START RULE
//-------------------------------------------------------------------------------------------------

parse : compilationUnit;


//-------------------------------------------------------------------------------------------------
// COMPILATION UNIT
//-------------------------------------------------------------------------------------------------


compilationUnit
    : packageDeclaration importDeclarations packagedElements EOF
    ;


importDeclaration
    : IMPORT ucQualifiedIdentifier SEMICOLON
    ;

importDeclarations
    : importDeclaration *
    ;


packagedElement
    : constantDeclaration
    | functionDeclaration
    // TODO: more alternatives ...
    ;

packagedElements
    : packagedElement +
    ;


packageDeclaration
    : PACKAGE lcQualifiedIdentifier SEMICOLON
    ;



//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

functionDeclaration
    : FUNCTION LcIdentifier LPAREN /*TODO: parameters*/ RPAREN LBRACE /*TODO: statements*/ RBRACE
    ;


//-------------------------------------------------------------------------------------------------
// CLASSES
//-------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------
// EXPRESSIONS
//-------------------------------------------------------------------------------------------------

expression
    : StringLiteral
    // TODO: more alternatives ...
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

constantDeclaration
    : LET LcIdentifier ASSIGN expression SEMICOLON
    ;


//-------------------------------------------------------------------------------------------------
// TYPE DECLARATIONS
//-------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

lcQualifiedIdentifier
    : LcIdentifier ( DOT LcIdentifier )*
    ;

ucQualifiedIdentifier
    : LcIdentifier ( DOT LcIdentifier )* DOT UcIdentifier
    ;

