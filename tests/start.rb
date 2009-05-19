#!/usr/bin/ruby1.8


#command for start fcgi application
system("cgi-fcgi","-start", "-connect", ":4000", "../works/web_io.fcgi")

