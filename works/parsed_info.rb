
class ParsedInfo
	def initialize
	end
	def data
		return @data
	end

	def jid
		res=@data[0]["value"]
		return res
	end
	
	def server
		return "81.91.180.150"
	end

	def pass
		res=@data[1]["value"]
		return res
	end
	
	def sessionId
		return @data['session_id']
	end

	def ParsedInfo.loginFailed(a_error)
		res=ParsedInfo.new
		res.data={"session_id" => "null"}
		return res
	end


	def ParsedInfo.loginSuccessfully(a_sid)
		res=ParsedInfo.new
		res.data={"session_id" => a_sid}
		return res
	end

	def data=(a_data)
		@data=a_data
	end
	@data
end