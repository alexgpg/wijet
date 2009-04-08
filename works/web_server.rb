require 'webrick'

require '../moc_classes/moc_parser'
require '../moc_classes/moc_parsed_info'
require '../moc_classes/moc_client'
require '../works/client_manager'

#Allow acces from web
class WebServer
	#ctor
	def initialize
		p "WebServer.new"
		@server=WEBrick::HTTPServer.new(:Port=>3000)
		mountHtmlPages
		mountLoginCgi
		mountImCgi
		@parser=Parser.new
	end
	
	#Start the server
	def start
		p "WebServer.start"
		@server.start
	end

	#Stop the server. Alias for shutdown
	def stop
		shutdown
	end
	
	#Stop the server.
	def shutdown
		p "WebServer.shutdown"
		@server.shutdown
	end
	
private
	def mountHtmlPages
		p "WebServer.mountHtmlPages"
		#mount login.html
		#return(in Web) web page login.html
		@server.mount_proc("/login.html"){|request,response|
			response['Content-Type'] = 'text/html'
			response.body=ERB.new(IO.read("login.html")).result
		}
		
		#mount im.html
		#return(in Web) web page im.html
		@server.mount_proc("/im.html"){|request,response|
				response['Content-Type'] = 'text/html'
				response.body=ERB.new(IO.read("im.html")).result

		}
	end
	
	def mountLoginCgi
		p "WebServer.mountLoginCgi"
		#no tested!!!!
		@server.mount_proc("/login.cgi"){|request,response|
			response['Content-Type'] = 'text/html'
			parsed=@parser.parseFromLogin(request.body["keywords"])
			jid=parsed.data["jid"]
			pass=parsed.data["pass"]
			server=parsed.data["server"]
			
			maybeNewClient=Client.new(jid, pass, server, 5222)
			if maybeNewCLient.tryConnect
				#login successfully
				sid=ClientManager.instance.addClient(maybeNewClient)
				response.boby="{succes:true, sid:\"#{sid}\"}"
			else
				#login failed
				response.body="{succes:true, sid:\"error!!!\"}"
			end
		}
	end
	def mountImCgi
		#It is not realised!!!
		p "WebServer.mountImCgi"
		@server.mount_proc("/im.cgi"){|request,response|
			response['Content-Type'] = 'text/html'
			response.body='empty'
		}
	end
	@server
	@parser
end
