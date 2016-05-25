
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
    : packageDeclaration EOF
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
    : PACKAGE lcQualifiedIdentifier BEGIN importDeclarations packagedElements END
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
 * Parses an expression.
 */
expression
    : expression DOT functionCall
    | expression DOT LowerCaseIdentifier
    | functionCall
    | LowerCaseIdentifier
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
    : LowerCaseIdentifier LPAREN arguments RPAREN ( BEGIN expressions END )?
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
// LITERALS
//-------------------------------------------------------------------------------------------------


/**
 * Parses an array literal.
 */
arrayLiteral
    : LBRACKET ( expression ( COMMA expression )* )? RBRACKET
    ;


/**
 * Parses the declaration of an edge within a graph literal
 */
graphEdgeDeclaration
    : graphVertexDeclaration graphEdgeArrowDeclaration graphVertexDeclaration
    ;

/**
 * Parses the arrow portion of an edge declaration.
 */
graphEdgeArrowDeclaration
    : EDGE
    | EDGE_LPAREN LowerCaseIdentifier EDGE_RPAREN
    | EDGE_LEFT
    | EDGE_LEFT_LPAREN LowerCaseIdentifier EDGE_RPAREN
    | EDGE_RIGHT
    | EDGE_LPAREN LowerCaseIdentifier EDGE_RIGHT_RPAREN
    ;

/**
 * Parses a vertex or edge declaration within a graph literal.
 */
graphElementDeclaration
    : graphVertexDeclaration | graphEdgeDeclaration
    ;

/**
 * Parses a literal graph.
 */
graphLiteral
    : GRAPH_START ( graphElementDeclaration ( COMMA graphElementDeclaration )* )? GRAPH_END
    ;

/**
 * Parses a vertex declaration within a graph literal
 */
graphVertexDeclaration
    : LBRACKET LowerCaseIdentifier /*TODO( COLON typeExpression )*/ recordLiteral? RBRACKET
    ;


/**
 * Parses one of many kinds of literals.
 */
literal
    : TextLiteral
    | IntegerLiteral
    | NumberLiteral
    | BooleanLiteral
    | DateTimeLiteral
    | RegularExpressionLiteral
    | NothingLiteral
    | LowerCaseSymbolLiteral
    | UpperCaseSymbolLiteral
    | arrayLiteral
    | graphLiteral
    | mapLiteral
    | recordLiteral
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
 * Parses one entry in a record literal.
 */
recordEntry
    : LowerCaseIdentifier ASSIGN expression
    ;

/**
 * Parses a record literal.
 */
recordLiteral
    : LBRACE ASSIGN RBRACE
    | LBRACE recordEntry ( COMMA recordEntry )* RBRACE
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


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

lcQualifiedIdentifier
    : LowerCaseIdentifier ( DOT LowerCaseIdentifier )*
    ;

ucQualifiedIdentifier
    : LowerCaseIdentifier ( DOT LowerCaseIdentifier )* DOT UpperCaseIdentifier
    ;


//-------------------------------------------------------------------------------------------------
