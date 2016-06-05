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
    : namespaceContext moduleDefinition+ EOF
    | moduleContext packageDefinition+ EOF
    | packageContext packagedElement+ EOF
    ;


//-------------------------------------------------------------------------------------------------
// NAMESPACES
//-------------------------------------------------------------------------------------------------

namespaceContext
    : NAMESPACE namespacePath SEMICOLON
    ;

namespacePath
    : Identifier ( DOT Identifier )*
    ;


//-------------------------------------------------------------------------------------------------
// MODULES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a module to be the context for subsequent declarations.
 */
moduleContext
    : MODULE modulePath SEMICOLON
    ;

/**
 * Parses the definition of a module.
 */
moduleDefinition
    : leadingAnnotations MODULE Identifier moduleVersionArgument? trailingAnnotations packagedElements
    ;

modulePath
    : namespacePath DOT Identifier moduleVersionArgument?
    ;

moduleVersionArgument
    : LEFT_PARENTHESIS VersionLiteral RIGHT_PARENTHESIS
    ;


//-------------------------------------------------------------------------------------------------
// PACKAGES
//-------------------------------------------------------------------------------------------------

packageContext
    : PACKAGE qualifiedIdentifier SEMICOLON
    ;

/**
 * Parses a language element allowed in a package.
 */
packagedElement
    : constantDefinition
    | variableDefinition
    | functionDeclaration
    | functionDefinition
    | packageDeclaration
    | packageDefinition
    | aliasDeclaration
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
    : leadingAnnotations PACKAGE Identifier parameters? trailingAnnotations SEMICOLON
    ;

packageDefinition
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
// ALIASES
//-------------------------------------------------------------------------------------------------

/**
 * Parses an alias declaration
 */
aliasDeclaration
    : ALIAS Identifier ASSIGN qualifiedIdentifier SEMICOLON
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a function declaration.
 */
functionDeclaration
    : leadingAnnotations FUNCTION Identifier parameters trailingAnnotations SEMICOLON
    ;

/**
 * Parses a function definition.
 */
functionDefinition
    : leadingAnnotations FUNCTION Identifier parameters trailingAnnotations ( codeBlock | returnStatement )
    | leadingAnnotations FUNCTION Identifier ASSIGN functionExpressionLiteral SEMICOLON
    | leadingAnnotations FUNCTION Identifier ASSIGN functionBlockLiteral
    ;


//-------------------------------------------------------------------------------------------------
// STATEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a sequence of statements.
 */
codeBlock
    : BEGIN statement+ END
    ;

loopStatement
    : REPEAT FOR Identifier trailingAnnotations IN expression codeBlock
    | REPEAT WHILE expression codeBlock
    | REPEAT UNTIL expression codeBlock
    ;
/**
 * Parses a return statement
 */
returnStatement
    : RETURN expression SEMICOLON
    ;

/**
 * Parses a statement
 */
statement
    : aliasDeclaration
    | constantDefinition
    | functionDefinition
    | loopStatement
    | returnStatement
    | variableDefinition
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
    : LEFT_PARENTHESIS argument ( COMMA argument )* RIGHT_PARENTHESIS
    | LEFT_PARENTHESIS RIGHT_PARENTHESIS
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
	|	equalityExpression NOT_EQUAL relationalExpression
	;

relationalExpression
	:	additiveExpression
	|	relationalExpression LESS_THAN additiveExpression
	|	relationalExpression GREATER_THAN additiveExpression
	|	relationalExpression LESS_THAN_OR_EQUAL additiveExpression
	|	relationalExpression GREATER_THAN_OR_EQUAL additiveExpression
	;

additiveExpression
	:	multiplicativeExpression
	|	additiveExpression PLUS multiplicativeExpression
	|	additiveExpression MINUS multiplicativeExpression
	;

multiplicativeExpression
	:	exponentialExpression
	|	multiplicativeExpression TIMES exponentialExpression
	|	multiplicativeExpression DIVIDED_BY exponentialExpression
	|	multiplicativeExpression MODULO exponentialExpression
	;

exponentialExpression
	: unaryExpression ( POWER exponentialExpression )?
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
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
    // TODO: more alternatives ...
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

/**
 * Parses the declaration of a value that cannot be changed once initialized.
 */
constantDefinition
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
    : LEFT_PARENTHESIS parameter ( COMMA parameter )* RIGHT_PARENTHESIS
    | LEFT_PARENTHESIS RIGHT_PARENTHESIS
    ;


/**
 * Parses the declaration of a value that can be changed after it has been initialized.
 */
variableDefinition
    : leadingAnnotations VARIABLE Identifier trailingAnnotations ASSIGN expression SEMICOLON
    ;


//-------------------------------------------------------------------------------------------------
// TYPE DECLARATIONS
//-------------------------------------------------------------------------------------------------

typeDeclaration
    : Identifier arguments? QUESTION?
    // TODO: closure-like generics
    ;


//-------------------------------------------------------------------------------------------------
// LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an array literal.
 */
arrayLiteral
    : LEFT_BRACKET ( expression ( COMMA expression )* )? RIGHT_BRACKET
    ;

functionBlockLiteral
    : parameters ARROW codeBlock
    ;

functionExpressionLiteral
    : parameters ARROW expression
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
    : LEFT_BRACKET Identifier /*TODO( COLON typeExpression )*/ structureLiteral? RIGHT_BRACKET
    ;


/**
 * Parses one of many kinds of literals.
 */
