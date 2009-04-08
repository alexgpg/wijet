#!/usr/bin/ruby1.8
!#

require '../works/jabber_client'
require 'test/unit'


#class fo testing class JabberClient
class Jc_test < Test::Unit::TestCase
	def test_simple
		#true connect
		client=JabberClient.new("killer@jabber.port13.lan","ntfsUTF8","jabber.port13.lan",5222)
		res=client.connect
		print 'res='+res.inspect
		assert_equal(res[0],true,"connect test")
		client.closeConnection
		#end
		#failure connect (incorrect password)
		client=JabberClient.new("killer@jabber.port13.lan","88","jabber.port13.lan",5222)
		res=client.connect
		print 'res='+res.inspect
		assert_equal(res[0],false,"connect test with left password")
		#status test
		client=JabberClient.new("killer@jabber.port13.lan/132","ntfsUTF8","jabber.port13.lan",5222)
		res=client.connect
		assert_equal(res[0],true,"connect test222")
		client.setStatus(:xa,"test_status",-127)
		#client.closeConnection
		#end
		#sending messages
		#client.sendMessage("killer@jabber.port13.lan","normal message1",:normal,"subj")
		#client.sendMessage('killer@jabber.port13.kan',"chat   message", :chat)
		client.fullInit
		client.sendChatMessage('killer@jabber.port13.lan',"chat   message")
=begin
		trap("INT"){ 	puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
				client.eachIncomingMessages{|from,text|
				puts from+':'+text
			}
			client.closeConnection()
		}
=end
		Thread.stop
		client.closeConnection()
		#end
	end

end



