#!/usr/bin/ruby1.8
#!

require '../works/client_manager'
require 'test/unit'


class TestClientManager < Test::Unit::TestCase
	def test_simple
		#singleton test
		cm=ClientManager.instance
		otherCm=ClientManager.instance
		assert_equal(cm, otherCm,"singleton test")
		#end
	
		#adding correct test
		newClient=Client.new("jid@jid.ru","password","server.org")
		sid=cm.addClient(newClient)
		assert_equal(newClient,cm[sid],"adding correct test")
		#end

		#deleting correct test
		cm.delClient(sid)
		assert_equal(cm[sid],nil,"deleting correct test")
		#end

		#test adding and clearing
		client1=Client.new("jid1@jid.ru", "pass", "server.org")
		client2=Client.new("jid2@jid.ru", "pass", "server.org")
		client3=Client.new("jid3@jid.ru", "pass", "server.org")
		client4=Client.new("jid4@jid.ru", "pass", "server.org")
		sid1=ClientManager.instance.addClient(client1)
		sid2=ClientManager.instance.addClient(client2)
		assert_equal(client1,ClientManager.instance[sid1],"1")
		assert_equal(client2,ClientManager.instance[sid2],"2")
		
		assert_not_equal(client3,ClientManager.instance[sid1],"3")
		assert_not_equal(client4,ClientManager.instance[sid2],"4")

		sid3=ClientManager.instance.addClient(client3)
		sid4=ClientManager.instance.addClient(client4)
		#test clear
		ClientManager.instance.clear
		cm=ClientManager.instance
		assert_equal(nil, cm[sid1], "5")
		assert_equal(nil, cm[sid2], "6")
		assert_equal(nil, cm[sid3], "7")
		assert_equal(nil, cm[sid4], "8")
		#end
	end

end


