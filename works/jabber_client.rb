require 'xmpp4r/client'
require 'xmpp4r/roster/helper/roster'

=begin
todo:
do presence callback
and each fuction for precence


=end

class JabberClient
public
	#ctor
	def initialize(a_jid, a_pass, a_server, a_port)
		p 'JabberClient.new'
		@client=Jabber::Client.new(a_jid)
		@pass=a_pass
		@server=a_server
		@port=a_port
		@queueMessages=[]
		@queuePresences=[]

		@test_cout=0
		
	end
	def fullInit
		#not realised!!!!!
		p 'JabberClient.fullInit'
		setIncomingMessagesCallback
		setRoster
		setPresenceCallback
		#setUpdateCallback
	end
	#return true/false, and string error
	def connect
		#no tested!!!
		p 'JabberClient.connect'
		begin
		@client.connect(@server,@port)
		@client.auth(@pass)
		return true,""
		rescue Jabber::ClientAuthenticationFailure
			return false, "not true password"
		end
	end
	
	#End of session
	def closeConnection
		p 'JabberClient.closeConnection'
		@client.close
	end
	
	def setStatus(a_show=nil, a_status=nil, a_priority=nil)
		p 'JabberClient.setStatus'
		a_show=nil if a_show=:online
		presence=Jabber::Presence.new(a_show, a_status,a_priority)
		@client.send(presence)
	end
	
	def sendMessage(a_to,a_text,a_type,a_subject=nil)
		p 'JabberClient.sendMessage'
		msg=Jabber::Message.new(a_to,a_text).set_type(a_type).set_subject(a_subject)
		@client.send(msg)	
	end
	#Syntax sugar for sendMessage(to,text,:chat)
	def sendChatMessage(a_to, a_text)
		p 'JabberClient.sendChatMessage'
		sendMessage(a_to,a_text,:chat)
	end
	
	def addContact(a_jid, a_nick=nil, a_subscribe=false)
		p 'JabberClient.addContact'
		@roster.add(a_jid,a_nick,a_subscribe)
	end
	
	def delContact(a_jid)
		jid=Jabber::JID(a_jid)
		rosterItem=@roster.find(jid)
		rosterItem.remove
	end

	def eachIncomingMessages(&a_closure)
		@queueMessages.each{|msg|
			a_closure.call(msg.from.to_s,msg.type,msg.body)
		}
		@queueMessages.clear
	end
	
	def eachJIDinRoster(&a_closure)
		@roster.groups.each{|group|
			@roster.find_by_group(group).each { |item|
				a_closure.call(group,item.jid.to_s,item.iname)
  			}
		}
	end
	
	#fail
	def eachPresences(&a_closure)
		@queuePresences.each{|presence|
			item=presence[0]
			new=presence[1]
			old=presence[2]
			if new==nil
				newShow=nil
				newStatus=nil
			else
				newShow=new.show
				newStatus=new.status
			end
			
			if old==nil
				oldShow=nil
				oldStatus=nil
			else
				oldShow=old.show
				oldStatus=old.status
			end

			newShow=:online if newShow.nil?
			oldShow=:online if oldShow.nil?
			
			newStatus='' if newStatus.nil?
			oldStatus='' if oldStatus.nil?

			a_closure.call(item.jid.to_s,newShow,newStatus,oldShow,oldStatus)
		}
		@queuePresences.clear
	end
	
private
	#dev-status:in_work
	def setIncomingMessagesCallback
		p "JabberClient.setIncomingMessagesCallback---start"
		@client.add_message_callback{|msg|
			p "msg="+ msg.body+"\n"
			@queueMessages.push(msg)
			p "after\n"
		}
		p "JabberClient.setIncomingMessagesCallback---end"
	end

	#
	def setRoster
		@roster=Jabber::Roster::Helper.new(@client)
		@roster.wait_for_roster
	end
	
	#fail
	#only known RosterItem
	def setPresenceCallback
		p 'JabberClient.setPresenceCallback'
		@roster.add_presence_callback{|item,old,new|
			#p 'JabberClient.presence_callback'
			@queuePresences.push([item,new,old])
		}
	end

	def setUpdateCallback
		@roster.add_update_callback{|old,new|
			p 'update callback'
			p 'old='+old.to_s
			p 'new'+new.to_s
		}
	end

	def setRosterQueryCallback
		#@client.
	end

	@server
	@pass
	@port
	
	@test_cout

	@roster
	@client
	@queueMessages
	@queuePresences	#format: [[item,old,new] ,[item2,old2,new2],...]
end
