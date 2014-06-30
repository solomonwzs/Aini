Definitions.

DIGIT       =[0-9]
LETTER      =[A-Za-z]
HEX         =0[x|X][0-9A-Fa-f]+
WHITESPACE  =([\000-\s]|%.*)


Rules.

select :{token, {'select', TokenLine}}.
from :{token, {'from', TokenLine}}.
where :{token, {'where', TokenLine}}.
\. :{token, {'.', TokenLine}}.

{LETTER}({DIGIT}|{LETTER}|_)* :
    {token, {variable, TokenLine, TokenChars}}.

{DIGIT}+ :
    {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{DIGIT}+\.{DIGIT}+((E|e)(\+|\-)?{DIGIT}+)? :
    {token, {float, TokenLine, list_to_float(TokenChars)}}.

{WHITESPACE}+ :
    skip_token.


Erlang code.
