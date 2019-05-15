/* Kotlin Basic Syntax */
grammar Kotlin;

// ==========================================================
// Parser rule
// ==========================================================

// Source
prog : packageDeclaration? importList? topLevelBody? EOF ;

// Package
packageDeclaration : Package packageName ;
packageName : Id packageSubName ;
packageSubName : Dot Id packageSubName
               | ;

// Import
importList : importDeclaration+ ;
importDeclaration : Import importName ;
importName : Id importSubName ;
importSubName : Dot Id importSubName
              | Dot '*'
              | ;

// Body
topLevelBody : topLevelBodyElement+ ;
topLevelBodyElement : assignStatement
                    | functionDeclaration
                    | classDeclaration
                    | interfaceDeclaration ;
body : bodyElement+ ;
bodyElement : functionDeclaration
            | functionCallStatement
            | ifStatement
            | forStatement
            | whileStatement
            | whenStatement
            | assignStatement
            | returnStatement
            | expression ;

// Function
functionDeclaration : Override? Function Id '(' functionDeclarationParameterList? ')' (':' type)? (compoundStatement | '=' expression)
                    | Abstract Function Id '(' functionDeclarationParameterList? ')' (':' type)? ;
functionDeclarationParameterList : Id (':' type)?
                                 | functionDeclarationParameterList ',' Id (':' type)? ;
functionCallStatement : (Id | type) ('(' functionCallArgumentList? ')' | compoundStatement) ('.' (functionCallStatement | variable))? ;
functionCallArgumentList : expression
                         | functionCallArgumentList ',' expression ;

// Class
classDeclaration : Abstract? Class Id ('(' classDeclarationArgumentList? ')')? classInheritance? compoundStatement ;
classDeclarationArgumentList : Mode? variable ':' type '?'?
                             | classDeclarationArgumentList ',' Mode variable ':' type '?'? ;
classInheritance : ':' (functionCallStatement (',' Id)? | Id) ;

// Interface
interfaceDeclaration : Interface Id compoundStatement ;

// Statement
statementBody : bodyElement
              | compoundStatement ;
compoundStatement : '{' body? '}' ;
returnStatement : Return expression? ;

// If
ifStatement : ifExpression
            | If '(' condition ')' statementBody ;
ifExpression : If '(' condition ')' statementBody Else statementBody ;

// For
forStatement : For '(' variable In (variable | range) ')' statementBody ;

// While
whileStatement : While '(' condition ')' statementBody ;

// When
whenStatement : When ('(' expression ')')? '{' whenList '}' ;
whenList : (whenCondition '->' statementBody)+ ;
whenCondition : expression
              | Else
              | '!'? Is type
              | '!'? In expression ;

// Type
type : Type '?'?
     | List '<' type '>' ;

// String
stringLiteral : '"' (stringReference | stringExpression | stringText)* '"' ;
stringReference : Dollar Id ;
stringExpression : Dollar '{' expression '}' ;
stringText : ~('\\' | '"' | Dollar)+ | ';' | '\'' | Dollar ;

// Range
range : expressionForRange (To | DownTo) expressionForRange (Step expressionForRange)?;

// Variable
variable : Id ('[' expression ']')? ('.' (functionCallStatement | variable))? ;

// Assign
assignStatement : Override? Mode Id (':' type | (':' type)? 'get()'? '=' expression) ;
assignmentExpression : variable '=' expression ;

// Condition
condition : (expressionForCondition | type) conditionOperator (expressionForCondition | type)
          | condition logicalOperator condition ;

// Operator
logicalOperator : '&&' | '||' ;
conditionOperator : '!'? ('>' | '<' | '==' | '<=' | '>=' | '!=' | Is | In) ;

// Expression
expression : whenStatement
           | stringLiteral
           | assignmentExpression
           | ifExpression
           | compoundStatement
           | expression '?:' expression
           | '(' expressionTerm ')'
           | expressionTerm
           | functionCallStatement
           | condition
           | range
           | variable;

expressionForCondition : stringLiteral
                       | variable
                       | ifExpression
                       | variable
                       | functionCallStatement
                       | range
                       | expressionForCondition '?:' expressionForCondition
                       | '(' expressionTerm ')'
                       | expressionTerm ;

expressionForRange : variable
                   | functionCallStatement
                   | expressionForRange '?:' expressionForRange
                   | '(' expressionTerm ')'
                   | expressionTerm ;

expressionTerm : expressionTerm ('+' | '-' | '+=' | '-=') expressionTerm
               | expressionFactor ;
expressionFactor : expressionFactor ('*' | '/' | '*=' | '/=') expressionFactor
                 | expressionElement ;
expressionElement : ('+' | '-')? functionCallStatement
                  | ('+' | '-')? variable ('++' | '--')?
                  | ('+' | '-')? ('++' | '--')? variable
                  | ('+' | '-')? unsignedNumericLiteral
                  | ('+' | '-')? '(' expression ')' ;

// Numeric
unsignedNumericLiteral : UnsignedDecimalLiteral 'L'?
                       | UnsignedDoubleLiteral ;

// ==========================================================
// Lexer rule
// ==========================================================

// Fragment
fragment Letter : [a-zA-Z_] ;
fragment Digit : [0-9] ;
fragment NonZeroDigit : [1-9] ;
fragment HexDigit : [0-9a-fA-F] ;

// Skip
WhiteSpace : [ \t]+ -> skip ;
Newline : ( '\r' '\n'? | '\n' ) -> skip ;
Coment : '//' (~[\r\n])* -> skip ;

// Keyword
Type : 'Int' | 'Unit' | 'Any' | 'Long' | 'String' | 'Double' | 'Boolean' ;
Dot : '.' ;
Package : 'package' ;
Import : 'import' ;
Function : 'fun' ;
If : 'if' ;
Else : 'else' ;
For : 'for' ;
To : '..' ;
DownTo : 'downTo' ;
Step : 'step' ;
While : 'while' ;
When : 'when' ;
Mode : 'val' | 'var' ;
List : 'List' ;
Return : 'return' ;
In : 'in' ;
Is : 'is' ;
Class : 'class' ;
Interface : 'interface' ;
Abstract : 'abstract' ;
Override : 'override' ;
Dollar : '$' ;

// General
Id : Letter (Letter | Digit)* ;
UnsignedDecimalLiteral : ('0' | NonZeroDigit Digit*) ;
UnsignedDoubleLiteral : (Digit* '.' Digit+ | UnsignedDecimalLiteral) ([eE] [+-]? Digit+)? ;