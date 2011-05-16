Build and start

$ erlc http_handler.erl xmpp_proxy.erl xmpp_proxy_sup.erl &&  erl -pa
misultin/ebin/

Start:
erl>xmpp_proxy_sup:start().
erl>http_handler:start().

