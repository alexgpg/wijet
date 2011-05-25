Download jquery.json-2.2.js from
http://code.google.com/p/jquery-json/

Build and run.


Buid:
$ erlc http_handler.erl xmpp_proxy.erl xmpp_proxy_sup.erl sessions.erl wijet_sup.erl &&  erl -pa misultin/ebin/ erlang-rfc4627/ebin/

Run:
erl>wijet_sup:start().




