require '../works/requirer'
requireWithGems 'json'
require '../works/parsed_info'

class Parser
	def initialize
		p 'Parser.new'
	end
	def parseFromLogin(a_request)
		data=JSON.parse a_request
		res=ParsedInfo.new
		res.data=data
		return res
	end
	def parseFromIm(a_request)
		data=JSON.parse a_request
		res=ParsedInfo.new
		res.data=data
		return res
	end
	def toJsonForLogin(a_parsedInfo)
		return JSON.generate(a_parsedInfo.data)
	end
	def toJsonForIm(a_parsedInfo)
		return JSON.generate(a_parsedInfo.data)
	end
	
end
