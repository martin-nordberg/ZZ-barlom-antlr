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
    : moduleDefinition EOF
    | packagedElementNamespacedDefinition EOF
    ;


//-------------------------------------------------------------------------------------------------
// MODULES
//-------------------------------------------------------------------------------------------------

/**
 * Parses the definition of a module.
 */
moduleDefinition
    : leadingAnnotations MODULE modulePath parameters? trailingAnnotations packagedElements
    ;

/**
 * Parses a module path.
 */
modulePath
    : ( Identifier ( DOT Identifier )* DOT )? Identifier argumentsNonEmpty?
    ;


//-------------------------------------------------------------------------------------------------
// PACKAGES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a language element allowed in a package.
 */
packagedElementDeclaration
    : functionDeclaration
    | packageDeclaration
    | useDeclaration
    // TODO: more alternatives ...
    ;

/**
 * Parses a language element allowed in a package.
 */
packagedElementDefinition
    : constantDefinition
    | variableDefinition
    | functionDefinition
    | packageDefinition
    // TODO: more alternatives ...
    ;

/**
 * Parses a language element allowed in a package when it is the whole file.
 */
packagedElementNamespacedDefinition
    : functionNamespacedDefinition
    | packageNamespacedDefinition
    // TODO: more alternatives ...
    ;

/**
 * Parses a sequence of elements within a package.
 */
packagedElements
    : ( packagedElementDeclaration | packagedElementDefinition )+ END
    ;


/**
 * Parses a package declaration (contents deferred).
 */
packageDeclaration
    : leadingAnnotations PACKAGE Identifier parameters? trailingAnnotations LocationLiteral
    ;

/**
 * Parses a package declaration with its contents.
 */
packageDefinition
    : leadingAnnotations PACKAGE Identifier trailingAnnotations packagedElements
    ;

/**
 * Parses a package declaration with its contents when the package is a whole compilation unit.
 */
packageNamespacedDefinition
    : leadingAnnotations PACKAGE packagePath trailingAnnotations packagedElements
    ;

/**
 * Parses the namespace, module, name, and optional parameters of a package.
 */
packagePath
    : modulePath DOT Identifier parameters?
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
// USES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a use declaration
 */
useDeclaration
    : USE qualifiedIdentifier ( AS Identifier )?
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a function declaration.
 */
functionDeclaration
    : leadingAnnotations FUNCTION Identifier parameters trailingAnnotations LocationLiteral
    ;

/**
 * Parses a function definition.
 */
functionDefinition
    : leadingAnnotations FUNCTION Identifier parameters trailingAnnotations statement+ END
    | leadingAnnotations FUNCTION Identifier EQUALS functionExpressionLiteral
    | leadingAnnotations FUNCTION Identifier EQUALS functionBlockLiteral
    ;

/**
 * Parses a function definition when it is a whole file.
 */
functionNamespacedDefinition
    : leadingAnnotations FUNCTION functionPath trailingAnnotations statement+ END
    ;

/**
 * Parses the path and parameters of a function definition
 */
functionPath
    : packagePath DOT Identifier parameters
    ;


//-------------------------------------------------------------------------------------------------
// STATEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses one of the assignment operators.
 */
assignmentOperator
    : EQUALS
    | DIVIDE_EQUALS
    | MINUS_EQUALS
    | MODULO_EQUALS
    | PLUS_EQUALS
    | POWER_EQUALS
    | TIMES_EQUALS
    ;

/**
 * Parses an assignment statement.
 */
assignmentStatement
    : ASSIGN Identifier assignmentOperator expression
    ;

callStatement
    : CALL functionCall
    ;

checkStatement
    : CHECK statement+ ( ( DETECT Identifier trailingAnnotations statement+ )+ ( REGARDLESS statement+ )? | ( REGARDLESS statement+ ) ) END
    ;

/**
 * Parses a sequence of statements.
 */
codeBlock
    : BEGIN statement+ END
    ;

errorStatement
    : ERROR expression
    ;

/**
 * Parses an if statement.
 */
ifStatement
    : IF expression statement+ ( ELSE IF expression statement+ )* ( ELSE statement+ )? END
    ;

/**
 * Parses a repeat statement.
 */
loopStatement
    : REPEAT FOR Identifier trailingAnnotations IN expression statement+ END
    | REPEAT WHILE expression statement+ END
    | REPEAT UNTIL expression statement+ END
    ;

/**
 * Parses a match statement.
 */
matchStatement
    : MATCH expression ( expression ( WHEN expression )? EQUAL_ARROW statement )+ END
    ;

/**
 * Parses a return statement
 */
returnStatement
    : RETURN expression
    ;

/**
 * Parses a statement
 */
statement
    : assignmentStatement
    | callStatement
    | checkStatement
    | constantDefinition
    | errorStatement
    | ifStatement
    | functionDefinition
    | loopStatement
    | matchStatement
    | returnStatement
    | useDeclaration
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
    : LEFT_PARENTHESIS ( argument ( COMMA argument )* )? RIGHT_PARENTHESIS
    ;

/**
 * Parses the argument list of a module or package.
 */
argumentsNonEmpty
    : LEFT_PARENTHESIS argument ( COMMA argument )* RIGHT_PARENTHESIS
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
	|	equalityExpression NOT_EQUAL_TO relationalExpression
	|	equalityExpression IS relationalExpression
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
    | NOT unaryExpression
    ;

/**
 * Parses an expression with no operators.
 */
primaryExpression
    : Identifier
    | functionCall
    | literal
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
    | primaryExpression DOT Identifier
    | primaryExpression DOT functionCall
    // TODO: more alternatives ...
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

/**
 * Parses the declaration of a value that cannot be changed once initialized.
 */
