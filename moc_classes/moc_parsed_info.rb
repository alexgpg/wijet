#moc Parsed Info
class ParsedInfo
	def initialize
	end
	def data
		return {"success"=>"true",
			"sid"=> "1234324"}
	#	return {"success"=>"false",
	#
	end

	def jid
		return "test@jabber.port13.lan"
	end
	
	def server
		return "81.91.180.150"
	end

	def pass
		return "123456"
	end
	
	def sessionId
		return '11111111'
	end

	def ParsedInfo.loginFailed(a_error)
		return nil
	end


	def ParsedInfo.loginSuccessfully(a_sid)
		return nil
	end


	def data=(a_data)
		@data=a_data
	end
	@data
end
