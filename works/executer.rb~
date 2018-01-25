require 'singleton'

require '../works/login_executer'
require '../works/work_executer'

require '../works/debug'

class ExecuterRequest
	include Singleton

	def execute(a_request)
		dbgPrn 2, 'ExecuterRequest.execute'
		getConcreteExec(a_request).execute(a_request)
	end
private
	def getConcreteExec(a_request)
		return LoginExecuter.instance if loginReqType?(a_request)
		return WorkExecuter.instance if workReqType?(a_request)
		dbgPrn 2, 'epic fail'
		raise 'Unknown type request'
	end

	def loginReqType?(a_request)
# 		dbgPrn 2, 'a_request = '+ a_request.inspect
		unless a_request.data.class==Array
			return false
		end
	
		jidIncludeFlag=false
		passIncludeFlag=false	
		
		#todo: flags for host and port and his handlers
		
		a_request.data.each do |item|
			if item['name']=='jid' && jid?(item['value']) && jidIncludeFlag==false
				jidIncludeFlag=true
			end
			
			if item['name']=='pass' && item['value']!='' && passIncludeFlag==false
				passIncludeFlag=true
			end
		end

		unless jidIncludeFlag && passIncludeFlag	# jid or password is undefined
			return false
		end

		unless a_request.data.size<=4
			return false
		end

		return true
	end

	#stub
	def netAdress?(a_str)
		return true if a_str.class==String && a_str!=''
	end

	#stub
	def jid?(a_str)
		return true if a_str.class==String && a_str!=''
	end

	
	def workReqType?(a_request)
		unless a_request.data.class==Hash && a_request.data.size==2
			return false
		end
		
		unless a_request.data['session_id'].class==String && a_request.data['session_id']!=''
			return false
		end
		
		unless a_request.data['additional_query'].class==Hash
			return false
		end

		return true
	end
	
end













