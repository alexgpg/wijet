
class Client
	def initialize(a_hashArgs={})
		p 'Moc::Client.new #hash arg'
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
