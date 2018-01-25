require 'singleton'

require '../works/jabber_client'
require '../works/json_object'
require '../works/client'
require '../works/client_manager'

require '../works/debug'

# require 'json_object'
# require 'client_manager'

# not tested, but code from worked code!

class LoginExecuter
	include Singleton
	
	def execute(a_request)
		begin
# 			dbgPrn 2, 'LoginExecuter.execute'
			jid=a_request.jid
			pass=a_request.pass
			server=a_request.server
			maybeNewClient=Client.new(
				:jid	  => jid,
				:password =>  pass,
				:server   =>  server,
				:port     =>  5222)
			maybeNewClient.connect
			sid=ClientManager.instance.addClient(maybeNewClient)
			return JsonObject.loginSuccessfully(sid.to_s)
 		rescue
 			return JsonObject.loginFailed("login_error")
		end
	end
end