require '../works/jabber_client'
require '../works/json_object'
require '../works/client'
require '../works/client_manager'
require 'singleton'


class ExecuterRequest
	include Singleton
	def initialize
# 		p "ExecuterRequest.new"
		@strShowToString={	"chat" =>	:chat,
					"online" =>	:online,
					"dnd" =>	:dnd ,
					"away" => 	:away,
					"xa" => 	:xa,
# 					"unavailable"=>	:unavailable,
					"error" =>	:error}
	end

	def execute(a_request)
#  		p 'ExecuterRequest.execute'
		if typeRequest(a_request)==:login
			return loginExec(a_request)
		else
			return workExec(a_request)
		end
	end

	def sendFullRoster(a_jabberClient)
		res=[]
		a_jabberClient.eachJIDinRoster{|group,jid,nick|
			nick=jid if nick==nil
			res.push({'jid' => jid, 'nick' => nick })
		}
		return res
	end

	def getRoster(a_additionalQuery,a_jabberClient)
		if a_additionalQuery['get_roster']
			return sendFullRoster(a_jabberClient)
		end
	end

	def getAvatars(a_jabberClient)
	end

	def getIncomingMessages(a_jabberClient)
		res=[]
		a_jabberClient.eachIncomingMessages{ |from,type,msg,subj,time|
# 			p 'msg'
			res.push({'from'=>from,'type'=>type,'text'=>msg,'time'=> time.strftime('%H:%M:%S') })
#  			res.push({'from'=>from,'type'=>type,'text'=>msg,'time'=> "atatat" })
 		}
# 		p 'getIncomingMessages:' + res.inspect
		return res
	end

	def getStatuses(a_jabberClient)
		res=[]
		a_jabberClient.eachPresences do |jid,newShow,newStatus,oldShow,oldStatus|
			res.push({'jid'=> jid, 'show'=> newShow.to_s, 'status'=> newStatus })
		end
		return res
	end

	def setStatus(a_request,a_jabberClient)
		if a_request['change_status']==nil
			return
		end
		statusRequest=a_request['change_status']
		show=:online
		status=''
		unless statusRequest['show'].nil?
			unless @strShowToString[statusRequest['show']].nil?
				show=@strShowToString[statusRequest['show']]
			end
		end
		unless statusRequest['status'].nil?
			unless statusRequest['status'].nil?
				status=statusRequest['status']
			end
		end
 		a_jabberClient.setStatus(show,status)
#		a_jabberClient.setStatus(show,'atatat pish')
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


	def sendMessages(a_additionalQuery,a_jabberClient)
		
		unless a_additionalQuery['send_message']
# 			p 'tras1='+a_additionalQuery.inspect
			return
		end
#  		p 'sendMessages'
		msgArray=a_additionalQuery['send_message']
		
		msgArray.each{|msg|
# 			p 'msg='+msg.inspect
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
			res.data={"Error"=>"not authorization"}
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

			if getRoster(additional_query,jabberClient)
				res.data['new_contacts']=getRoster(additional_query,jabberClient)
# 				res.data['avatars']=getAvatars(jabberClient)
			end

			sendMessages(additional_query,jabberClient)
			setStatus(additional_query,jabberClient)

		end
 		res.data['messages']=getIncomingMessages(jabberClient)
		res.data['change_status']=getStatuses(jabberClient)

		return res



# 		rescue
#  			res.data={"ERROR:"=>'xz'}
#  			return res
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
			return :error
		end
	end

	@strShowToString
	
end

end