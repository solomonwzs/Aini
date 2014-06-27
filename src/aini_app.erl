-module(aini_app).

-behaviour(application).

-include("aini.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    aini_sup:start_link().

stop(_State) ->
    ok.
