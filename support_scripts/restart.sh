#!/bin/sh

pkill web_io; sleep 2 && cgi-fcgi -start -connect :4000 ../works/web_io.fcgi

