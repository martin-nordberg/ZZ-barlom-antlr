
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
    : expressions
    ;


//-------------------------------------------------------------------------------------------------
// EXPRESSIONS
//-------------------------------------------------------------------------------------------------

expression
    : expression DOT functionCall
    | expression DOT Identifier
    | functionCall
    | Identifier
    | literal
    // TODO: more alternatives ...
    ;

expressions
    : expression*
    ;

functionCall
    : Identifier LPAREN arguments RPAREN ( LBRACE expressions RBRACE )?
    ;

literal
    : IntegerLiteral
//	| FloatingPointLiteral
    | BooleanLiteral
    | SymbolLiteral
    | TextLiteral
//	| NothingLiteral
	;

arguments
    : expression ( COMMA expression ) *
    | /*nothing*/
    ;

