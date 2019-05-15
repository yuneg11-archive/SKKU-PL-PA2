/* Kotlin Basic Syntax */
grammar Kotlin;

//Parser rules
prog: funcList?;
funcList: function+;
function: 'fun' Id '(' paramList? ')' compoundStmt;
identifier: Id;
paramList: identifier ':' Type | paramList ',' identifier ':' Type;
compoundStmt: '{' stmtList? '}';
stmtList: stmt+;
stmt: callStmt; //| assignStmt | retStmt | whileStmt | forStmt | ifStmt | whenStmt | compoundStmt| ... ;
callStmt: call;
call: Id '(' argList? ')';
expr: call | stringLiteral;
argList: expr | argList ',' expr;
stringLiteral: '"' (stringContent | stringExpression)* '"';
stringContent: strText | strRef;
stringExpression: '${' expr '}';
strText: ~('\\' | '"' | '$')+ | '$';
strRef: '$' Id;


//Lexer rules
Type: 'Int' | 'Unit' | 'Any' | 'Long' | 'String' | 'Double' | 'Boolean';
Id: [A-Za-z]+[0-9]*;
WhiteSpace : [ \t]+ -> skip;
Newline : ( '\r' '\n'? | '\n' ) -> skip;
