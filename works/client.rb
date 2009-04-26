require '../works/auth_info'
require '../works/jabber_client'
require '../works/executer_request'

class Client
	def initialize(a_hashArgs={})
		p 'Client.new #hash arg'
		@jabberClient=JabberClient.new(a_hashArgs[:jid],a_hashArgs[:password],a_hashArgs[:server],a_hashArgs[:port])
		@auth=AuthInfo.new
	end

	def connect
		p '!Client.connect'
		@jabberClient.connect
	end

	def runRequest(a_parsedRequest)
		p 'Client.runRequest'
		ExecuterRequest.instance.run(a_parsedRequest,@jabberClient)
	end
	
	def jabberClient
		p 'Client.jabberClient'
		return @jabberClient
	end

	def auth
		p 'Client.auth'
		return @auth
	end

	@jabberClient
	@auth
	
end