literal
    : AnonymousLiteral
    | BooleanLiteral
    | DateTimeLiteral
    | IntegerLiteral
    | NumberLiteral
    | RegularExpressionLiteral
    | SymbolLiteral
    | TextLiteral
    | UndefinedLiteral
    | VersionLiteral
    | arrayLiteral
    | functionBlockLiteral
    | functionExpressionLiteral
    | graphLiteral
    | mapLiteral
    | rangeLiteral
    | setLiteral
    | structureLiteral
    | tupleLiteral
    ;


/**
 * Parses one entry in a map literal.
 */
mapEntry
    : expression TILDE_ARROW expression
    ;

/**
 * Parses a map literal.
 */
mapLiteral
    : LEFT_BRACE TILDE_ARROW RIGHT_BRACE
    | LEFT_BRACE mapEntry ( COMMA mapEntry )* RIGHT_BRACE
    ;


/**
 * Parses a range literal
 */
rangeLiteral
    : ( Identifier | TextLiteral ) ( RANGE_INCLUSIVE | RANGE_EXCLUSIVE ) ( Identifier | TextLiteral )
    | ( Identifier | IntegerLiteral ) ( RANGE_INCLUSIVE | RANGE_EXCLUSIVE ) ( Identifier | IntegerLiteral )
    | ( Identifier | NumberLiteral ) ( RANGE_INCLUSIVE | RANGE_EXCLUSIVE ) ( Identifier | NumberLiteral )
    ;


/**
 * Parses a set literal.
 */
setLiteral
    : LEFT_BRACE ( expression ( COMMA expression )* )? RIGHT_BRACE
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
    : LEFT_BRACE ASSIGN RIGHT_BRACE
    | LEFT_BRACE structureEntry ( COMMA structureEntry )* RIGHT_BRACE
    ;


/**
 * Parses a tuple literal.
 * TODO: not sure all is clear between tuple & function call.
 */
tupleLiteral
    : LEFT_PARENTHESIS RIGHT_PARENTHESIS
    | LEFT_PARENTHESIS expression ( COMMA expression )+ RIGHT_PARENTHESIS
    ;


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

qualifiedIdentifier
    : Identifier moduleVersionArgument? ( DOT Identifier moduleVersionArgument? )*
    ;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

// LEXER ...

//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

ALIAS : 'alias';
AND : 'and';
BEGIN : 'begin';
CONSTANT : 'constant';
END : 'end';
// false (see below)
FOR : 'for';
FUNCTION : 'function';
IMPORT : 'import';
IN : 'in';
MODULE : 'module';
NAMESPACE : 'namespace';
NOT : 'not';
OR : 'or';
PACKAGE : 'package';
REPEAT : 'repeat';
RETURN : 'return';
// true (see below)
// undefined (see below)
UNTIL : 'until';
VARIABLE : 'variable';
WHILE : 'while';
XOR : 'xor';


//-------------------------------------------------------------------------------------------------
// PUNCTUATION
//-------------------------------------------------------------------------------------------------

ARROW : '->';
COLON: ':';
COLON_COLON : '::';
COMMA : ',';
DOT : '.';
LEFT_BRACE : '{';
LEFT_BRACKET : '[';
LEFT_PARENTHESIS : '(';
QUESTION : '?';
RIGHT_BRACE : '}';
RIGHT_BRACKET : ']';
RIGHT_PARENTHESIS : ')';
SEMICOLON : ';';
TILDE_ARROW : '~>';


//-------------------------------------------------------------------------------------------------
// COMPARISON OPERATORS
//-------------------------------------------------------------------------------------------------

EQUALS : '==';
GREATER_THAN_OR_EQUAL : '>=';
GREATER_THAN : '>';
LESS_THAN_OR_EQUAL : '<=';
LESS_THAN : '<';
NOT_EQUAL : '=/=';   // ( a =/= b )


//-------------------------------------------------------------------------------------------------
// ARITHMETIC OPERATORS
//-------------------------------------------------------------------------------------------------

DIVIDED_BY : '/';
MINUS : '-';
MODULO : '%';
PLUS : '+';
POWER : '^';
TIMES : '*';


//-------------------------------------------------------------------------------------------------
// ASSIGNMENT OPERATORS
//-------------------------------------------------------------------------------------------------

ASSIGN : '=';
DIVIDE_ASSIGN : '/=';
MINUS_ASSIGN : '-=';
MODULO_ASSIGN : '%=';
PLUS_ASSIGN : '+=';
POWER_ASSIGN : '^=';
TIMES_ASSIGN : '*=';


//-------------------------------------------------------------------------------------------------
// RANGE OPERATORS
//-------------------------------------------------------------------------------------------------

RANGE_INCLUSIVE : '..';
RANGE_EXCLUSIVE : '..<';


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
      ( '-' VersionPrereleaseFragment ( ('.'|'-') VersionPrereleaseFragment )* )?
      ( '+' VersionBuildFragment ( ('.'|'-') VersionBuildFragment )* )?
    ;

fragment
VersionBuildFragment
    : [a-zA-Z] [a-zA-Z0-9]*
    | [0-9]+
    ;

fragment
VersionPrereleaseFragment
    : [a-zA-Z] [a-zA-Z0-9]*
    | [1-9] [0-9]*
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
 * is no possibility of tab munging. Also form feeds are a relic of the past not recognized either.
 */
WS : [ \r\n]+ -> skip;


//-------------------------------------------------------------------------------------------------
// UNEXPECTED CHARACTERS
//-------------------------------------------------------------------------------------------------

ERROR_UNEXPECTED_CHARACTER : .;


//-------------------------------------------------------------------------------------------------
