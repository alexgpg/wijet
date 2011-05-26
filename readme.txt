Note:
Download jquery.json-2.2.js from
http://code.google.com/p/jquery-json/
using download_jquery_json.sh

Get, build and run.

Get:
1) Get projet sources:
$ git clone git://github.com/alexgpg/wijet.git
2) Get libraries code:
$ git submodule init
$ git submodule update

$ download_jquery_json.sh
3) Build all libraries

Build project:
$ erlc http_handler.erl xmpp_proxy.erl xmpp_proxy_sup.erl sessions.erl
wijet_sup.erl

Run:

$ erl -pa misultin/ebin/ erlang-rfc4627/ebin/ exmpp/ebin/
erl>wijet_sup:start().




