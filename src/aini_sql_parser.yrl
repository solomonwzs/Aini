Nonterminals
    val list expr alias field opt head tail.

Terminals
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

expr->expr 'and' expr:['$1', '$3', {opt, 'and'}].
expr->expr 'or' expr:['$1', '$3', {opt, 'or'}].
expr->expr '=' expr:['$1', '$3', {opt, '=='}].
expr->expr '>' expr:['$1', '$3', {opt, '>'}].
expr->expr '>=' expr:['$1', '$3', {opt, '>='}].
expr->expr '<' expr:['$1', '$3', {opt, '<'}].
expr->expr '<=' expr:['$1', '$3', {opt, '=<'}].
expr->expr '!' '=' expr:['$1', '$4', {opt, '=/='}].
expr->expr opt list:['$1', '$3', '$2'].
expr->'(' expr ')':['$2'].
expr->'not' expr:['$2', {opt, 'not'}].
expr->val:'$1'.

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
opt->atom:{opt, get_opt('$1')}.

Erlang code.
unwrap({_, V})->V;
unwrap({_, _, V})->V.

get_opt({atom, _, Opt})->
    case Opt of
        'in'->'in';
        _->unknow_opt
    end.
