
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
    : TextLiteral
    | IntegerLiteral
    | NumberLiteral
    | BooleanLiteral
    | SymbolLiteral
    | DateTimeLiteral
    | RegularExpressionLiteral
//  | NothingLiteral
    ;

arguments
    : expression ( COMMA expression ) *
    | /*nothing*/
    ;

