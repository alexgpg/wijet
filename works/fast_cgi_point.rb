require 'fcgi'
require '../works/parser'
# require '../works/executer_request'

require '../works/executer'

class FastCGIPoint
	def initialize
		@parser=Parser.new
	
		FCGI.each do |request|
			begin
				stuff=request.in.read
				out = request.out

				
   				parsed=@parser.parse(stuff)

				@answer=ExecuterRequest.instance.execute(parsed)

				out << "Content-Type: text/html\n\n"
				out << @parser.toJson(@answer)

				request.finish
			rescue Exception => e
				dbgPrn 2, 'Exception in FastCGIPoint each, ' + e.to_s
				out << "Content-Type: text/html\n\n"
				out << '{"Error":"bad request"}'
				request.finish
			end

		end
	end

	@parser
	@answer
end

