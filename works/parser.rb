require '../works/requirer'
requireWithGems 'json'
require '../works/json_object'

class Parser
	def initialize
# 		p 'Parser.new'
	end

	def parse(a_request)
		data=JSON.parse a_request
		res=JsonObject.new
		res.data=data
		return res
	end

	def toJson(a_jsonObject)
		return JSON.generate(a_jsonObject.data)
	end
end
