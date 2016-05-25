
lexer grammar BarlomLexer;

@header {
  package barlom.lexer;
}


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
// nothing (see below)
OR : 'or';
PACKAGE : 'package';
// true (see below)
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
// Nothing Literal
//-------------------------------------------------------------------------------------------------

/**
 * The literal "nothing", meaning an undefined value.
 */
NothingLiteral
    : 'nothing'
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
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
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

UNEXPECTED : .;

