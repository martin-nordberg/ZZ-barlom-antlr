
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
    : classDeclaration
    | constantDeclaration
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
// ANNOTATIONS
//-------------------------------------------------------------------------------------------------

annotation
    : TextLiteral
    | LowerCaseIdentifier
    ;

leadingAnnotations
    : ( annotation ) *
    ;

trailingAnnotations
    : ( COLON annotation ) *
    | typeDeclaration
    ;

//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

functionDeclaration
    : leadingAnnotations FUNCTION LowerCaseIdentifier LPAREN parameters RPAREN trailingAnnotations
      LBRACE /*TODO: statements*/ RBRACE
    ;


//-------------------------------------------------------------------------------------------------
// CLASSES
//-------------------------------------------------------------------------------------------------

classDeclaration
    : CLASS UpperCaseIdentifier LPAREN parameters RPAREN
      extendsDeclaration implementsDeclaration LBRACE
      classMembers
      RBRACE
    ;

classMember
    : constantDeclaration
    | functionDeclaration
    ;

classMembers
    : classMember *
    ;

extendsDeclaration
    : EXTENDS typeDeclaration LPAREN arguments RPAREN
    | /*nothing*/
    ;

implementsDeclaration
    : IMPLEMENTS typeDeclaration ( COMMA typeDeclaration ) *
    | /*nothing*/
    ;


//-------------------------------------------------------------------------------------------------
// EXPRESSIONS
//-------------------------------------------------------------------------------------------------

expression
    : literal
    // TODO: more alternatives ...
    ;

literal
    : IntegerLiteral
//	| FloatingPointLiteral
    | BooleanLiteral
    | TextLiteral
//	| NothingLiteral
	;

arguments
    : expression ( COMMA expression ) *
    | /*nothing*/
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

parameter
    : LowerCaseIdentifier ( COLON typeDeclaration ) ?
    ;

parameters
    : parameter ( COMMA parameter ) *
    | /*nothing*/
    ;

constantDeclaration
    : leadingAnnotations CONSTANT LowerCaseIdentifier trailingAnnotations ASSIGN expression SEMICOLON
    ;


//-------------------------------------------------------------------------------------------------
// TYPE DECLARATIONS
//-------------------------------------------------------------------------------------------------

typeDeclaration
    : UpperCaseIdentifier
    // TODO: closure-like generics
    ;


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

lcQualifiedIdentifier
    : LowerCaseIdentifier ( DOT LowerCaseIdentifier )*
    ;

ucQualifiedIdentifier
    : LowerCaseIdentifier ( DOT LowerCaseIdentifier )* DOT UpperCaseIdentifier
    ;

