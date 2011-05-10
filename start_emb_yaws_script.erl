#!/usr/bin/env escript
%%! -pa ../../yaws/ebin/  

%% Stops after start. Use -detached.

main([]) ->
   yaws_emb_starter:start(). 
