-module(xmpp_proxy).

-export([start/2, start_under_sup/2, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, 
    code_change/3, terminate/2]).

-behaviour(gen_server).

-include_lib("exmpp/include/exmpp_client.hrl").

% -----------------------------------------------------------------------------
% API
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
start(JidStr, Password) ->
    gen_server:start_link(?MODULE, [JidStr, Password], []).

% -----------------------------------------------------------------------------
start_under_sup(JidStr, Password) ->
    supervisor:start_child(xmpp_proxy_sup, [JidStr, Password]).

% ----------------------------------------------------------------------------
stop(Pid) ->
   gen_server:call(Pid, stop).
    
% -----------------------------------------------------------------------------
% Callbacks
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
init([JidStr, Password]) ->
    application:start(exmpp), % FIXME: not true start expp application.
    Jid = exmpp_jid:parse(JidStr),
    Session = exmpp_session:start(),
    exmpp_session:auth_basic_digest(Session, Jid, binary_to_list(Password)),
    [{Host, Port} | _ ] = exmpp_dns:get_c2s(exmpp_jid:domain_as_list(Jid)),
    exmpp_session:connect_TCP(Session, Host, Port),
    {ok, _Jid} =  exmpp_session:login(Session),
    exmpp_session:send_packet(Session,
                            exmpp_presence:set_status(
                            exmpp_presence:available(), "Erlang rulez!")),
    {ok, {state, Session}}.

% -----------------------------------------------------------------------------
handle_call(stop, _From, State) ->
    {stop, normal, {ok, stopped}, State};    

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

% -----------------------------------------------------------------------------
handle_cast(_Request, State) ->
    {noreply, State}.

% -----------------------------------------------------------------------------
handle_info(XmppMsg = #received_packet{}, State) ->
        %io:format("New received_packet ~p~n", [XmppMsg]), % DEBUG
        {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

% -----------------------------------------------------------------------------
terminate(_Reason, State) ->
    {state, Session} = State,
    exmpp_session:stop(Session),
    ok.

% -----------------------------------------------------------------------------
code_change(_oldVsn, State, _Extra) ->
    {ok, State}.

