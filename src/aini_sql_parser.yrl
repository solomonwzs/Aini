Nonterminals
    val list expr alias field opt head tail cond columns tables
    extend.

Terminals
    'select' 'from' 'where' 'as'
    '(' ')' 'and' 'or' 'not' '=' '>' '>=' '<=' '<' '!' '.' 'atom'
    '[' ']' 'integer' 'float' 'string' ',' '-' '*'.

Rootsymbol
    expr.

Left 100 'or'.
Left 110 'and'.
Nonassoc 200 '=' '!' '>' '>=' '<=' '<'.
Unary 300 'not'.
Left 400 '(' ')'.
Left 410 '.'.

expr->'select' columns 'from' tables:[select, {fields, '$2'}, {from, '$4'}].
expr->'select' columns 'from' tables extend:[select, {fields, '$2'}, {from, '$4'}|'$5'].

columns->alias '.' field:[{'$1', '$3'}].
columns->alias '.' field ',' columns:[{'$1', '$3'}|'$5'].

tables->atom 'as' atom:[{unwrap('$1'), unwrap('$3')}].
tables->atom 'as' atom ',' tables:[{unwrap('$1'), unwrap('$3')}|'$5'].

extend->'where' cond:[{'cond', $2}].

cond->cond 'and' cond:['$1', '$3', {opt, 'and'}].
cond->cond 'or' cond:['$1', '$3', {opt, 'or'}].
cond->cond '=' cond:['$1', '$3', {opt, '=='}].
cond->cond '>' cond:['$1', '$3', {opt, '>'}].
cond->cond '>=' cond:['$1', '$3', {opt, '>='}].
cond->cond '<' cond:['$1', '$3', {opt, '<'}].
cond->cond '<=' cond:['$1', '$3', {opt, '=<'}].
cond->cond '!' '=' cond:['$1', '$4', {opt, '=/='}].
cond->cond opt list:['$1', '$3', '$2'].
cond->'(' cond ')':['$2'].
cond->'not' cond:['$2', {opt, 'not'}].
cond->val:'$1'.

val->alias '.' field:{identifier, {'$1', '$3'}}.
val->alias '.' '*':{identifier, {'$1', '*'}}.
val->integer:{integer, unwrap('$1')}.
val->float:{float, unwrap('$1')}.
val->'-' integer:{integer, -unwrap('$2')}.
val->'-' float:{float, -unwrap('$2')}.
val->string:{string, unwrap('$1')}.
val->atom:{atom, unwrap('$1')}.

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

alias->atom:unwrap('$1').

field->atom:unwrap('$1').

opt->atom:{opt, sql_keyword('$1')}.

Erlang code.
unwrap({_, V})->V;
unwrap({_, _, V})->V.

sql_keyword({atom, _, 'in'})->'in';
sql_keyword({atom, _, 'select'})->'select'.
