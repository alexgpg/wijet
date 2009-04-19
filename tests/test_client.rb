#!/usr/bin/ruby1.8
#!

require 'test/unit'
require '../works/client'

class TestClient < Test::Unit::TestCase
	def test_1
		client=Client.new( 
				:jid	  => "test@jabber.port13.lan/321",
				:password =>  "123456",
				:server   =>  "jabber.port13.lan",
				:port     =>  5222)
		client.connect
	end

end