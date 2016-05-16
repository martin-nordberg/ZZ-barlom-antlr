
lexer grammar BarlomLexer;

@header {
  package barlom.lexer;
}


// KEYWORDS
// --------

FUNCTION : 'function';
IMPORT : 'import';
LET : 'let';
PACKAGE : 'package';


// PUNCTUATION
// -----------

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


// COMPARISON OPERATORS
// --------------------

EQUAL : '==';
GE : '>=';
GT : '>';
LE : '<=';
LT : '<';
NOTEQUAL : '!=';


// ARITHMETIC OPERATORS
// --------------------

ADD : '+';
DIV : '/';
MOD : '%';
MUL : '*';
SUB : '-';


// BITWISE OPERATORS
// -----------------

BITAND : '&';
BITOR : '|';
BITNOT : '~';
BITXOR : '^';


// LOGIC OPERATORS
// ---------------

AND : '&&';
NOT : '!';
OR : '||';


// ASSIGNMENT OPERATORS
// --------------------

ASSIGN : '=';

ADD_ASSIGN : '+=';
DIV_ASSIGN : '/=';
MOD_ASSIGN : '%=';
MUL_ASSIGN : '*=';
SUB_ASSIGN : '-=';

AND_ASSIGN : '&=';
OR_ASSIGN : '|=';
XOR_ASSIGN : '^=';


// IDENTIFIERS
// -----------

Identifier
    : IdentifierFirstChar IdentifierSubsequentChar*
    ;

fragment
IdentifierFirstChar
    : [a-zA-Z$_]
    ;

fragment
IdentifierSubsequentChar
    : [a-zA-Z0-9$_]
    ;


// STRING LITERALS
// ---------------

StringLiteral
    : '"' StringCharacters? '"'
    | '\'' StringCharacters? '\''
    ;

fragment
StringCharacters
    : StringCharacter+
    ;

fragment
StringCharacter
    : ~["\\]
    | EscapeSequence
    ;

fragment
EscapeSequence
    : '\\' [btnfr"'\\]
    | UnicodeEscape
    ;

fragment
UnicodeEscape
    : '\\' 'u' HexDigit HexDigit HexDigit HexDigit;


// INTEGER LITERALS
// ----------------

fragment
HexDigit
    : [0-9a-fA-F]
    ;


// WHITE SPACE
// -----------

WS : [ \t\r\n\u000C]+ -> skip;


