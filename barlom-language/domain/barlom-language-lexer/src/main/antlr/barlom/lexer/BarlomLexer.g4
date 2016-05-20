
lexer grammar BarlomLexer;

@header {
  package barlom.lexer;
}


//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

CLASS : 'class';
CONSTANT : 'const' ( 'ant' ) ?;
DELEGATES : 'delegates';
ENUMERATION : 'enumeration';
EXTENDS : 'extends';
FUNCTION : 'function';
IMPLEMENTS : 'implements';
IMPORT : 'import';
INTERFACE : 'interface';
METHOD : 'method';
PACKAGE : 'package';
VARIABLE : 'var' ( 'iable' ) ?;


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
NOTEQUAL : '!=';


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
// LOGIC OPERATORS
//-------------------------------------------------------------------------------------------------

AND : '&&';
NOT : '!';
OR : '||';


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
// IDENTIFIERS
//-------------------------------------------------------------------------------------------------

fragment
IdentifierSubsequentChar
    : [a-zA-Z0-9$_]
    // TODO: unicode
    ;

LcIdentifier
    : LcIdentifierFirstChar IdentifierSubsequentChar *
    ;

fragment
LcIdentifierFirstChar
    : [a-z_]
    // TODO: unicode characters (lower case)
    ;

UcIdentifier
    : UcIdentifierFirstChar IdentifierSubsequentChar *
    ;

fragment
UcIdentifierFirstChar
    : [A-Z_]
    // TODO: unicode characters (upper case)
    ;


//-------------------------------------------------------------------------------------------------
// STRING LITERALS
//-------------------------------------------------------------------------------------------------

StringLiteral
    : '"' StringCharacters '"'
    | '\'' StringCharacters '\''
    ;

fragment
EscapeSequence
    : '\\' [btnfr"'\\]
    | UnicodeEscape
    ;

fragment
StringCharacter
    : ~["\\]
    | EscapeSequence
    ;

fragment
StringCharacters
    : StringCharacter *
    ;

fragment
UnicodeEscape
    : '\\' 'u' HexDigit HexDigit HexDigit HexDigit
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
	:	[lL]
	;

fragment
DecimalNumeral
	:	Digit (Digits? | Underscores Digits)
	;

fragment
Digits
	:	Digit (DigitsAndUnderscores? Digit)?
	;

fragment
Digit
	:	[0-9]
	;

fragment
DigitsAndUnderscores
	:	DigitOrUnderscore+
	;

fragment
DigitOrUnderscore
	:	Digit
	|	'_'
	;

fragment
Underscores
	:	'_'+
	;

fragment
HexNumeral
	:	'0' [xX] HexDigits
	;

fragment
HexDigits
	:	HexDigit (HexDigitsAndUnderscores? HexDigit)?
	;

fragment
HexDigit
	:	[0-9a-fA-F]
	;

fragment
HexDigitsAndUnderscores
	:	HexDigitOrUnderscore+
	;

fragment
HexDigitOrUnderscore
	:	HexDigit
	|	'_'
	;

fragment
BinaryNumeral
	:	'0' [bB] BinaryDigits
	;

fragment
BinaryDigits
	:	BinaryDigit (BinaryDigitsAndUnderscores? BinaryDigit)?
	;

fragment
BinaryDigit
	:	[01]
	;

fragment
BinaryDigitsAndUnderscores
	:	BinaryDigitOrUnderscore+
	;

fragment
BinaryDigitOrUnderscore
	:	BinaryDigit
	|	'_'
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

