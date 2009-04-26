require 'webrick'

require '../works/parser'
require '../works/client'
require '../works/client_manager'

##
#Allow acces from web
class WebServer
	#ctor
	def initialize
		p "WebServer.new"
		@server=WEBrick::HTTPServer.new(:DocumentRoot=>'../works_web',:Port=>3000)	#moc_root!!!!
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
			begin
			parsed=@parser.parseFromLogin(request.body)
			jid=parsed.jid
			pass=parsed.pass
			server=parsed.server
					

			maybeNewClient=Client.new(
				:jid	  => jid,
				:password =>  pass,
				:server   =>  "213.180.203.19",
				:port     =>  5222)
			#no work with new specks!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			#no tested!!!!!!!!!!!!!!!!!
			response['Content-Type']='text/html'
				maybeNewClient.connect
				#login successfully
				sid=ClientManager.instance.addClient(maybeNewClient)
				puts "SIDDDDDDDDDDDDDD="+sid.to_s
				puts "OBJECT===="+ParsedInfo.loginSuccessfully(sid.to_s).inspect
				answer=response.body=@parser.toJsonForLogin(ParsedInfo.loginSuccessfully(sid))
				puts "ANSWER===="+answer
			rescue	#todo
				#connect failed
				response.body=@parser.toJsonForLogin(ParsedInfo.loginFailed("error_text"))
			end			
			}
	end
	def mountImCgi
		#It is not realised!!!
		p "WebServer.mountImCgi"
		@server.mount_proc("/im.cgi"){|request,response|
 			response['Content-Type'] = 'text/html'
			parsedReq=@parser.parseFromIm(request.body)
			sid=parsedReq.sessionId
			curClient=ClientManager.instance[sid]
			if curClient.nil?
				response.body="error: wrong session id"
			else
				parsedResp=curClient.runRequest(parsedReq)
				response.body=@parser.toJsonForIm(parsedResp)
			end
# 				{"session_id":"test_sid_-967240980","additional_query":{"send_message":[{"to":"killer@jabber.port13.lan","type":"chat","text":""}]}}
			

		}
	end
	@server
	@parser
end
