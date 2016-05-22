
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

/**
 * Default start rule, parses a whole Barlom file.
 */
parse
    : compilationUnit
    ;


//-------------------------------------------------------------------------------------------------
// COMPILATION UNIT
//-------------------------------------------------------------------------------------------------

/**
 * Parses an entire Barlom source file.
 */
compilationUnit
    : expressions EOF
    ;


//-------------------------------------------------------------------------------------------------
// EXPRESSIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses one argument of a function call.
 */
argument
    : expression
    ;

/**
 * Parses the argument list of a function call.
 */
arguments
    : argument ( COMMA argument ) *
    | /*nothing*/
    ;


/**
 * Parses an array literal.
 */
arrayLiteral
    : LBRACKET ( expression ( COMMA expression )* )? RBRACKET
    ;


/**
 * Parses an expression.
 */
expression
    : expression DOT functionCall
    | expression DOT Identifier
    | functionCall
    | Identifier
    | literal
    // TODO: more alternatives ...
    ;

/**
 * Parses a sequence of expressions.
 */
expressions
    : expression*
    ;


/**
 * Parses a function call optionally followed by a sequence of expressions to be executed in
 * the context of the result of the function call.
 */
functionCall
    : Identifier LPAREN arguments RPAREN ( BEGIN expressions END )?
    ;


/**
 * Parses one of many kinds of literals.
 */
literal
    : TextLiteral
    | IntegerLiteral
    | NumberLiteral
    | BooleanLiteral
    | SymbolLiteral
    | DateTimeLiteral
    | RegularExpressionLiteral
    | NothingLiteral
    | arrayLiteral
    | mapLiteral
    | setLiteral
    | tupleLiteral
    ;


/**
 * Parses one entry in a map literal.
 */
mapEntry
    : expression TILDEARROW expression
    ;

/**
 * Parses a map literal.
 */
mapLiteral
    : LBRACE TILDEARROW RBRACE
    | LBRACE mapEntry ( COMMA mapEntry )* RBRACE
    ;


/**
 * Parses a set literal.
 */
setLiteral
    : LBRACE ( expression ( COMMA expression )* )? RBRACE
    ;


/**
 * Parses a tuple literal.
 * TODO: not sure all is clear between tuple & function call.
 */
tupleLiteral
    : LPAREN RPAREN
    | LPAREN expression ( COMMA expression )+ RPAREN
    ;

