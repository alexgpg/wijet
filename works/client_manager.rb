require 'singleton'

#Note:sid aka sessionId

class ClientManager
	include Singleton
	#ctor
	def initialize
# 		p 'ClientManager.new'
		@lastSid=100000
		@clients={}
	end
	
	#add client in active user list
	def addClient(a_client)
# 		p 'ClientManager.addClient'
		sid=getNewSessionId
		a_client.jabberClient.fullInit
		@clients[sid]=a_client
		return sid
	end

	#delete user form active user list
	def delClient(a_sessionId)
# 		p 'ClientManager.delClient with id='+a_sessionId
		@clients[a_sessionId]=nil
	end
	
	def clear
# 		p 'ClientManager.clear'
		@clients.clear
	end
	
	#return client by sessionId
	def [](a_sessionId)
# 		p 'ClientManager.[]'
		return @clients[a_sessionId]
	end
	#not realised!!!!!
	def delNoActiveClients
# 		p 'ClientManager.delNoActiveClients'
		#empty
	end

	private
	def getNewSessionId()
# 		p 'ClientManager.getNewSessionId'
		@lastSid+=1
		return 'test_sid_'+(@lastSid.to_s+Time.now.to_s).hash.to_s
	end
	
	@clients	#Hash for contain clients
	@lastSid
end
