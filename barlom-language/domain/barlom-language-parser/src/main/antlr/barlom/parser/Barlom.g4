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
    : useDeclaration* namespacedDefinition EOF
    ;

/*
 * Parses a definition that includes the namespaced path to the element being defined.
 */
namespacedDefinition
    : leadingAnnotations
      ( enumerationTypeNamespacedDefinition
      | functionNamespacedDefinition
      | moduleNamespacedDefinition
      | objectInstanceNamespacedDefinition
      | objectTypeNamespacedDefinition
      | packageNamespacedDefinition
      | specificationNamespacedDefinition
      | structureInstanceNamespacedDefinition
      | structureTypeNamespacedDefinition
      | variantTypeNamespacedDefinition
      // TODO: more alternatives ...
      )
    ;


//-------------------------------------------------------------------------------------------------
// MODULES
//-------------------------------------------------------------------------------------------------

/**
 * Parses the definition of a module.
 */
moduleNamespacedDefinition
    : MODULE modulePath parameters? trailingAnnotations moduleElement+ END
    ;

/**
 * Parses a module path.
 */
modulePath
    : ( Identifier ( DOT Identifier )* DOT )? Identifier argumentsNonEmpty?
    ;


// ------------------------------------------------------------------------------------------------
// MODULE ELEMENTS
// ------------------------------------------------------------------------------------------------

moduleElement
    : leadingAnnotations
      ( assertStatement
      | assignmentStatement
      | callStatement
      | checkStatement
      | constantDefinition
      | enumerationTypeDefinition
      | functionDefinition
      | ifStatement
      | loopStatement
      | matchStatement
      | objectInstanceDefinition
      | objectTypeDefinition
      | packageDefinition
      | specificationDefinition
      | structureInstanceDefinition
      | structureTypeDefinition
      | variableDefinition
      | variantTypeDefinition
      )
    ;

//-------------------------------------------------------------------------------------------------
// PACKAGES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a package declaration with its contents when the package is a whole compilation unit.
 */
packageNamespacedDefinition
    : PACKAGE packagePath trailingAnnotations packageElement+ END
    ;

/**
 * Parses the namespace, module, name, and optional parameters of a package.
 */
packagePath
    : modulePath DOT Identifier parameters?
    ;

/**
 * Parses a package declaration with its contents.
 */
