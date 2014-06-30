-ifndef(__AINI_HRL__).
-define(__AINI_HRL__, 1).

-define(PARSER_YRL_LIST, ["./src/aini_sql_parser.yrl"]).

-define(log(Format, Args),
        io:format("\033[00;33m~p [~s:~b]~n\033[0m"++Format,
                  [erlang:localtime(), ?FILE, ?LINE|Args])).

-endif.
