-module(xmpp_proxy).

-export([start/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, 
    code_change/3, terminate/2]).

-behaviour(gen_server).

-include_lib("exmpp/include/exmpp_client.hrl").

% -----------------------------------------------------------------------------
% API
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
start(Jid, Password) ->
    gen_server:start_link(?MODULE, [Jid, Password], []).

% -----------------------------------------------------------------------------
% Callbacks
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
init([Jid, Password]) ->
    application:start(exmpp),
    Session = exmpp_session:start(),
    exmpp_session:auth_basic_digest(Session, Jid, Password),
    [{Host, Port} | _ ] = exmpp_dns:get_c2s(exmpp_jid:domain_as_list(Jid)),
    exmpp_session:connect_TCP(Session, Host, Port),
    {ok, _Jid} =  exmpp_session:login(Session),
    exmpp_session:send_packet(Session,
                            exmpp_presence:set_status(
                            exmpp_presence:available(), "Erlang rulez!")),
    {ok, nil}.

% -----------------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

% -----------------------------------------------------------------------------
handle_cast(_Request, State) ->
    {noreply, State}.

% -----------------------------------------------------------------------------
handle_info(XmppMsg = #received_packet{}, State) ->
        io:format("New received_packet ~p~n", [XmppMsg]), % DEBUG
        {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

% -----------------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

% -----------------------------------------------------------------------------
code_change(_oldVsn, State, _Extra) ->
    {ok, State}.

