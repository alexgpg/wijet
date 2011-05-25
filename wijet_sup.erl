-module(wijet_sup).

-export([
   start/0 
]).

% -----------------------------------------------------------------------------
% FIXME: Not true start process. Use supervisor behaviour.
start() ->
    {ok, _ } = xmpp_proxy_sup:start(),
    {ok, _ } = http_handler:start(),
    {ok, _ } = sessions:start_link().
    
