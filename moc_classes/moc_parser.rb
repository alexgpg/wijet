#Moc parser

require '../moc_classes/moc_parsed_info'
class Parser
	def initialize
		p 'Parser.new'
	end
	def parseFromLogin(a_request)
		return ParsedInfo.new 
	end
	def parseFromIm(a_request)
		nil
	end
	def toJsonForLogin(a_parsedInfo)
		"moc"
	end
	def toJsonForIm(a_parsedInfo)
		"moc"
	end
	
end