packageDefinition
    : PACKAGE Identifier parameters? trailingAnnotations
      ( packageElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// PACKAGE ELEMENTS
//-------------------------------------------------------------------------------------------------

packageElement
    : leadingAnnotations
      ( assertStatement
      | assignmentStatement
      | callStatement
      | checkStatement
      | constantDefinition
      | enumerationTypeDefinition
      | functionDefinition
      | ifStatement
      | loopStatement
      | matchStatement
      | objectInstanceDefinition
      | objectTypeDefinition
      | packageDefinition
      | specificationDefinition
      | structureInstanceDefinition
      | structureTypeDefinition
      | variableDefinition
      | variantTypeDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a function definition when it is a whole file.
 */
functionNamespacedDefinition
    : FUNCTION functionPath trailingAnnotations functionElement+ END
    ;

/**
 * Parses a function definition.
 */
functionDefinition
    : FUNCTION Identifier parameters trailingAnnotations
      ( functionElement+ END | LocationLiteral )
    | FUNCTION Identifier EQUALS ( functionExpressionLiteral | functionBlockLiteral )
    ;

/**
 * Parses the path and parameters of a function definition
 */
functionPath
    : packagePath DOT Identifier parameters
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTION ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a statement
 */
functionElement
    : leadingAnnotations
    ( assertStatement
    | assignmentStatement
    | callStatement
    | checkStatement
    | constantDefinition
    | errorStatement
    | functionDefinition
    | ifStatement
    | loopStatement
    | matchStatement
    | objectInstanceDefinition
    | objectTypeDefinition
    | returnStatement
    | structureInstanceDefinition
    | structureTypeDefinition
    | variableDefinition
    | variantTypeDefinition
    // TODO: more
    )
    ;


//-------------------------------------------------------------------------------------------------
// ENUMERATION TYPES
//-------------------------------------------------------------------------------------------------

/**
 * Parses an enumeration type that is the one code element in a compilation unit.
 */
enumerationTypeNamespacedDefinition
    : ENUMERATION TYPE enumerationPath trailingAnnotations enumerationTypeContents END
    ;

/**
 * Parses the namespace, module, and name of an enumeration.
 */
enumerationPath
    : modulePath DOT Identifier
    ;

/**
 * Parses an enumeration type defined inside a parent container's definition.
 */
enumerationTypeDefinition
    : ENUMERATION TYPE Identifier trailingAnnotations
      ( enumerationTypeContents END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// ENUMERATION TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses the elements inside an enumeration type (symbols and functions).
 */
enumerationTypeContents
    : enumerationSymbolDefinition
      enumerationSymbolDefinition+
      enumerationElement*
    ;

/**
 * Parses one symbol definition within an enumeration type.
 */
enumerationSymbolDefinition
    : leadingAnnotations SYMBOL Identifier trailingAnnotations
    ;

/**
 * Parses one element of an enumeration type (after the symbols).
 */
enumerationElement
    : leadingAnnotations
      ( functionDefinition
      // TODO: maybe more
      )
    ;


//-------------------------------------------------------------------------------------------------
// VARIANT TYPES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a variant type that appears at the level of a whole compilation unit.
 */
variantTypeNamespacedDefinition
    : VARIANT TYPE variantTypePath trailingAnnotations variantTypeContents END
    ;

/**
 * Parses the namespace, module, and name of a variant type.
 */
variantTypePath
    : modulePath DOT Identifier parameters?
    ;

/**
 * Parses a variant type that is definied inside a parent element.
 */
variantTypeDefinition
    : VARIANT TYPE Identifier trailingAnnotations
      ( variantTypeContents END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// VARIANT TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses the elements within a variant type (variants followed by functions).
 */
variantTypeContents
    : variantDefinition
      variantDefinition+
      variantTypeElement*
    ;

/**
 * Parses one variant definition.
 */
variantDefinition
    : leadingAnnotations VARIANT Identifier parameters? trailingAnnotations
    ;

/**
 * Parses one element of a variant type (after the variants).
 */
variantTypeElement
    : leadingAnnotations
      ( functionDefinition
      // TODO: maybe more here
      )
    ;


//-------------------------------------------------------------------------------------------------
// OBJECT TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------

objectTypeNamespacedDefinition
    : OBJECT TYPE objectTypePath trailingAnnotations objectElement+ END
    ;

/**
 * Parses the namespace, module, and name of an object type.
 */
objectTypePath
    : modulePath DOT Identifier parameters?
    ;

objectTypeDefinition
    : OBJECT TYPE Identifier parameters? trailingAnnotations
      ( objectElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// OBJECT TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

objectElement
    : leadingAnnotations
      ( assertStatement
      | assignmentStatement
      | callStatement
      | checkStatement
      | constantDefinition
      | enumerationTypeDefinition
      | functionDefinition
      | ifStatement
      | loopStatement
      | matchStatement
      | packageDefinition
      | structureInstanceDefinition
      | structureTypeDefinition
      | variableDefinition
      | variantTypeDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// OBJECT INSTANCE DEFINITIONS
//-------------------------------------------------------------------------------------------------

objectInstanceNamespacedDefinition
    : OBJECT INSTANCE objectInstancePath trailingAnnotations objectElement+ END
    ;

/**
 * Parses the namespace, module, and name of a object instance.
 */
objectInstancePath
    : modulePath DOT Identifier
    ;

objectInstanceDefinition
    : OBJECT INSTANCE Identifier trailingAnnotations
      ( objectElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------

structureTypeNamespacedDefinition
    : STRUCTURE TYPE structureTypePath trailingAnnotations structureElement+ END
    ;

/**
 * Parses the namespace, module, and name of an structure type.
 */
structureTypePath
    : modulePath DOT Identifier
    ;

structureTypeDefinition
    : STRUCTURE TYPE Identifier trailingAnnotations
      ( structureElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

structureElement
    : leadingAnnotations
      ( assertStatement
      | assignmentStatement
      | callStatement
      | checkStatement
      | constantDefinition
      | enumerationTypeDefinition
      | functionDefinition
      | ifStatement
      | loopStatement
      | matchStatement
      | packageDefinition
      | structureInstanceDefinition
      | structureTypeDefinition
      | structureVariableDefinition
      | variableDefinition
      | variantTypeDefinition
      )
    ;

/**
 * Parses the declaration of a value that can be changed after it has been initialized.
 */
structureVariableDefinition
    : VARIABLE Identifier trailingAnnotations
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE INSTANCE DEFINITIONS
//-------------------------------------------------------------------------------------------------

structureInstanceNamespacedDefinition
    : STRUCTURE INSTANCE structureInstancePath trailingAnnotations structureElement+ END
    ;

/**
 * Parses the namespace, module, and name of a structure instance.
 */
structureInstancePath
    : modulePath DOT Identifier
    ;

structureInstanceDefinition
    : STRUCTURE INSTANCE Identifier trailingAnnotations
      ( structureElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// SPECIFICATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a specification definition when it is a whole file.
 */
specificationNamespacedDefinition
    : SPECIFICATION specificationPath trailingAnnotations specificationElement+ END
    ;

/**
 * Parses a specification definition.
 */
specificationDefinition
    : SPECIFICATION Identifier parameters? trailingAnnotations
      ( specificationElement+ END | LocationLiteral )
    ;

/**
 * Parses the path and parameters of a specification definition
 */
specificationPath
    : packagePath DOT Identifier parameters?
    ;


//-------------------------------------------------------------------------------------------------
// SPECIFICATION ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a statement
 */
specificationElement
    : leadingAnnotations
    ( cleanupDefinition
    | constantDefinition
    | enumerationTypeDefinition
    | functionDefinition
    | objectInstanceDefinition
    | objectTypeDefinition
    | samplingDefinition
    | scenarioDefinition
    | setupDefinition
    | structureInstanceDefinition
    | structureTypeDefinition
    | testDefinition
    | variableDefinition
    | variantTypeDefinition
    // TODO: more
    )
    ;

cleanupDefinition
    : CLEANUP trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;

setupDefinition
    : SETUP trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;

samplingDefinition
    : SAMPLING Identifier parameters trailingAnnotations
      ( ( GIVEN functionElement+ )?
        EXPECT expression
        WITH arrayLiteral
        END
      | LocationLiteral
      )
    ;

scenarioDefinition
    : SCENARIO Identifier trailingAnnotations
      ( ( GIVEN functionElement+ )?
        WHEN functionElement+
        THEN expression
        END
      | LocationLiteral
      )
    ;

testDefinition
    : TEST Identifier trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;

//-------------------------------------------------------------------------------------------------
// ANNOTATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses one annotation.
 */
annotation
    : TextLiteral
    | TextMultilineLiteral
    | Identifier arguments?
    | CodeLiteral
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
    : ( COLON annotation )*
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
// STATEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an assert statement.
 */
assertStatement
    : ASSERT expression
    ;

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
    : ASSIGN expression assignmentOperator expression
    ;

/**
 * Parses a call statement - the calling of a void function or else ignoring its result.
 */
callStatement
    : CALL functionCall
    ;

/**
 * Parses an error handling statement.
 */
checkStatement
    : CHECK statement+
      ( ( DETECT Identifier trailingAnnotations statement+ )+ ( REGARDLESS statement+ )?
      | ( REGARDLESS statement+ ) )
      END
    ;

/**
 * Parses a statement that triggers an error.
 */
errorStatement
    : RAISE ERROR expression
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
    : MATCH expression ( expression ( WHEN expression )? EQUAL_ARROW statement )+ ( ELSE statement+ )? END
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
    : assertStatement
    | assignmentStatement
    | callStatement
    | checkStatement
    | constantDefinition
    | errorStatement
    | ifStatement
    | functionDefinition
    | loopStatement
    | matchStatement
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
 * the context of the result of the function call.
 */
functionCall
    : Identifier arguments
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
	;

// TODO: tree of expression types to avoid a < b is c == d

relationalExpression
	:	additiveExpression
	|	relationalExpression COMPARE additiveExpression
	|	relationalExpression LESS_THAN additiveExpression
	|	relationalExpression GREATER_THAN additiveExpression
	|	relationalExpression LESS_THAN_OR_EQUAL additiveExpression
	|	relationalExpression GREATER_THAN_OR_EQUAL additiveExpression
	|	relationalExpression IS additiveExpression
	|	relationalExpression ISNOT additiveExpression
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
    : CONSTANT Identifier trailingAnnotations EQUALS expression
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
    : VARIABLE Identifier trailingAnnotations EQUALS expression
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
    : parameters ARROW BEGIN statement+ END
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
    : GRAPH_START ( graphElementDeclaration ( COMMA graphElementDeclaration )* COMMA? )? GRAPH_END
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
    | TemplateLiteral
    | TextLiteral
    | TextMultilineLiteral
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
    | LEFT_BRACE mapEntry ( COMMA mapEntry )* COMMA? RIGHT_BRACE
    ;


/**
 * Parses a range literal.
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
    : LEFT_BRACE ( expression ( COMMA expression )* COMMA? )? RIGHT_BRACE
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
    | LEFT_BRACE structureEntry ( COMMA structureEntry )* COMMA? RIGHT_BRACE
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
ASSERT : 'assert';
ASSIGN : 'assign';
BEGIN : 'begin';
CALL : 'call';
CHECK : 'check';
CLEANUP : 'cleanup';
CONSTANT : 'constant';
DETECT : 'detect';
ELSE : 'else';
END : 'end';
ENUMERATION : 'enumeration';
ERROR : 'error';
EXPECT : 'expect';
FALSE : 'false';
GIVEN : 'given';
IF : 'if';
FOR : 'for';
FUNCTION : 'function';
IMPORT : 'import';
IN : 'in';
INSTANCE : 'instance';
IS : 'is';
ISNOT : 'isnot';
MATCH : 'match';
MODULE : 'module';
NOT : 'not';
OBJECT : 'object';
OR : 'or';
PACKAGE : 'package';
RAISE : 'raise';
REGARDLESS : 'regardless';
REPEAT : 'repeat';
RETURN : 'return';
SAMPLING : 'sampling';
SCENARIO : 'scenario';
SELF : 'self';
SETUP : 'setup';
SPECIFICATION : 'specification';
STRUCTURE : 'structure';
SYMBOL : 'symbol';
TEST : 'test';
THEN : 'then';
TRUE : 'true';
TYPE : 'type';
UNDEFINED : 'undefined';
UNTIL : 'until';
USE : 'use';
VARIABLE : 'variable';
VARIANT : 'variant';
WHEN : 'when';
WHILE : 'while';
WITH : 'with';
XOR : 'xor';


/** TODO: reserve these and more ...
after
alias
annotation
around
aspect
before
case
class
data
default
defer
define
delete
do
insert
interface
intersection
let
namespace
protocol
rule
select
transform
translate
union
unless
update
version
where
with
yield
**/

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

COMPARE : '<=>';
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
 * Recognizes a text literal. Text literals are single or double quoted strings of characters
 * that fit on one line.
 */
TextLiteral
    : '"' TextCharsNotDblQuote '"'
    | '\'' TextCharsNotSnglQuote '\''
    ;

/**
 * Recognizes a multiline text literal. Triple-quoted strings that can cross multiple lines and
 * include the line feed characters.
 */
TextMultilineLiteral
    : '"""' TextChars '"""'
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
// USER-DEFINED KEYWORDS
//-------------------------------------------------------------------------------------------------

/**
 * Recognizes a user defined keyword (sometimes called atom) - a value meant to represent a
 * symbol in code. When converted to or from text, the name and text are the same.
 */
UserDefinedKeyWord
    : '#' [a-z]+
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
    : '/*' ( '*' ~'/' | ~'*' )* EOF
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
