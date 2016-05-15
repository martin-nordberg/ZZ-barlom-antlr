
lexer grammar BarlomLexer;

@header {
  package barlom.lang;
}


// KEYWORDS
KW_FUNCTION : 'function';


// SIMPLE TOKENS

COMMA : ',';
LBRACE : '{';
LBRACKET : '[';
LPAREN : '(';
RBRACE : '}';
RBRACKET: ']';
RPAREN : ')';
SEMICOLON : ';';


// WHITE SPACE

WS : [ \t\r\n\u000C]+ -> skip;


// LEXICAL STRUCTURE

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


