require '../works/jabber_client'
require '../works/parsed_info'
require 'singleton'


class ExecuterRequest
	include Singleton
	def initialize
		p "ExecuterRequest.new"
	end
	#Выполнение запроса
	#a_request объект типа ParsedInfo, содержащий запрос
	#a_jabberClient объект над которым будут выполнятся действия.
	def run(a_request,a_jabberClient)
		p "ExecuterRequest.run"
		res=ParsedInfo.new
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
	
	def send_messages(a_msgArray,a_jabberClient)
		a_msgArray.each{|msg|
			a_jabberClient.sendChatMessage(msg['to'],msg['text'])
		}
	end
end