
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
    : packageDeclaration EOF
    ;

/**
 * Parses an import declaration.
 */
importDeclaration
    : IMPORT ucQualifiedIdentifier SEMICOLON
    ;

/**
 * Parses a sequence of import declarations.
 */
importDeclarations
    : importDeclaration *
    ;


/**
 * Parses a language element allowed in a package.
 */
packagedElement
    : constantDeclaration
    | variableDeclaration
    | functionDeclaration
    // TODO: more alternatives ...
    ;

/**
 * Parses a sequence of elements within a package.
 */
packagedElements
    : packagedElement +
    ;


/**
 * Parses a package declaration and its contents.
 */
packageDeclaration
    : PACKAGE lcQualifiedIdentifier BEGIN importDeclarations packagedElements END
    ;


//-------------------------------------------------------------------------------------------------
// ANNOTATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses one annotation.
 */
annotation
    : TextLiteral
    | LowerCaseIdentifier ( LPAREN arguments RPAREN )?
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

/**
 * Parses the declaration of a value that cannot be changed once initialized.
 */
constantDeclaration
    : leadingAnnotations CONSTANT LowerCaseIdentifier trailingAnnotations ASSIGN expression SEMICOLON
    ;


/**
 * Parses the declaration of a function parameter.
 */
parameter
    : LowerCaseIdentifier trailingAnnotations
    ;

parameters
    : parameter ( COMMA parameter ) *
    | /*nothing*/
    ;


variableDeclaration
    : leadingAnnotations VARIABLE LowerCaseIdentifier trailingAnnotations ASSIGN expression SEMICOLON
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
    | UndefinedLiteral
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
NOT : 'not';
OR : 'or';
PACKAGE : 'package';
// true (see below)
// undefined (see below)
VARIABLE : 'variable';
XOR : 'xor';


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

EQUAL : '==';
GE : '>=';
GT : '>';
LE : '<=';
LT : '<';
NOTEQUAL : '=/=';   // ( a =/= b )


//-------------------------------------------------------------------------------------------------
// ARITHMETIC OPERATORS
//-------------------------------------------------------------------------------------------------

ADD : '+';
DIV : '/';
MOD : '%';
MUL : '*';
SUB : '-';


//-------------------------------------------------------------------------------------------------
// BITWISE OPERATORS
//-------------------------------------------------------------------------------------------------

BITAND : '&';
BITOR : '|';
BITNOT : '~';
BITXOR : '^';


//-------------------------------------------------------------------------------------------------
// ASSIGNMENT OPERATORS
//-------------------------------------------------------------------------------------------------

ASSIGN : '=';

ADD_ASSIGN : '+=';
DIV_ASSIGN : '/=';
MOD_ASSIGN : '%=';
MUL_ASSIGN : '*=';
SUB_ASSIGN : '-=';

AND_ASSIGN : '&=';
OR_ASSIGN : '|=';
XOR_ASSIGN : '^=';


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
    : ~["\\]
    | EscapeSequence
    ;

fragment
TextCharNotSnglQuote
    : ~['\\]
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
    : DecimalNumeral '.' DecimalNumeral? ExponentPart? FloatTypeSuffix?
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
// Undefined Literal
//-------------------------------------------------------------------------------------------------

/**
 * The literal "undefined", meaning an undefined value.
 */
UndefinedLiteral
    : 'undefined'
    ;


//-------------------------------------------------------------------------------------------------
// IDENTIFIERS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes an identifier that starts with a lower case letter.
 */
LowerCaseIdentifier
    : LowerCaseIdentifierFirstChar IdentifierSubsequentChar* Prime?
    ;

/**
 * Recognizes an identifier that starts with an upper case letter.
 */
UpperCaseIdentifier
    : UpperCaseIdentifierFirstChar IdentifierSubsequentChar* Prime?
    ;

fragment
IdentifierSubsequentChar
    : LowerCaseChar
    | UpperCaseChar
    | DigitOrUnderscore
    ;

fragment
Prime
    : '\''
    ;

fragment
LowerCaseIdentifierFirstChar
    : '_'* LowerCaseChar
    ;

fragment
LowerCaseChar
    : [a-z]
    // TODO: unicode characters
    ;

fragment
UpperCaseIdentifierFirstChar
    : '_'* UpperCaseChar
    ;

fragment
UpperCaseChar
    : [A-Z]
    // TODO: unicode characters
    ;

//-------------------------------------------------------------------------------------------------
// Symbol Literals
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a symbol (sometimes called atom) - a value meant to represent a symbol in code.
 * When converted to or from text, the name and text are the same.
 */
LowerCaseSymbolLiteral
    : '#' LowerCaseIdentifierFirstChar IdentifierSubsequentChar* Prime?
    ;

UpperCaseSymbolLiteral
    : '#' UpperCaseIdentifierFirstChar IdentifierSubsequentChar* Prime?
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
