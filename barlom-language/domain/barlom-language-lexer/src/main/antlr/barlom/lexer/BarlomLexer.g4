
lexer grammar BarlomLexer;

@header {
  package barlom.lexer;
}


//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

AND : 'and';
CLASS : 'class';
CONSTANT : 'constant';
ENUMERATION : 'enumeration';
EXTENDS : 'extends';
// false (see below)
FUNCTION : 'function';
IMPLEMENTS : 'implements';
IMPORT : 'import';
INTERFACE : 'interface';
NOT : 'not';
OR : 'or';
PACKAGE : 'package';
// true (see below)
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
// TEXT LITERALS
//-------------------------------------------------------------------------------------------------

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
    : TextCharNotDblQuote *
    ;

fragment
TextCharsNotSnglQuote
    : TextCharNotSnglQuote *
    ;

fragment
UnicodeEscape
    : '\\u' HexDigit HexDigit HexDigit HexDigit
    | '\\u{' [A-Z \-]+ '}'    // Unicode character by name. See http://unicode.org/charts/charindex.html#T
    ;


//-------------------------------------------------------------------------------------------------
// INTEGER LITERALS
//-------------------------------------------------------------------------------------------------

IntegerLiteral
	:	DecimalIntegerLiteral
	|	HexIntegerLiteral
	|	BinaryIntegerLiteral
	;

fragment
DecimalIntegerLiteral
	:	DecimalNumeral IntegerTypeSuffix?
	;

fragment
HexIntegerLiteral
	:	HexNumeral IntegerTypeSuffix?
	;

fragment
BinaryIntegerLiteral
	:	BinaryNumeral IntegerTypeSuffix?
	;

fragment
IntegerTypeSuffix
	:	[gGiIlLsSyY]      // g = BigDecimal; i = Integer32; L = Integer64; s = Integer16; y= Integer8
	;

fragment
DecimalNumeral
	:	Digit (DigitOrUnderscore* Digit)?
	;

fragment
Digit
	:	[0-9]
	;

fragment
DigitOrUnderscore
	:	Digit
	|	'_'
	;

fragment
HexNumeral
	:	'0' [xX] HexDigit (HexDigitOrUnderscore* HexDigit)?
	;

fragment
HexDigit
	:	[0-9a-fA-F]
	;

fragment
HexDigitOrUnderscore
	:	HexDigit
	|	'_'
	;

fragment
BinaryNumeral
	:	'0' [bB] BinaryDigit (BinaryDigitOrUnderscore* BinaryDigit)?
	;

fragment
BinaryDigit
	:	[01]
	;

fragment
BinaryDigitOrUnderscore
	:	BinaryDigit
	|	'_'
	;


//-------------------------------------------------------------------------------------------------
// BOOLEAN LITERALS
//-------------------------------------------------------------------------------------------------

BooleanLiteral
    : True
    | False
    ;

fragment
False : 'false';

fragment
True : 'true';


//-------------------------------------------------------------------------------------------------
// IDENTIFIERS
//-------------------------------------------------------------------------------------------------

LowerCaseIdentifier
    : LowerCaseIdentifierFirstChar IdentifierSubsequentChar *
    ;

UpperCaseIdentifier
    : UpperCaseIdentifierFirstChar IdentifierSubsequentChar *
    ;

fragment
IdentifierSubsequentChar
    : [a-zA-Z0-9$_']
    // TODO: unicode
    ;

fragment
LowerCaseIdentifierFirstChar
    : [a-z_]
    // TODO: unicode characters (lower case)
    ;

fragment
UpperCaseIdentifierFirstChar
    : [A-Z_]
    // TODO: unicode characters (upper case)
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

WS : [ \r\n\u000C]+ -> skip;


//-------------------------------------------------------------------------------------------------
// UNEXPECTED CHARACTERS
//-------------------------------------------------------------------------------------------------

UNEXPECTED : .;

