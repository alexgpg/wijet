#!/usr/bin/ruby1.8
#!

require '../works/web_server'

server=WebServer.new
trap("INT"){ server.shutdown }

server.start
