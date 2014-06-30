-module(aini_sql).
-include("aini.hrl").
-compile([export_all]).


t(Str)->
    {_, Token, _}=erl_scan:string(Str),
    ?log("~p~n", [Token]),
    {ok, ExprList}=aini_sql_parser:parse(Token),
    ExprList.


-spec string_eval(string())->term().
string_eval(String)->
    {ok, Scanned, _}=erl_scan:string(String),
    {ok, Parsed}=erl_parse:parse_exprs(Scanned),
    {value, Val, _}=erl_eval:exprs(Parsed, []),
    Val.
