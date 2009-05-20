require 'fcgi'
require '../works/parser'
require '../works/executer_request'

class FastCGIPoint
	def initialize
		@parser=Parser.new
	
		FCGI.each do |request|
			stuff=request.in.read
			out = request.out

#  			parsed=@parser.parse(stuff)


# 			out.print "Content-Type: text/html\r\n\r\nHello, World!\n"
			out << "Content-Type: text/html\r\n\r\n"
#  			out << @parser.toJsonForLogin(res)
			out << stuff
			request.finish
		end
	end

	@parser
end

