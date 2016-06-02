//-------------------------------------------------------------------------------------------------

grammar Barlom;

@header {
  package barlom.parser;
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
    : namespaceContext moduleDeclarations EOF
    | moduleContext packagedElements EOF
    | packageContext packagedElements EOF
    ;


/**
 * Parses a module to be the context for subsequent declarations.
 */
moduleContext
    : MODULE qualifiedIdentifier SEMICOLON
    ;

/**
 * Parses the declaration of a module.
 */
moduleDeclaration
    : leadingAnnotations MODULE Identifier parameters? trailingAnnotations packagedElements
    ;

/**
 * Parses a sequence of module declarations.
 */
moduleDeclarations
    : moduleDeclaration*
    ;


namespaceContext
    : NAMESPACE qualifiedIdentifier SEMICOLON
    ;


packageContext
    : PACKAGE qualifiedIdentifier SEMICOLON
    ;

/**
 * Parses a language element allowed in a package.
 */
packagedElement
    : constantDeclaration
    | variableDeclaration
    | functionDeclaration
    | packageDeclaration
    // TODO: more alternatives ...
    ;

/**
 * Parses a sequence of elements within a package.
 */
packagedElements
    : BEGIN packagedElement+ END
    ;


/**
 * Parses a package declaration and its contents.
 */
packageDeclaration
    : leadingAnnotations PACKAGE Identifier parameters? trailingAnnotations packagedElements
    ;


//-------------------------------------------------------------------------------------------------
// ANNOTATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses one annotation.
 */
annotation
    : TextLiteral
    | Identifier arguments?
    | typeDeclaration
    ;

/**
 * Parses a sequence of annotations preceding a declaration.
 */
leadingAnnotations
    : ( annotation )*
    ;

/**
 * Parses a sequence of annotations following a declaration.
 */
trailingAnnotations
    : ( COLON annotation+ )?
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a variable declaration.
 */
functionDeclaration
    : leadingAnnotations FUNCTION Identifier parameters trailingAnnotations
      ( codeBlock | returnStatement )
    ;


//-------------------------------------------------------------------------------------------------
// STATEMENTS
//-------------------------------------------------------------------------------------------------

codeBlock
    : BEGIN statement+ END
    ;


returnStatement
    : RETURN expression SEMICOLON
    ;


statement
    : returnStatement
    // TODO: more
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
    : LPAREN argument ( COMMA argument )* RPAREN
    | LPAREN RPAREN
    ;


/**
 * Parses an expression.
 */
expression
    : expression DOT functionCall
    | expression DOT Identifier
    | conditionalOrExpression
    // TODO: more alternatives ...
    ;


/**
 * Parses a function call optionally followed by a sequence of statements to be executed in
 * the context of the result of the function call. -- TODO: the code block is just an idea so far
 */
functionCall
    : Identifier arguments codeBlock?
    ;


conditionalOrExpression
	:	conditionalAndExpression
	|	conditionalOrExpression OR conditionalAndExpression
	;

conditionalAndExpression
	:	exclusiveOrExpression
	|	conditionalAndExpression AND exclusiveOrExpression
	;

exclusiveOrExpression
	:	equalityExpression
	|	exclusiveOrExpression XOR equalityExpression
	;

equalityExpression
	:	relationalExpression
	|	equalityExpression EQUALS relationalExpression
	|	equalityExpression NOTEQUAL relationalExpression
	;

relationalExpression
	:	additiveExpression
	|	relationalExpression LESSTHAN additiveExpression
	|	relationalExpression GREATERTHAN additiveExpression
	|	relationalExpression LESSTHANOREQUAL additiveExpression
	|	relationalExpression GREATERTHANOREQUAL additiveExpression
	;

additiveExpression
	:	multiplicativeExpression
	|	additiveExpression PLUS multiplicativeExpression
	|	additiveExpression MINUS multiplicativeExpression
	;

multiplicativeExpression
	:	exponentialExpression
	|	multiplicativeExpression ASTERISK exponentialExpression
	|	multiplicativeExpression SLASH exponentialExpression
	|	multiplicativeExpression PERCENT exponentialExpression
	;

exponentialExpression
	: unaryExpression ( CARET exponentialExpression )?
	;

unaryExpression
    : primaryExpression
    | PLUS unaryExpression
    | MINUS unaryExpression
    ;

/**
 * Parses an expression with no operators.
 */
primaryExpression
    : functionCall
    | Identifier
    | literal
    // TODO: more alternatives ...
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

/**
 * Parses the declaration of a value that cannot be changed once initialized.
 */
constantDeclaration
    : leadingAnnotations CONSTANT Identifier trailingAnnotations ASSIGN expression SEMICOLON
    ;


/**
 * Parses the declaration of a function parameter.
 */
parameter
    : Identifier trailingAnnotations
    | expression
    ;

parameters
    : LPAREN parameter ( COMMA parameter )* RPAREN
    | LPAREN RPAREN
    ;


/**
 * Parses the declaration of a value that can be changed after it has been initialized.
 */
variableDeclaration
    : leadingAnnotations VARIABLE Identifier trailingAnnotations ASSIGN expression SEMICOLON
    ;



//-------------------------------------------------------------------------------------------------
// TYPE DECLARATIONS
//-------------------------------------------------------------------------------------------------

typeDeclaration
    : Identifier
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
    | EDGE_LPAREN Identifier EDGE_RPAREN
    | EDGE_LEFT
    | EDGE_LEFT_LPAREN Identifier EDGE_RPAREN
    | EDGE_RIGHT
    | EDGE_LPAREN Identifier EDGE_RIGHT_RPAREN
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
    : LBRACKET Identifier /*TODO( COLON typeExpression )*/ structureLiteral? RBRACKET
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
    | UndefinedLiteral
    | SymbolLiteral
    | VersionLiteral
    | arrayLiteral
    | graphLiteral
    | mapLiteral
    | rangeLiteral
    | structureLiteral
    | setLiteral
    | tupleLiteral
    | AnonymousLiteral
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


rangeLiteral
    : ( Identifier | TextLiteral ) ( RANGEINCLUSIVE | RANGEEXCLUSIVE ) ( Identifier | TextLiteral )
    | ( Identifier | IntegerLiteral ) ( RANGEINCLUSIVE | RANGEEXCLUSIVE ) ( Identifier | IntegerLiteral )
    | ( Identifier | NumberLiteral ) ( RANGEINCLUSIVE | RANGEEXCLUSIVE ) ( Identifier | NumberLiteral )
    ;


/**
 * Parses a set literal.
 */
setLiteral
    : LBRACE ( expression ( COMMA expression )* )? RBRACE
    ;


/**
 * Parses one entry in a structure literal.
 */
structureEntry
    : Identifier ASSIGN expression
    ;

/**
 * Parses a structure literal.
 */
structureLiteral
    : LBRACE ASSIGN RBRACE
    | LBRACE structureEntry ( COMMA structureEntry )* RBRACE
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

qualifiedIdentifier
    : Identifier ( DOT Identifier )*
    ;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

// LEXER ...

//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

AND : 'and';
BEGIN : 'begin';
CONSTANT : 'constant';
END : 'end';
// false (see below)
FUNCTION : 'function';
IMPORT : 'import';
MODULE : 'module';
NAMESPACE : 'namespace';
NOT : 'not';
OR : 'or';
PACKAGE : 'package';
RETURN : 'return';
// true (see below)
// undefined (see below)
VARIABLE : 'variable';
XOR : 'xor';


//-------------------------------------------------------------------------------------------------
// RANGE OPERATORS
//-------------------------------------------------------------------------------------------------

RANGEINCLUSIVE : '..';
RANGEEXCLUSIVE : '..<';


//-------------------------------------------------------------------------------------------------
// PUNCTUATION
//-------------------------------------------------------------------------------------------------

ARROW : '->';
COLON: ':';
COLONCOLON : '::';
COMMA : ',';
DOT : '.';
LBRACE : '{';
LBRACKET : '[';
LPAREN : '(';
QUESTION : '?';
RBRACE : '}';
RBRACKET : ']';
RPAREN : ')';
SEMICOLON : ';';
TILDEARROW : '~>';


//-------------------------------------------------------------------------------------------------
// COMPARISON OPERATORS
//-------------------------------------------------------------------------------------------------

EQUALS : '==';
GREATERTHANOREQUAL : '>=';
GREATERTHAN : '>';
LESSTHANOREQUAL : '<=';
LESSTHAN : '<';
NOTEQUAL : '=/=';   // ( a =/= b )


//-------------------------------------------------------------------------------------------------
// ARITHMETIC OPERATORS
//-------------------------------------------------------------------------------------------------

ASTERISK : '*';
CARET : '^';
MINUS : '-';
PERCENT : '%';
PLUS : '+';
SLASH : '/';


//-------------------------------------------------------------------------------------------------
// ASSIGNMENT OPERATORS
//-------------------------------------------------------------------------------------------------

ASSIGN : '=';
ASTERISKASSIGN : '*=';
CARETASSIGN : '^=';
MINUSASSIGN : '-=';
PERCENTASSIGN : '%=';
PLUSASSIGN : '+=';
SLASHASSIGN : '/=';


//-------------------------------------------------------------------------------------------------
// GRAPH PUNCTUATION
//-------------------------------------------------------------------------------------------------

GRAPH_START : '[%%';
GRAPH_END : '%%]';

EDGE : '---';
EDGE_LPAREN : '--(';
EDGE_RPAREN : ')--';

EDGE_LEFT : '<--';
EDGE_LEFT_LPAREN : '<-(';

EDGE_RIGHT : '-->';
EDGE_RIGHT_RPAREN : ')->';


//-------------------------------------------------------------------------------------------------
// TEXT LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a text literal. Text literals are single or double quoted strings of characters that fit
 * on one line or else triple-quoted strings that can cross multiple lines and include the line feed
 * characters.
 */
TextLiteral
    : '"' TextCharsNotDblQuote '"'
    | '\'' TextCharsNotSnglQuote '\''
    | '"""' TextChars '"""'
    | '\'\'\'' TextChars '\'\'\''
    ;

fragment
EscapeSequence
    : '\\' [bfnrt"'\\]
    | UnicodeEscape
    ;

fragment
TextCharNotDblQuote
    : ~["\\\n]
    | EscapeSequence
    ;

fragment
TextCharNotSnglQuote
    : ~['\\\n]
    | EscapeSequence
    ;

fragment
TextChars
    : .*?
    ;

fragment
TextCharsNotDblQuote
    : TextCharNotDblQuote*
    ;

fragment
TextCharsNotSnglQuote
    : TextCharNotSnglQuote*
    ;

fragment
UnicodeEscape
    : '\\u' HexDigit HexDigit HexDigit HexDigit
    | '\\u{' [A-Z \-]+ '}'    // Unicode character by name. See http://unicode.org/charts/charindex.html#T
    ;

ERROR_UNCLOSED_TEXT
    : '"' TextCharsNotDblQuote '\n'
    | '\'' TextCharsNotSnglQuote '\n'
    | '"""' ( '"'? '"'? TextCharNotDblQuote )* EOF
    | '\'\'\'' ( '\''? '\''? TextCharNotSnglQuote )* EOF
    ;


//-------------------------------------------------------------------------------------------------
// INTEGER LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes an integer literal. They can be decimal, hexadecimal, or binary. Underscores are
 * allowed. Suffixes specify the size of the storage for the value.
 */
IntegerLiteral
    : ( DecimalNumeral | HexNumeral | BinaryNumeral ) IntegerTypeSuffix?
    ;

fragment
IntegerTypeSuffix
    : [uU]? [iIlLsSyY]      // i = BigInteger; L = Integer64; s = Integer16; y = Integer8 (case sensitive)
    ;

fragment
DecimalNumeral
    : Digit (DigitOrUnderscore* Digit)?
    ;

fragment
Digit
    : [0-9]
    ;

fragment
DigitOrUnderscore
    : Digit
    | '_'
    ;

fragment
HexNumeral
    : '0' [xX] HexDigit (HexDigitOrUnderscore* HexDigit)?
    ;

fragment
HexDigit
    : [0-9a-fA-F]
    ;

fragment
HexDigitOrUnderscore
    : HexDigit
    | '_'
    ;

fragment
BinaryNumeral
    : '0' [bB] BinaryDigit (BinaryDigitOrUnderscore* BinaryDigit)?
    ;

fragment
BinaryDigit
    : [01]
    ;

fragment
BinaryDigitOrUnderscore
    : BinaryDigit
    | '_'
    ;


//-------------------------------------------------------------------------------------------------
// NUMBER LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a number (floating point) literal. A suffix indicates the representation size for
 * the value.
 */
NumberLiteral
    : DecimalNumeral '.' DecimalNumeral ExponentPart? FloatTypeSuffix?
    | '.' DecimalNumeral ExponentPart? FloatTypeSuffix?
    | DecimalNumeral ExponentPart FloatTypeSuffix?
    | DecimalNumeral FloatTypeSuffix
    ;

fragment
ExponentPart
    : [eE] [+-]? DecimalNumeral
    ;

fragment
FloatTypeSuffix
    : [dDfFgG]           // D = 64 bits, f = 32 bits, G = BigDecimal
    ;


//-------------------------------------------------------------------------------------------------
// VERSION LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a three-level semantic version
 */
VersionLiteral
    : DecimalNumeral '.' DecimalNumeral '.' DecimalNumeral
    ;


//-------------------------------------------------------------------------------------------------
// BOOLEAN LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a Boolean literal (either true or false).
 */
BooleanLiteral
    : 'true'
    | 'false'
    ;


//-------------------------------------------------------------------------------------------------
// DATE-TIME LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a date/time literal. The format is the the W3C profile of ISO 8601 found here:
 * https://www.w3.org/TR/NOTE-datetime.
 * Date/time literals are enclosed in dollar signs ("time is money"), an idea from Rascal
 * http://tutor.rascal-mpl.org/Rascal/Patterns/Abstract/Literal/Literal.html#/Rascal/Expressions/Values/DateTime/DateTime.html
 */
DateTimeLiteral
    : '$' Date Time? '$'
    | '$' Time '$'
    ;

/**
 * Recognizes the date fragment of a date/time literal, always YYYY-MM-DD, year-month-day.
 */
fragment
Date
    : Digit Digit Digit Digit '-' Digit Digit '-' Digit Digit
    ;

/**
 * Recognizes the time component of a date/time literal.
 */
fragment
Time
    : 'T' Digit Digit ':' Digit Digit ( ':' Digit Digit ( '.' Digit Digit? Digit? )? )? TimeZone?
    ;

/**
 * Recognizes the time zone component of a date/time literal. Either Z or +/-hh:mm.
 */
fragment
TimeZone
    : ( '+' | '-' ) Digit Digit ':' Digit Digit
    | 'Z'
    ;


//-------------------------------------------------------------------------------------------------
// REGULAR EXPRESSION LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a regular expression.
 */
RegularExpressionLiteral
    : '~/' RegexChar* '/' RegexSuffix? RegexSuffix? RegexSuffix?
    ;

fragment
RegexChar
    : ~[/]
    | '\\/'
    ;

fragment
RegexSuffix
    : [igm]       // i = case insensitive, g = match whole string (global), m = match multiple lines of text
    ;


//-------------------------------------------------------------------------------------------------
// UNDEFINED LITERAL
//-------------------------------------------------------------------------------------------------

/**
 * The literal "undefined", meaning an undefined value.
 */
UndefinedLiteral
    : 'undefined'
    ;


//-------------------------------------------------------------------------------------------------
// ANONYMOUS LITERAL
//-------------------------------------------------------------------------------------------------

/**
 * The literal "_", meaning an unnamed or unknown value.
 */
AnonymousLiteral
    : '_'
    ;


//-------------------------------------------------------------------------------------------------
// IDENTIFIERS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes an identifier.
 */
Identifier
    : IdentifierPrefix IdentifierBodyChar* Prime?
    ;

fragment
IdentifierPrefix
    : '_'* IdentifierChar
    ;

fragment
IdentifierBodyChar
    : IdentifierChar
    | DigitOrUnderscore
    ;

fragment
Prime
    : '\''
    ;

fragment
IdentifierChar
    : [a-zA-Z]
    // TODO: unicode characters
    ;


//-------------------------------------------------------------------------------------------------
// SYMBOL LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a symbol (sometimes called atom) - a value meant to represent a symbol in code.
 * When converted to or from text, the name and text are the same.
 */
SymbolLiteral
    : '#' IdentifierPrefix IdentifierBodyChar* Prime?
    ;


//-------------------------------------------------------------------------------------------------
// COMMENTS
//-------------------------------------------------------------------------------------------------

BLOCK_COMMENT
    : '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> skip
    ;

ERROR_UNCLOSED_BLOCK_COMMENT
    : '/*' .*? EOF
    ;


//-------------------------------------------------------------------------------------------------
// WHITE SPACE
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes white space.
 * NOTE: Tab characters are NOT recognized. Tools are expected to automatically adjust indenting
 * when needed to suit the taste of an individual developer, but in the absence of a tool, there
 * is no possibility of tab munging.
 */
WS : [ \r\n\u000C]+ -> skip;


//-------------------------------------------------------------------------------------------------
// UNEXPECTED CHARACTERS
//-------------------------------------------------------------------------------------------------

ERROR_UNEXPECTED_CHARACTER : .;


//-------------------------------------------------------------------------------------------------
