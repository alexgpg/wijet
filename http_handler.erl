-module(http_handler).
-export([start/0, stop/0]).

% start misultin http server
start() ->
    misultin:start_link([{port, 8080}, {loop, fun(Req) -> handle_http(Req) end}]).

% stop misultin
stop() ->
    misultin:stop().

% callback function called on incoming http request
handle_http(Req) ->
    % dispatch to rest
    handle(Req:get(method), Req:resource([lowercase, urldecode]), Req).

% handle a GET on /
handle('GET', [], Req) -> 
    Req:file("index.html");

handle('POST', ["login"], Req) ->
    io:format("headers:~n~p~n", [Req:get(headers)]),
    io:format("parse_post:~n~p~n", [Req:parse_post()]),
    
    [{"jid", JidString},{"password", Pass}] = Req:parse_post(),
    io:format("jid string:~n~p~n", [JidString]),
    io:format("password:~n~p~n", [Pass]),

    xmpp_proxy:start_under_sup(JidString, Pass),

    Req:ok("This is /login request");

handle('GET', [Filename], Req) ->
    Req:file(Filename);

% handle the 404 page not found
handle(_, _, Req) ->
    Req:ok([{"Content-Type", "text/plain"}], "Page not found."). % Not true. use code 404
    


