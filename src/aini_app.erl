-module(aini_app).

-behaviour(application).

-include("aini.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    lists:foreach(
      fun(F)->
              [$l, $r, $y|Tail]=lists:reverse(F),
              ErlFile=lists:reverse(Tail)++"erl",
              yecc:yecc(F, ErlFile)
      end, ?PARSER_YRL_LIST),
    aini_sup:start_link().

stop(_State) ->
    ok.
