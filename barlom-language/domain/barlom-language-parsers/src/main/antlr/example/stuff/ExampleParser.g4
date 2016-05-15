
parser grammar ExampleParser;

@header {
  package example.stuff;
}


options {
  tokenVocab=BarlomLexer;
}


// PARSER RULES

function
    : KW_FUNCTION Identifier LPAREN RPAREN SEMICOLON
    ;


