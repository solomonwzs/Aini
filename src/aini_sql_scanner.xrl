Definitions.

DIGIT       =[0-9]
LETTER      =[A-Za-z]
HEX         =0[x|X][0-9A-Fa-f]+
WHITESPACE  =([\000-\s]|%.*)
SYMBOL      =(\.|\+|\-|\*|\/|=|>|<|\(|\)|\[|\]|\{|\}|\,|<<|>>|>=|<=|\!=)
KEYWORD     =(select|from|where|and|or|not|in|as)


Rules.

{SYMBOL} :{token, {list_to_atom(TokenChars), TokenLine}}.
{KEYWORD} :{token, {list_to_atom(TokenChars), TokenLine}}.

".*" :
    Str=lists:sublist(TokenChars, 2, TokenLen-2),
    {token, {string, TokenLine, Str}}.
<<".*">> :
    Str=lists:sublist(TokenChars, 4, TokenLen-6),
    {token, {bitstring, TokenLine, list_to_bitstring(Str)}}.

{LETTER}({DIGIT}|{LETTER}|_)* :
    {token, {variable, TokenLine, TokenChars}}.

{DIGIT}+ :
    {token, {integer, TokenLine, list_to_integer(TokenChars)}}.
{DIGIT}+\.{DIGIT}+((E|e)(\+|\-)?{DIGIT}+)? :
    {token, {float, TokenLine, list_to_float(TokenChars)}}.

{WHITESPACE}+ :
    skip_token.


Erlang code.
