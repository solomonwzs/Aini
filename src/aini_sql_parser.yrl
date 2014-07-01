Nonterminals
    val list expr head tail cond columns column tables
    extend.


Terminals
    'select' 'from' 'where' 'as'
    '(' ')' 'and' 'or' 'not' 'in' '=' '>' '>=' '<=' '<' '!=' '.' 'variable'
    '[' ']' 'integer' 'float' 'string' 'bitstring' ',' '-' '*'.


Rootsymbol
    expr.

Left 100 'or'.
Left 110 'and'.
Nonassoc 200 '=' '!=' '>' '>=' '<=' '<'.
Unary 300 'not'.
Left 400 '(' ')'.
Left 410 '.'.

expr->'select' columns 'from' tables:[select, {fields, '$2'}, {from, '$4'}].
expr->'select' columns 'from' tables extend:[select, {fields, '$2'}, {from, '$4'}|'$5'].

columns->column:['$1'].
columns->column ',' columns:['$1'|'$3'].

column->variable '.' variable:{unwrap('$1'), unwrap('$3')}.
column->variable '.' '*':{unwrap('$1'), '*'}.

tables->variable 'as' variable:[{unwrap('$1'), unwrap('$3')}].
tables->variable 'as' variable ',' tables:[{unwrap('$1'), unwrap('$3')}|'$5'].

extend->'where' cond:[{'cond', '$2'}].

cond->cond 'and' cond:['$1', '$3', {opt, 'and'}].
cond->cond 'or' cond:['$1', '$3', {opt, 'or'}].
cond->cond '=' cond:['$1', '$3', {opt, '=:='}].
cond->cond '>' cond:['$1', '$3', {opt, '>'}].
cond->cond '>=' cond:['$1', '$3', {opt, '>='}].
cond->cond '<' cond:['$1', '$3', {opt, '<'}].
cond->cond '<=' cond:['$1', '$3', {opt, '=<'}].
cond->cond '!=' cond:['$1', '$3', {opt, '=/='}].
cond->cond 'in' list:['$1', '$3', {opt, 'in'}].
cond->'(' cond ')':['$2'].
cond->'not' cond:['$2', {opt, 'not'}].
cond->val:'$1'.

val->column:{identifier, '$1'}.
val->integer:{integer, unwrap('$1')}.
val->float:{float, unwrap('$1')}.
val->bitstring:{bitstring, unwrap('$1')}.
val->string:{string, unwrap('$1')}.
val->'-' integer:{integer, -unwrap('$2')}.
val->'-' float:{float, -unwrap('$2')}.

list->'[' ']':{list, []}.
list->'[' head ']':{list, ['$2']}.
list->'[' head tail ']':{list, ['$2'|'$3']}.

head->integer:unwrap('$1').
head->float:unwrap('$1').
head->'-' integer:(-unwrap('$2')).
head->'-' float:(-unwrap('$2')).
head->string:unwrap('$1').

tail->',' head:['$2'].
tail->',' head tail:['$2'|'$3'].


Erlang code.

unwrap({_, V})->V;
unwrap({_, _, V})->V.
