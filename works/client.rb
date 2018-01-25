require '../works/auth_info'
require '../works/jabber_client'

class Client
	def initialize(a_hashArgs={})
# 		p 'Client.new #hash arg'
		@jabberClient=JabberClient.new(a_hashArgs[:jid],a_hashArgs[:password],a_hashArgs[:server],a_hashArgs[:port])
		@auth=AuthInfo.new
	end

	def connect
# 		p '!Client.connect'
		@jabberClient.connect
	end

	def jabberClient
# 		p 'Client.jabberClient'
		return @jabberClient
	end

	def auth
# 		p 'Client.auth'
		return @auth
	end

	@jabberClient
	@auth
	
end

