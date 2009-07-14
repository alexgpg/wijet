#!/usr/bin/ruby1.8
#!

require '../works/requirer'
require 'test/unit'
require '../works/client'

requireWithGems 'mocha'

class TestClient < Test::Unit::TestCase
	def test_success_connect
		JabberClient.any_instance.stubs(:connect).returns(true)

		client=Client.new( 
				:jid	  => 'somejid@jabber.im',
				:password =>  'somepassword',
				:server   =>  "jabber.port13.lan",
				:port     =>  5222)
 		assert_nothing_raised{client.connect}
	end

	def test_fail_connect
		JabberClient.any_instance.stubs(:connect).raises('login_error')
		client=Client.new( 
				:jid	  => "test@jabber.port13.lan/321",
				:password =>  "123456",
				:server   =>  "jabber.port13.lan",
				:port     =>  5222)
		assert_kind_of(AuthInfo,client.auth)
		assert_kind_of(JabberClient,client.jabberClient)
		assert_raise RuntimeError do
			client.connect
		end
	end

end