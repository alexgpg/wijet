require '../works/auth_info'
require '../moc_classes/moc_jabber_client'
require '../moc_classes/moc_executer_request'

#not tested!!!!
class Client
	def initialize(a_hashArgs={})
		p 'Client.new #hash arg'
		@jabberClient=JabberClient.new(a_hashArgs[:jid],a_hashArgs[:password],a_hashArgs[:server],a_hashArgs[:port])
		@auth=AuthInfo.new
	end

	def connect
		@jabberClient.connect
	end

	def runRequest(a_parsedRequest)
		@@executerRequest.run(a_parsedRequest,@jabberClient)
	end
	
	def jabberClient
		return @jabberClient
	end

	def auth
		return @auth
	end

	@jabberClient
	@auth
	
	@@executerRequest=ExecuterRequest.new
end

