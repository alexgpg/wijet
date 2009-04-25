require 'webrick'

require '../moc_classes/moc_parser'
require '../moc_classes/moc_parsed_info'
require '../moc_classes/moc_client'
require '../works/client_manager'

##
#Allow acces from web
class WebServer
	#ctor
	def initialize
		p "WebServer.new"
		@server=WEBrick::HTTPServer.new(:DocumentRoot=>'../moc_web',:Port=>3000)	#moc_root!!!!
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

	def mountLoginCgi
		p "WebServer.mountLoginCgi"
		#no_work!!!!no tested!!!!
		@server.mount_proc("/login.cgi"){|request,response|
			
			response['Content-Type'] = 'text/html'
			parsed=@parser.parseFromLogin(request.body["keywords"])
			jid=parsed.jid
			pass=parsed.pass
			server=parsed.server
			
			maybeNewClient=Client.new(jid, pass, server, 5222)
			#no work with new specks!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			#no tested!!!!!!!!!!!!!!!!!
			begin
				maybeNewCLient.connect
				#login successfully
				sid=ClientManager.instance.addClient(maybeNewClient)
				response.boby=Parser.toJsonForLogin(ParsedInfo.loginSuccessfully(sid))
			rescue	#todo
				#connect failed
				response.boby=Parser.toJsonForLogin(ParsedInfo.loginFailed("error_text"))
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
