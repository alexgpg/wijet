require '../works/auth_info'
require '../moc_classes/moc_jabber_client'
require '../moc_classes/moc_executer_request'

class Client
	def initialize(a_hashArgs={})
		p 'Client.new #hash arg'
		@jabberClient=JabberClient.new(a_hashArgs[:jid],a_hashArgs[:password],a_hashArgs[:server],a_hashArgs[:port])
		@auth=AuthInfo.new
	end

	def connect
		p 'Client.connect'
		@jabberClient.connect
	end

	def runRequest(a_parsedRequest)
		p 'Client.runRequest'
		@@executerRequest.run(a_parsedRequest,@jabberClient)
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
	
	@@executerRequest=ExecuterRequest.new
end

