%% Only for test!

-module(yaws_emb_starter).
-export([start/0]).

-define(DEBUG_FLAG, true).
-define(YAWS_INSTANCE_NAME, "yaws_embedded").

-include("yaws/include/yaws.hrl").

-include_lib("eunit/include/eunit.hrl").

% -----------------------------------------------------------------------------
start() ->
    ok = application:set_env(yaws, embedded, true),
    ok = application:start(yaws),
    GC_Default = yaws_config:make_default_gconf(?DEBUG_FLAG, ?YAWS_INSTANCE_NAME),

    Port = 9999,

    SC = yaws_config:make_default_sconf(),
    NewSC = SC#sconf{port = Port},
    yaws_api:setconf(GC_Default, [[NewSC]]).


% -----------------------------------------------------------------------------
% Tests.
% -----------------------------------------------------------------------------

start_test() ->
    start().
