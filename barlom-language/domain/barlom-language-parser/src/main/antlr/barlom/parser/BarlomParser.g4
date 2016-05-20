
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
    : StringLiteral
    | LcIdentifier
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
    : leadingAnnotations FUNCTION LcIdentifier LPAREN arguments RPAREN trailingAnnotations
      LBRACE /*TODO: statements*/ RBRACE
    ;


//-------------------------------------------------------------------------------------------------
// CLASSES
//-------------------------------------------------------------------------------------------------

classDeclaration
    : CLASS UcIdentifier LPAREN arguments RPAREN
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
    : EXTENDS typeDeclaration LPAREN parameters RPAREN
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
	:	IntegerLiteral
//	|	FloatingPointLiteral
//	|	BooleanLiteral
//	|	CharacterLiteral
	|	StringLiteral
//	|	NullLiteral
	;

parameters
    : expression ( COMMA expression ) *
    | /*nothing*/
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

argument
    : LcIdentifier ( COLON typeDeclaration ) ?
    ;

arguments
    : argument ( COMMA argument ) *
    | /*nothing*/
    ;

constantDeclaration
    : leadingAnnotations CONSTANT LcIdentifier trailingAnnotations ASSIGN expression SEMICOLON
    ;


//-------------------------------------------------------------------------------------------------
// TYPE DECLARATIONS
//-------------------------------------------------------------------------------------------------

typeDeclaration
    : UcIdentifier
    // TODO: closure-like generics
    ;


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

lcQualifiedIdentifier
    : LcIdentifier ( DOT LcIdentifier )*
    ;

ucQualifiedIdentifier
    : LcIdentifier ( DOT LcIdentifier )* DOT UcIdentifier
    ;

