#Moc JabberClient
class JabberClient
public
	#ctor
	def initialize(a_jid, a_pass, a_server, a_port)
		p "JabberClient.new #jid=#{a_jid}, pass=#{a_pass}, server=#{a_server},port=#{a_port}"
		@a=1
	end
	#dev-status: in work, but works
	def fullInit
		p 'JabberClient.fullInit'
	end
	
	##
	#Connect to server
	#Can throw exception
	def connect
		p 'JabberClient.connect'
		true
	end
	
	##
	#End of session
	def closeConnection
		p 'JabberClient.closeConnection'
	end
	
	def setStatus(a_show=nil, a_status=nil, a_priority=nil)
		p "JabberClient.setStatus #s "
	end
	
	def sendMessage(a_to,a_text,a_type,a_subject=nil)
		p 'JabberClient.sendMessage'	
	end
	#Syntax sugar for sendMessage(to,text,:chat)
	def sendChatMessage(a_to, a_text)
		p 'JabberClient.sendChatMessage'
	end
	
	def addContact(a_jid, a_nick=nil, a_subscribe=false)

	end
	
	def delContact(a_jid)

	end

	def eachIncomingMessages(&a_closure)

	end
	
	def eachJIDinRoster(&a_closure)

	end
	
	def eachPresences(&a_closure)

	end
	@a
end