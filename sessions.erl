-module(sessions).
% TODO: Add expire time.
% TODO: Add auto clean.
% TODO: Add doc for functions.
% TODO: Add missing gen_server callbacks. 
-behaviour(gen_server).

-export([
    start_link/0,
    stop/0,
    new_session/1,
    get_session/1,
    delete_session/1]).

-export([init/1, handle_call/3, terminate/2]).
%handle_call/3, handle_cast/2]).

-include_lib("eunit/include/eunit.hrl").

% -----------------------------------------------------------------------------
% API
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

% ----------------------------------------------------------------------------
% Only for tests.
stop() ->
    gen_server:call(?MODULE, stop).

% -----------------------------------------------------------------------------
% -> {ok, CookieVal}
new_session(Data) ->
    gen_server:call(?MODULE, {new_session, Data}).

% -----------------------------------------------------------------------------
% -> {ok, Data} | {ok, not_found}
get_session(CookieVal) ->
    gen_server:call(?MODULE, {get_session, CookieVal}).

% ----------------------------------------------------------------------------
% -> {ok, deleted}
delete_session(CookieVal) ->
    gen_server:call(?MODULE, {delete_session, CookieVal}).

% -----------------------------------------------------------------------------
% Callbacks
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
init(_Args) ->
    ets:new(?MODULE, [set, protected,  named_table]),
    {ok, nothing}.

% -----------------------------------------------------------------------------
handle_call({new_session, Data}, _From, State) ->
    application:start(crypto), % FIXME: not true init application.
    Sid = crypto:rand_bytes(16),
    ets:insert_new(?MODULE, {Sid, Data}),
    Base64Sid = base64:encode_to_string(Sid),
    {reply, {ok, Base64Sid}, State};

handle_call({get_session, CookieVal}, _From, State) ->
    Return = try
        Sid = base64:decode(CookieVal),
        case ets:lookup(?MODULE, Sid) of
            [{Sid, Data}] -> Data;
            [] -> not_found
        end
    catch
        _:_ -> not_found    
    end,
    {reply, {ok, Return}, State};
    
handle_call({delete_session, CookieVal}, _From, State) ->
   try
        Sid = base64:decode(CookieVal),
        ets:delete(?MODULE, Sid)
    catch
        _:_ -> true
    end,
    {reply, {ok, deleted}, State};
 

handle_call(stop, _From, State) ->
    {stop, normal, {ok, stopped}, State}.
    

% -----------------------------------------------------------------------------
terminate(normal, _State) ->
    io:format("terminate normal~n", []).

% -----------------------------------------------------------------------------
% Tests
% -----------------------------------------------------------------------------
start_stop_test() ->
    {ok, _Pid} = sessions:start_link(),
    {ok,stopped} = sessions:stop().

new_session_test() ->
    {ok, _Pid} = sessions:start_link(),
    {ok, _Base64Sid} = sessions:new_session(test_data),
    {ok,stopped} = sessions:stop().

error_base64_test() ->
    {ok, _Pid} = sessions:start_link(),
    {ok, not_found} = sessions:get_session("a"),
    {ok,stopped} = sessions:stop().

new_and_found_test() ->
    {ok, _Pid} = sessions:start_link(),
    {ok, Base64Sid} = sessions:new_session(test_data),
    {ok, test_data} = sessions:get_session(Base64Sid),
    {ok,stopped} = sessions:stop().

delete_bad_base64_test() ->
    {ok, _Pid} = sessions:start_link(),
    {ok, deleted} = sessions:delete_session("a"),
    {ok,stopped} = sessions:stop().

delete_test() ->
    {ok, _Pid} = sessions:start_link(),
    % Add
    {ok, Base64Sid} = sessions:new_session(test_data),
    % Find
    {ok, test_data} = sessions:get_session(Base64Sid),
    % Delete
    {ok, deleted} = sessions:delete_session(Base64Sid),
    % Not found
    {ok, not_found} = sessions:get_session(Base64Sid),
    {ok,stopped} = sessions:stop().


