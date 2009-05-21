require '../works/jabber_client'
require '../works/json_object'
require '../works/client'
require '../works/client_manager'
require 'singleton'


class ExecuterRequest
	include Singleton
#	def initialize
# 		p "ExecuterRequest.new"
#	end
	#!!!скорее  всего устаревший
	#Выполнение запроса
	#a_request объект типа ParsedInfo, содержащий запрос
	#a_jabberClient объект над которым будут выполнятся действия.
=begin
	def run(a_request,a_jabberClient)
		p "ExecuterRequest.run"
		res=JsonObject.new
		res.data={"processing query"=>""}
		p "req=="+a_request.inspect
		additional_query=a_request.data['additional_query']
		unless additional_query=={}
			unless additional_query['session_close']==nil
				a_jabberClient.closeConnection
				return res
			end
			puts 'additional_query==='+additional_query.inspect
			messages=additional_query['send_message']
			puts 'messages==='+messages.inspect
			send_messages(messages,a_jabberClient)
		else
			res.data={"processing incoming msgs, etc.."=>""}
			
		end
		parsedResp=ParsedInfo.new
		parsedResp.data={'messages'=>[]}
		a_jabberClient.eachIncomingMessages{|from,type,msg,subj,time|
			parsedResp.data['messages'].push({'from'=>from,'type'=>type,'text'=>msg})
		}
		return parsedResp
	end
=end
	def execute(a_request)
#  		p 'ExecuterRequest.execute'
		if typeRequest(a_request)==:login
			return loginExec(a_request)
		else
			return workExec(a_request)
		end
	end

	

	def loginExec(a_request)
#  		p 'ExecuterRequest.loginExec'
		begin
			jid=a_request.jid
			pass=a_request.pass
			server=a_request.server
			maybeNewClient=Client.new(
				:jid	  => jid,
				:password =>  pass,
				:server   =>  server,
				:port     =>  5222)
			maybeNewClient.connect
# 			p 'ExecuterRequest connected'
			sid=ClientManager.instance.addClient(maybeNewClient)
# 			p 'ExecuterRequest sid'
			return JsonObject.loginSuccessfully(sid.to_s)
 		rescue
 			return JsonObject.loginFailed("login_error")
		end
	end


	def sendMessages(a_msgArray,a_jabberClient)
		a_msgArray.each{|msg|
			p 'msg='+msg.inspect
			a_jabberClient.sendChatMessage(msg['to'],msg['text'])
# 			a_jabberClient.sendChatMessage('alexgpg@ya.ru','test')
		}
	end


	
	def workExec(a_request)
		begin
		res=JsonObject.new
		res.data={}
		sid=a_request.sessionId
		if ClientManager.instance[sid]==nil
			#todo::
			res.data={"hui"=>"hui"}
			return res
		end
		
		jabberClient=ClientManager.instance[sid].jabberClient
		
		additional_query=a_request.data['additional_query']
		unless additional_query=={}
			unless additional_query['session_close']==nil
				jabberClient.closeConnection
				ClientManager.instance.delClient(sid)
				return res
			end
			messages=additional_query['send_message']
			sendMessages(messages,jabberClient)
			res.data={"messages" => [],"status_change" => []}
		end
 		res.data={"messages" => [],"status_change" => []}
 		jabberClient.eachIncomingMessages{ |from,type,msg,subj,time|
 			res.data['messages'].push({'from'=>from,'type'=>type,'text'=>msg})
 		}
		return res
		rescue
			res.data={"ERROR:"=>"xz"}
			return res
		end
		
	end

	#return type of request :login or :work
	#a_req:: [JsonObject]
	#return:: [Symbol]
	def typeRequest(a_req)
# 		p 'ExecuterRequest.typeRequest'
		if (a_req.data.class==Array && a_req.data.size==2)
			return :login
		else if (a_req.data.class==Hash && a_req.data['session_id']!=nil)
			return :work
		else
			#todo!!!!!!!!
			return :xz
		end
	end


	
end

end