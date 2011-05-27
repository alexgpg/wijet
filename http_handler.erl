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

handle('POST', ["xmpp"], Req) ->
    Headers = Req:get(headers),
    io:format("Headers:~n~p~n", [Headers]),
    Post = Req:parse_post(),
    io:format("Post:~n~p~n", [Post]),
    Cookie = proplists:get_value('Cookie', Headers),
    io:format("Cookie:~n~p~n", [Cookie]),
    handle_xmpp(Post, Cookie, Req);
    

handle('POST', ["login"], Req) ->
    Headers = Req:get(headers),
    io:format("Headers:~n~p~n", [Headers]),
    Post = Req:parse_post(),
    io:format("Post:~n~p~n", [Post]),
    Cookie = proplists:get_value('Cookie', Headers),
    io:format("Cookie:~n~p~n", [Cookie]),

    [{PostKey, _PostValue}] = Post,
    io:format("PostKey:~n~p~n", [PostKey]),
    ParsedJson = rfc4627:decode(PostKey),
    io:format("ParsedJson:~n~p~n", [ParsedJson]),
    
    case ParsedJson of
        {ok,{obj,[{"type",<<"login">>},
              {"data",
                {obj,[{"jid", Jid},
                {"pass", Pass }]}}]}, [] } ->
                    login(Req, Jid, Pass);
        {ok,{obj,[{"type",<<"logout">>}]},[]} ->
                    logout(Req, Cookie)
    end;

% Handling of static files
handle('GET', [Filename], Req) ->
    io:format("GET: Filename:~n~p~n", [Filename]),
    Req:file(Filename);

handle('GET', [Dir, Filename], Req) ->
    io:format("GET: Filename2:~n~p/~p~n", [Dir, Filename]),
    Req:file(Dir ++ "/" ++ Filename);

handle('GET', [Dir, Subdir,Filename], Req) ->
    io:format("GET: Filename3:~n~p/~p/~p~n", [Dir, Subdir,Filename]),
    Req:file(Dir ++ "/" ++ Subdir ++ "/" ++ Filename);

% handle the 404 page not found
handle(_, XZ, Req) ->
    io:format("GET: XZ:~n~p~n", [XZ]),
    Req:ok([{"Content-Type", "text/plain"}], "Page not found."). % FIXME: Not true. use code 404 code.

% -----------------------------------------------------------------------------
login(Req, Jid, Pass) ->
    io:format("Jid:~n~p~n", [Jid]),
    io:format("Pass:~n~p~n", [Pass]),

    case xmpp_proxy:start_under_sup(Jid, Pass) of
        {ok, XmppProxyPid } ->
            {ok, NewCookie }  = sessions:new_session(XmppProxyPid),
            NewHeaders = [{"Content-Type", "text/plain"}, {"Set-Cookie","wijet=" ++ NewCookie}],
            Response =  rfc4627:encode({obj, [{"login", <<"ok">>}]}),
            Req:respond(200, NewHeaders, Response);
        _ ->
            Response =  rfc4627:encode({obj, [{"login", <<"failed">>}]}),
            Req:respond(200,  [{"Content-Type", "text/plain"}], Response)
    end.
 
 % ----------------------------------------------------------------------------
logout(Req, Cookie) ->
    % Parse cookie
    % TODO: Use normal cookie parser.
    "wijet=" ++ CookieValue = Cookie,
    % exmple cookie: "wijet=/qV32FipwZ282SjtQaU/pg=="
    io:format("CookieVal:~n~p~n", [CookieValue]),
    case sessions:get_session(CookieValue) of
        {ok, not_found} ->
            Response = rfc4627:encode({obj, [{"logout", <<"not logged in">>}]});
        {ok, XmppProxyPid} ->
            xmpp_proxy:stop(XmppProxyPid),
            sessions:delete_session(CookieValue),
            Response = rfc4627:encode({obj, [{"logout", <<"ok">>}]})
    end,
    Req:respond(200,  [{"Content-Type", "text/plain"}], Response).

% -----------------------------------------------------------------------------
handle_xmpp(Post, Cookie, Req) ->
    [{"body" , PostBody}] = Post,
    io:format("handle_xmpp: PostBody:~n~p~n", [PostBody]),

    % Parse cookie
    % TODO:  Use normal cookie parser.
    "wijet=" ++ CookieValue = Cookie,

    case sessions:get_session(CookieValue) of
        {ok, not_found} ->
            Response = "handle_xmpp: not_found";
        {ok, XmppProxyPid} ->
            xmpp_proxy:push(XmppProxyPid, PostBody),
            Response = "handle_xmpp: pushed"
    end,
    Req:respond(200,  [{"Content-Type", "text/plain"}], Response).
