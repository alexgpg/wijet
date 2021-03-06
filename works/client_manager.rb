require 'singleton'
require '../works/debug'
#Note:sid aka sessionId

$debug_level=10

class ClientManager
	include Singleton
	#ctor
	def initialize
 		dbgPrn 2, 'ClientManager.new'
		@lastSid=100000
		@clients={}
	end
	
	#add client in active user list
	def addClient(a_client)
		dbgPrn 2, 'ClientManager.addClient'
		sid=getNewSessionId
		a_client.jabberClient.fullInit
		@clients[sid]=a_client
		return sid
	end

	#delete user form active user list
	def delClient(a_sessionId)
		dbgPrn 2, 'ClientManager.delClient with id='+a_sessionId
		@clients[a_sessionId]=nil
	end
	
	def clear
		dbgPrn 2, 'ClientManager.clear'
		@clients.clear
	end
	
	#return client by sessionId
	def [](a_sessionId)
		dbgPrn 2, 'ClientManager.[]'
		return @clients[a_sessionId]
	end
	#not realised!!!!!
	def delNoActiveClients
		dbgPrn 2, 'ClientManager.delNoActiveClients'
		#empty
	end

	private
	def getNewSessionId()
		dbgPrn 2, 'ClientManager.getNewSessionId'
		@lastSid+=1
		return 'test_sid_'+(@lastSid.to_s+Time.now.to_s).hash.to_s
	end
	
	@clients	#Hash for contain clients
	@lastSid
end
