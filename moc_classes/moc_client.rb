
class Client
	def initialize(a_jid,a_password, a_server, a_port=5222)
		@jabberClient=JabberClient.new
	end
	def jabberClient
		return @jabberClient
	end
	@jabberClient
end

class JabberClient
	def fullInit
		p 'JabberClient.fullInit'
	end
end
