require 'fcgi'
require '../works/parser'
require '../works/executer_request'

class FastCGIPoint
	def initialize
		@parser=Parser.new
	
		FCGI.each do |request|
# 			begin
				stuff=request.in.read
				out = request.out

# 				p 'aaaaaaaaaaaa'
				
   				parsed=@parser.parse(stuff)

# 				begin
					@answer=ExecuterRequest.instance.execute(parsed)
# 				rescue
# 					@answer=JsonObject.loginFailed("111");
					out << "Content-Type: text/html\n\n"
# 					out << @parser.toJsonForLogin(@answer)
# 					request.finish
# 					return
# 					
# 				end

# 				out.print "Content-Type: text/html\r\n\r\nHello, World!\n"
#  				out << "Content-Type: text/html\r\n\r\n"
#  				out << @parser.toJsonForLogin(res)
# 				out << stuff

#  				out << "Content-Type: text/html\n\n"

				out << @parser.toJsonForLogin(@answer)

# 				out << "parsed: '" + parsed.data.inspect + "'\n"
# 				
# 				out << "\n\n\n"
# 				out << @answer.inspect
#  				out << "\n\n\n"
# 				out << @parser.toJsonForLogin(answer)
				
				request.finish
# 			rescue
# 				out << "Content-Type: text/html\r\n\r\n"
# 				out << "atatat"
# 				request.finish
# 			end
		end
	end

	@parser
	@answer
end