constantDefinition
    : leadingAnnotations CONSTANT Identifier trailingAnnotations EQUALS expression
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
    : leadingAnnotations VARIABLE Identifier trailingAnnotations EQUALS expression
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
    : LEFT_BRACKET ( expression ( COMMA expression )* COMMA? )? RIGHT_BRACKET
    ;

/**
 * Recognizes a Boolean literal (either true or false).
 */
booleanLiteral
    : TRUE
    | FALSE
    ;

/**
 * Parses a function literal with multple statements in the function definition.
 */
functionBlockLiteral
    : parameters ARROW codeBlock
    ;

/**
 * Parses a function literal with one expression in its definition.
 */
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
 * Parses a linked list literal.
 */
listLiteral
    : LEFT_BRACKET ( SEMICOLON | expression SEMICOLON ( expression SEMICOLON )* expression? ) RIGHT_BRACKET
    ;


/**
 * Parses one of many kinds of literals.
 */
literal
    : AnonymousLiteral
    | CodeLiteral
    | DateTimeLiteral
    | IntegerLiteral
    | NumberLiteral
    | RegularExpressionLiteral
    | SymbolLiteral
    | TemplateLiteral
    | TextLiteral
    | VersionLiteral
    | arrayLiteral
    | booleanLiteral
    | functionBlockLiteral
    | functionExpressionLiteral
    | graphLiteral
    | listLiteral
    | mapLiteral
    | rangeLiteral
    | selfLiteral
    | setLiteral
    | structureLiteral
    | tupleLiteral
    | undefinedLiteral
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
 * Parses the literal for self - the currently executing object or structure.
 */
selfLiteral
    : SELF
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
    : Identifier EQUALS expression
    ;

/**
 * Parses a structure literal.
 */
structureLiteral
    : LEFT_BRACE EQUALS RIGHT_BRACE
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

/**
 * The literal "undefined", meaning an undefined value.
 */
undefinedLiteral
    : UNDEFINED
    ;


//-------------------------------------------------------------------------------------------------
// BASICS
//-------------------------------------------------------------------------------------------------

qualifiedIdentifier
    : Identifier argumentsNonEmpty? ( DOT Identifier argumentsNonEmpty? )*
    ;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

// LEXER ...

//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

AND : 'and';
AS : 'as';
ASSIGN : 'assign';
BEGIN : 'begin';
CALL : 'call';
CHECK : 'check';
CONSTANT : 'constant';
DETECT : 'detect';
ELSE : 'else';
END : 'end';
ERROR : 'error';
FALSE : 'false';
IF : 'if';
FOR : 'for';
FUNCTION : 'function';
IMPORT : 'import';
IN : 'in';
IS : 'is';
MATCH : 'match';
MODULE : 'module';
NOT : 'not';
OR : 'or';
PACKAGE : 'package';
REGARDLESS : 'regardless';
REPEAT : 'repeat';
RETURN : 'return';
SELF : 'self';
THEN : 'then';
TRUE : 'true';
UNDEFINED : 'undefined';
UNTIL : 'until';
USE : 'use';
VARIABLE : 'variable';
WHEN : 'when';
WHILE : 'while';
XOR : 'xor';


ERROR_RESERVED_WORD
    : 'with'
    ;


//-------------------------------------------------------------------------------------------------
// PUNCTUATION
//-------------------------------------------------------------------------------------------------

ARROW : '->';
COLON: ':';
COLON_COLON : '::';
COMMA : ',';
DOT : '.';
EQUAL_ARROW : '=>';
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

GREATER_THAN_OR_EQUAL : '>=';
GREATER_THAN : '>';
LESS_THAN_OR_EQUAL : '<=';
LESS_THAN : '<';
NOT_EQUAL_TO : '=/=';   // ( a =/= b )


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

EQUALS : '=';
DIVIDE_EQUALS : '/=';
MINUS_EQUALS : '-=';
MODULO_EQUALS : '%=';
PLUS_EQUALS : '+=';
POWER_EQUALS : '^=';
TIMES_EQUALS : '*=';


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
    | '"""' ( '"'? '"'? TextCharNotDblQuote | '\n' )* EOF
    | '\'\'\'' ( '\''? '\''? TextCharNotSnglQuote | '\n' )* EOF
    ;


//-------------------------------------------------------------------------------------------------
// CODE LITERALS
//-------------------------------------------------------------------------------------------------

CodeLiteral
    : '`' TextChars '`'
    ;

fragment
TextCharNotBackTick
    : ~'`'
    | EscapeSequence
    ;

ERROR_UNCLOSED_CODE
    : '`' TextCharNotBackTick* EOF
    ;

//-------------------------------------------------------------------------------------------------
// TEMPLATE LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a template literal. Template literals are delimited by quote/brace/quote. The quotes
 * may be either double or single in symmetric pairs.
 */
TemplateLiteral
    : '"{"' TextChars '"}"'
    | '\'{\'' TextChars '\'}\''
    | '"{\'' TextChars '\'}"'
    | '\'{"' TextChars '"}\''
    ;

/**
 * Recognizes a template literal with no closing quote triple.
 */
ERROR_UNCLOSED_TEMPLATE
    : '"{"' ( '"'? '}'? TextCharNotDblQuote )* EOF
    | '\'{\'' ( '\''? '}'? TextCharNotSnglQuote )* EOF
    | '"{\'' ( '\''? '}'? TextCharNotDblQuote )* EOF
    | '\'{"' ( '"'? '}'? TextCharNotSnglQuote )* EOF
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
// LOCATION LITERALS
//-------------------------------------------------------------------------------------------------

/**
 * A location (URI) literal.  TODO: maybe recognize its innards here
 */
LocationLiteral
    : '@|' ~'|'*? '|'
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
