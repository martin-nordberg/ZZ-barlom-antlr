//-------------------------------------------------------------------------------------------------
//
// (C) Copyright 2016 Martin E. Nordberg III
// Apache 2.0 License
//
//-------------------------------------------------------------------------------------------------
//
// Grammar for the Barlom language.
//
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

/**
 * Parses a use declaration
 */
useDeclaration
    : USE pathWithOptionalArguments ( AS Identifier )?
    ;

/*
 * Parses a definition that includes the namespaced path to the element being defined.
 */
namespacedDefinition
    : leadingAnnotations
      ( annotationTypeNamespacedDefinition
      | enumerationTypeNamespacedDefinition
      | functionNamespacedDefinition
      | graphTypeNamespacedDefinition
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
    : MODULE modulePath parameters? trailingAnnotations packageElement+ END
    ;


//-------------------------------------------------------------------------------------------------
// PACKAGES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a package declaration with its contents when the package is a whole compilation unit.
 */
packageNamespacedDefinition
    : PACKAGE pathWithOptionalParameters trailingAnnotations packageElement+ END
    ;

/**
 * Parses a package declaration with its contents.
 */
packageDefinition
    : PACKAGE nameWithOptionalParameters trailingAnnotations
      ( packageElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// PACKAGE ELEMENTS
//-------------------------------------------------------------------------------------------------

packageElement
    : leadingAnnotations
      ( actionStatement
      | annotationTypeDefinition
      | dataDefinition
      | functionDefinition
      | packageDefinition
      | specificationDefinition
      | typeDefinition
      )
    ;

typeDefinition
    : enumerationTypeDefinition
    | graphTypeDefinition
    | objectTypeDefinition
    | structureTypeDefinition
    | variantTypeDefinition
    ;

//-------------------------------------------------------------------------------------------------
// PATHS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a module path - an optional dot-delimited namespace, followed by the module name,
 * optionally followed by an argument list giving the module version.
 */
modulePath
    : ( Identifier ( DOT Identifier )* DOT )? nameWithOptionalArguments
    ;

/**
 * Parses the path of an element that sometimes takes arguments.
 */
pathWithOptionalArguments
    : modulePath ( DOT nameWithOptionalArguments )*
    ;

/**
 * Parses the namespace, module, optional parent package(s), name, and optional parameters of a
 * package or type.
 */
pathWithOptionalParameters
    : pathWithOptionalArguments DOT nameWithOptionalParameters
    ;

/**
 * Parses the path of an element that never takes parameters.
 */
pathWithoutParameters
    : pathWithOptionalArguments DOT nameWithoutParameters
    ;

/**
 * Parses the path of an element that always takes parameters.
 */
pathWithParameters
    : pathWithOptionalArguments DOT nameWithParameters
    ;


//-------------------------------------------------------------------------------------------------
// NAMES
//-------------------------------------------------------------------------------------------------

nameWithOptionalArguments
    : Identifier argumentsNonEmpty?
    ;

nameWithOptionalParameters
    : Identifier parametersNonEmpty?
    ;

nameWithoutParameters
    : Identifier
    ;

nameWithParameters
    : Identifier parameters
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a function definition when it is a whole file.
 */
functionNamespacedDefinition
    : FUNCTION pathWithParameters trailingAnnotations functionElement+ END
    ;

/**
 * Parses a function definition.
 */
functionDefinition
    : FUNCTION nameWithParameters trailingAnnotations
      ( functionElement+ END | LocationLiteral )
    | FUNCTION nameWithoutParameters EQUALS ( functionExpressionLiteral | functionBlockLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// FUNCTION ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a statement
 */
functionElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// ENUMERATION TYPES
//-------------------------------------------------------------------------------------------------

/**
 * Parses an enumeration type that is the one code element in a compilation unit.
 */
enumerationTypeNamespacedDefinition
    : ENUMERATION TYPE pathWithOptionalParameters trailingAnnotations enumerationTypeContents END
    ;

/**
 * Parses an enumeration type defined inside a parent container's definition.
 */
enumerationTypeDefinition
    : ENUMERATION TYPE nameWithOptionalParameters trailingAnnotations
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
      enumerationTypeElement*
    ;

/**
 * Parses one symbol definition within an enumeration type.
 */
enumerationSymbolDefinition
    : leadingAnnotations SYMBOL nameWithoutParameters trailingAnnotations
    ;

/**
 * Parses one element of an enumeration type (after the symbols).
 */
enumerationTypeElement
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
    : VARIANT TYPE pathWithOptionalParameters trailingAnnotations variantTypeContents END
    ;

/**
 * Parses a variant type that is definied inside a parent element.
 */
variantTypeDefinition
    : VARIANT TYPE nameWithOptionalParameters trailingAnnotations
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
    : leadingAnnotations VARIANT nameWithOptionalParameters trailingAnnotations
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

/**
 * Parses an object type definition when it is the entire compilation unit and hence includes its
 * path.
 */
objectTypeNamespacedDefinition
    : OBJECT TYPE pathWithOptionalParameters trailingAnnotations objectTypeElement+ END
    ;

/**
 * Parses an object type definition occuring inside a larger package or type definition.
 */
objectTypeDefinition
    : OBJECT TYPE nameWithOptionalParameters trailingAnnotations
      ( objectTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// OBJECT TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an element of an object type.
 */
objectTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      | typeDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// OBJECT INSTANCE DEFINITIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an object instance definition when it is the entire compilation unit and hence includes its
 * path.
 */
objectInstanceNamespacedDefinition
    : OBJECT INSTANCE pathWithoutParameters trailingAnnotations objectTypeElement+ END
    ;

/**
 * Parses an object instance definition occuring inside a larger package, type, or function
 * definition.
 */
objectInstanceDefinition
    : OBJECT INSTANCE nameWithoutParameters trailingAnnotations
      ( objectTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a structure type definition when it is the entire compilation unit and hence includes its
 * path.
 */
structureTypeNamespacedDefinition
    : STRUCTURE TYPE pathWithOptionalParameters trailingAnnotations structureTypeElement+ END
    ;

/**
 * Parses a structure type definition occuring inside a larger package or type definition.
 */
structureTypeDefinition
    : STRUCTURE TYPE nameWithOptionalParameters trailingAnnotations
      ( structureTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an element of a structure type.
 */
structureTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      | typeDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// STRUCTURE INSTANCE DEFINITIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a structure instance definition when it is the entire compilation unit and hence includes its
 * path.
 */
structureInstanceNamespacedDefinition
    : STRUCTURE INSTANCE pathWithoutParameters trailingAnnotations structureTypeElement+ END
    ;

/**
 * Parses a structure instance definition occuring inside a larger package, type, or function
 * definition.
 */
structureInstanceDefinition
    : STRUCTURE INSTANCE nameWithoutParameters trailingAnnotations
      ( structureTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// GRAPH TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a graph type definition occurring at the top level of a comoilation unit.
 */
graphTypeNamespacedDefinition
    : GRAPH TYPE pathWithOptionalParameters trailingAnnotations graphTypeElement+ END
    ;

/**
 * Parses a grpah type definition occuring inside a containing package or type definition.
 */
graphTypeDefinition
    : GRAPH TYPE nameWithOptionalParameters trailingAnnotations
      ( graphTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// GRAPH TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an element of a graph type.
 */
graphTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | edgeTypeDefinition
      | functionDefinition
      | typeDefinition
      | vertexTypeDefinition
      )
    ;

/**
 * Parses the declaration of a vertex type.
 */
vertexTypeDefinition
    : VERTEX TYPE nameWithoutParameters trailingAnnotations
      ( vertexTypeElement* END | LocationLiteral )
    ;

vertexTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      )
    ;

edgeTypeDefinition
    : EDGE TYPE nameWithoutParameters trailingAnnotations
      ( edgeTypeElement* END | LocationLiteral )
    ;

edgeTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      )
    ;


//-------------------------------------------------------------------------------------------------
// SPECIFICATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a specification definition when it is a whole file.
 */
specificationNamespacedDefinition
    : SPECIFICATION pathWithOptionalParameters trailingAnnotations specificationElement+ END
    ;

/**
 * Parses a specification definition.
 */
specificationDefinition
    : SPECIFICATION nameWithOptionalParameters trailingAnnotations
      ( specificationElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// SPECIFICATION ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a specification element
 */
specificationElement
    : leadingAnnotations
      ( cleanupDefinition
      | dataDefinition
      | functionDefinition
      | samplingDefinition
      | scenarioDefinition
      | setupDefinition
      | testDefinition
      | typeDefinition
      )
    ;

/**
 * Parses a cleanup definition - actions to be executed after each test in a specification.
 */
cleanupDefinition
    : CLEANUP trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;

/**
 * Parses a setup definition - actions to be executed before each test in a specification.
 */
setupDefinition
    : SETUP trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;

/**
 * Parses a sampling definition - a test that is driven by a table of data.
 */
samplingDefinition
    : SAMPLING nameWithParameters trailingAnnotations
      ( ( GIVEN functionElement+ )?
        EXPECT expression
        WITH arrayLiteral
        END
      | LocationLiteral
      )
    ;

/**
 * Parses a BDD-style given/when/then scenario.
 */
scenarioDefinition
    : SCENARIO nameWithoutParameters trailingAnnotations
      ( ( GIVEN functionElement+ )?
        WHEN functionElement+
        THEN expression
        END
      | LocationLiteral
      )
    ;

/**
 * Parses a traditional imperative unit test.
 */
testDefinition
    : TEST nameWithoutParameters trailingAnnotations ( functionElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// ANNOTATION TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an annotation type occuring at top level (whole compilation unit.
 */
annotationTypeNamespacedDefinition
    : ANNOTATION TYPE pathWithOptionalParameters trailingAnnotations annotationTypeElement+ END
    ;

/**
 * Parses an annotation type when it occurs inside a containing package.
 */
annotationTypeDefinition
    : ANNOTATION TYPE nameWithOptionalParameters trailingAnnotations
      ( annotationTypeElement+ END | LocationLiteral )
    ;


//-------------------------------------------------------------------------------------------------
// ANNOTATION TYPE ELEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses oneelement of an annotation type.
 */
annotationTypeElement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      | typeDefinition
      )
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
    | typeAnnotation
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
// STATEMENTS
//-------------------------------------------------------------------------------------------------

/**
 * Parses a statement
 */
statement
    : leadingAnnotations
      ( actionStatement
      | dataDefinition
      | functionDefinition
      );

actionStatement
    : assertStatement
    | assignmentStatement
    | callStatement
    | checkStatement
    | errorStatement
    | ifStatement
    | loopStatement
    | matchStatement
    | returnStatement
    | unlessStatement
    ;

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
    : LET expression assignmentOperator expression
    ;

/**
 * Parses a call statement - the calling of a void function or else ignoring its result.
 */
callStatement
    : CALL ( primaryExpression DOT )? functionCall
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
    : MATCH expression ( expression ( WHERE expression )? EQUAL_ARROW statement )+ ( ELSE statement+ )? END
    ;

/**
 * Parses a return statement
 */
returnStatement
    : RETURN expression
    ;

/**
 * Parses an unless statement.
 */
unlessStatement
    : UNLESS expression statement+ END
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
    : conditionalOrExpression
    // TODO: more alternatives ...
    ;


conditionalOrExpression
    : conditionalAndExpression
    | conditionalOrExpression OR conditionalAndExpression
    ;

conditionalAndExpression
    : exclusiveOrExpression
    | conditionalAndExpression AND exclusiveOrExpression
    ;

exclusiveOrExpression
    : equalityExpression
    | exclusiveOrExpression XOR equalityExpression
    ;

equalityExpression
    : relationalExpression
    | equalityExpression EQUALS relationalExpression
    | equalityExpression NOT_EQUAL_TO relationalExpression
    ;

// TODO: tree of expression types to avoid a < b is c == d

relationalExpression
    : additiveExpression
    | relationalExpression COMPARE additiveExpression
    | relationalExpression LESS_THAN additiveExpression
    | relationalExpression GREATER_THAN additiveExpression
    | relationalExpression LESS_THAN_OR_EQUAL additiveExpression
    | relationalExpression GREATER_THAN_OR_EQUAL additiveExpression
    | relationalExpression IS additiveExpression
    | relationalExpression ISNOT additiveExpression
    ;

additiveExpression
    : multiplicativeExpression
    | additiveExpression PLUS multiplicativeExpression
    | additiveExpression MINUS multiplicativeExpression
    ;

multiplicativeExpression
    : exponentialExpression
    | multiplicativeExpression TIMES exponentialExpression
    | multiplicativeExpression DIVIDED_BY exponentialExpression
    | multiplicativeExpression MODULO exponentialExpression
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


/**
 * Parses a function call optionally followed by a sequence of statements to be executed in
 * the context of the result of the function call.
 */
functionCall
    : Identifier arguments
    ;


//-------------------------------------------------------------------------------------------------
// VARIABLES
//-------------------------------------------------------------------------------------------------

/**
 * Parses a definition for one named element of data.
 */
dataDefinition
    : constantDefinition
    | valueDefinition
    | variableDefinition
    | objectInstanceDefinition
    | structureInstanceDefinition
    ;

/**
 * Parses the declaration of a value that can be computed at compile time.
 */
constantDefinition
    : CONSTANT nameWithoutParameters trailingAnnotations EQUALS expression
    ;


/**
 * Parses the declaration of a function parameter.
 */
parameter
    : nameWithoutParameters trailingAnnotations
    | expression
    | typeAnnotation
    ;

parameters
    : LEFT_PARENTHESIS parameter ( COMMA parameter )* RIGHT_PARENTHESIS
    | LEFT_PARENTHESIS RIGHT_PARENTHESIS
    ;

parametersNonEmpty
    : LEFT_PARENTHESIS parameter ( COMMA parameter )* RIGHT_PARENTHESIS
    ;


/**
 * Parses the declaration of a value that cannot be changed once initialized.
 */
valueDefinition
    : VALUE nameWithoutParameters trailingAnnotations EQUALS expression
    ;


/**
 * Parses the declaration of a value that can be changed after it has been initialized.
 */
variableDefinition
    : VARIABLE nameWithoutParameters trailingAnnotations ( EQUALS expression )?
    ;


//-------------------------------------------------------------------------------------------------
// TYPE ANNOTATIONS
//-------------------------------------------------------------------------------------------------

/**
 * Parses an annotation that gives the type of the element annotated.
 */
typeAnnotation
    : Identifier typeArguments? QUESTION?
    ;

/**
 * Parses one argument of a function call.
 */
typeArgument
    : expression
    | typeAnnotation
    ;

/**
 * Parses the argument list of a function call.
 */
typeArguments
    : LEFT_PARENTHESIS ( typeArgument ( COMMA typeArgument )* )? RIGHT_PARENTHESIS
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
    : EDGE_PLAIN
    | EDGE_LEFT
    | EDGE_RIGHT
    | EDGE_LPAREN Identifier trailingAnnotations EDGE_RPAREN
    | EDGE_LEFT_LPAREN Identifier trailingAnnotations EDGE_RPAREN
    | EDGE_LPAREN Identifier trailingAnnotations EDGE_RIGHT_RPAREN
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
    : LEFT_BRACKET Identifier trailingAnnotations structureLiteral? RIGHT_BRACKET
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


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

// LEXER ...

//-------------------------------------------------------------------------------------------------
// KEYWORDS
//-------------------------------------------------------------------------------------------------

AND : 'and';
ANNOTATION : 'annotation';
AS : 'as';
ASSERT : 'assert';
BEGIN : 'begin';
CALL : 'call';
CHECK : 'check';
CLEANUP : 'cleanup';
CONSTANT : 'constant';
DETECT : 'detect';
EDGE : 'edge';
ELSE : 'else';
END : 'end';
ENUMERATION : 'enumeration';
ERROR : 'error';
EXPECT : 'expect';
FALSE : 'false';
GIVEN : 'given';
GRAPH : 'graph';
IF : 'if';
FOR : 'for';
FUNCTION : 'function';
IN : 'in';
INSTANCE : 'instance';
IS : 'is';
ISNOT : 'isnot';
LET : 'let';
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
UNLESS : 'unless';
UNTIL : 'until';
USE : 'use';
VALUE : 'value';
VARIABLE : 'variable';
VARIANT : 'variant';
VERTEX : 'vertex';
WHEN : 'when';
WHERE : 'where';
WHILE : 'while';
WITH : 'with';
XOR : 'xor';


/** TODO: reserve these and more ...
after
alias
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
import
insert
interface
intersection
namespace
protocol
rule
select
transform
translate
union
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

EDGE_PLAIN : '---';
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
