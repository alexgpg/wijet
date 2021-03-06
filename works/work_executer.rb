require 'singleton'

require '../works/jabber_client'
require '../works/json_object'
require '../works/client'
require '../works/client_manager'

# require '../works/debug'

class WorkExecuter
	include Singleton

	def initialize
		@strShowToString={	"chat" =>	:chat,
					"online" =>	:online,
					"dnd" =>	:dnd ,
					"away" => 	:away,
					"xa" => 	:xa}
	end

	def execute(a_request)
		begin
# 			dbgPrn 2, 'WorkExecuter.execute'
			response=JsonObject.new
			response.data={}
			unless ClientManager.instance[a_request.sessionId]
				# todo: raise 'not authorization'
				response.data={'Error'=>'not authorization'}
				return response
			end

			@jabberClient=ClientManager.instance[a_request.sessionId].jabberClient
		
			@additionalQuery=a_request.data['additional_query']
		
			unless @additionalQuery.empty?
				#close query
				if @additionalQuery['session_close']
					closeQuery(a_request.sessionId)
					response.data={'session_close'=>'ok'}	#! ondocumented
					return response
				end
				#roster query
				if @additionalQuery['get_roster']
					dbgPrn 2, 'WorkExecuter.get_roster'
					response.data['new_contacts']=rosterQuery
				end
				sendMessagesQuery
				setStatusQuery
			end

			response.data['messages']=getIncomingMessages
			response.data['change_status']=getStatuses

			return response

		rescue Exception => e	# todo: normal error handler
			dbgPrn 2, e.to_s
		end
	end
	
	def closeQuery(a_sessionId)
		@jabberClient.closeConnection
		ClientManager.instance.delClient(a_sessionId)
	end

	def rosterQuery
		roster=[]
		@jabberClient.eachJIDinRoster{|group,jid,nick|
			nick=jid if nick.nil?
			roster.push({'jid' => jid, 'nick' => nick })
		}
		return roster
	end

	def sendMessagesQuery
		unless @additionalQuery['send_message'] && @additionalQuery['send_message'].class==Array
			return
		end
		
		messages=@additionalQuery['send_message']
		messages.each do|msg|
			@jabberClient.sendChatMessage(msg['to'],msg['text'])
		end
	end

	def setStatusQuery
		unless @additionalQuery['change_status']
			return
		end
		statusRequest=@additionalQuery['change_status']
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
 		@jabberClient.setStatus(show,status)
	end

	def getIncomingMessages
		messages=[]
		@jabberClient.eachIncomingMessages do |from,type,msg,subj,time|
			messages.push({'from'=>from,'type'=>type,'text'=>msg,'time'=> time.strftime('%H:%M:%S') })
 		end
		return messages
	end

	def getStatuses
		statuses=[]
		@jabberClient.eachPresences do |jid,newShow,newStatus,oldShow,oldStatus|
			statuses.push({'jid'=> jid, 'show'=> newShow.to_s, 'status'=> newStatus })
		end
		return statuses
	end

	@jabberClient
	@additionalQuery
	@strShowToString
end