
require '../works/requirer'

require '../works/vcard'

require '../works/debug'

requireWithGems 'xmpp4r/client'
requireWithGems 'xmpp4r/roster/helper/roster'
requireWithGems 'xmpp4r/vcard/helper/vcard'
requireWithGems 'xmpp4r/vcard/iq/vcard'


class JabberClient
public
	# ctor
	# 
	def initialize(a_jid, a_pass, a_server, a_port)
# 		p '!JabberClient.new'
 		@jid=Jabber::JID.new(a_jid)
		@jid.resource='Wijet'

		@client=Jabber::Client.new(@jid)
		@pass=a_pass
		@server=a_server
		@port=a_port
		@queueMessages=[]
		@queuePresences=[]

# 		@rosterSend=false

		@test_cout=0
		
	end
	#dev-status: in work, but works
	def fullInit
# 		p 'JabberClient.fullInit'
		setIncomingMessagesCallback
		setRoster
		setPresenceCallback
		setStatus(:xa,"test_status",60)	#!!!!!!!!!!!!!!!!!!!!!!!!!11
		#setUpdateCallback
	end
	
	##
	#Connect to server
	#Can throw exception
	def connect
		#no tested!!!
# 		p 'JabberClient.connect'
 		begin
# 			if @server==nil
				@client.connect
# 			else
# 				@client.connect(@server,@port)
# 			end
			@client.auth(@pass)
			
 		rescue Jabber::ClientAuthenticationFailure => e
 			raise "login_error"
# 			p 'JabberClient.faile'
 		end
	end
	
	##
	#End of session
	def closeConnection
# 		p 'JabberClient.closeConnection'
		@client.close
	end
	
	def setStatus(a_show=nil, a_status=nil, a_priority=nil)
# 		p 'JabberClient.setStatus'
		a_show=nil if a_show==:online
		presence=Jabber::Presence.new(a_show, a_status,a_priority)
		@client.send(presence)
	end
	
	def sendMessage(a_to,a_text,a_type,a_subject=nil)
# 		p 'JabberClient.sendMessage'
		msg=Jabber::Message.new(a_to,a_text).set_type(a_type).set_subject(a_subject)
		@client.send(msg)	
	end
	#Syntax sugar for sendMessage(to,text,:chat)
	def sendChatMessage(a_to, a_text)
# 		p 'JabberClient.sendChatMessage'
		sendMessage(a_to,a_text,:chat)
	end
	
	def addContact(a_jid, a_nick=nil, a_subscribe=false)
# 		p 'JabberClient.addContact'
		@roster.add(a_jid,a_nick,a_subscribe)
	end
	
	def delContact(a_jid)
		jid=Jabber::JID.new(a_jid)
		rosterItem=@roster.find(jid)
		rosterItem.remove
	end

	def eachIncomingMessages(&a_closure)
		@queueMessages.each{|msgAndTime|
			msg=msgAndTime[0]
			time=msgAndTime[1]
			
			a_closure.call(msg.from.strip.to_s,msg.type,msg.body,msg.subject,time)
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
	
	
	def eachPresences(&a_closure)
		@queuePresences.each{|presence|
			item=presence[0]
			new=presence[1]
			old=presence[2]
			
# 			dbgPrn 2, 'new = ' + new.inspect

			newShow=nil
			newStatus=nil
			oldShow=nil
			oldShow=nil

			if new==nil
				newShow=nil
				newStatus=nil
			else
# 				dbgPrn 2, 'newShow = ' + new.show.to_s
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

			newShow=:online if newShow.nil? && new.type!=:unavailable
			oldShow=:online if oldShow.nil? && new.type!=:unavailable
			
			newStatus='' if newStatus.nil?
			oldStatus='' if oldStatus.nil?

			a_closure.call(item.jid.strip.to_s,newShow,newStatus,oldShow,oldStatus)
		}
		@queuePresences.clear
	end
	
	# Get VCard for user.
	# a_jid:: [String]  - JID
	# return:: [VCard] - VCard for user a_jid
	def getVCard(a_jid)
		xmpp4rVCard=Jabber::Vcard::Helper.get(@client, Jabber::JID.new(a_jid))
		return nil if xmpp4rVCard.nil?
 		VCard.new(xmpp4rVCard)
	end

	# Get own nickname.
	# return:: [String] - own nickname or node if nickname is empty
	def ownNick
		ownVCard=getVCard(@jid.to_s)
		if ownVCard.nil? or ownVCard['NICKNAME'].nil?
 			return @jid.node
		else
			ownVCard['NICKNAME']
		end
	end
private
	#
	def setIncomingMessagesCallback
#  		p "JabberClient.setIncomingMessagesCallback---start"
		@client.add_message_callback{|msg|
			
#   			p "msg="+ msg.body+"\n"
			@queueMessages.push([msg,Time.now])
#  			p "after\n"
		}
#   		p "JabberClient.setIncomingMessagesCallback---end"
	end

	##
	#Loading roster from jabber-server and set him
 	def setRoster
 		@roster=Jabber::Roster::Helper.new(@client)
 		@roster.wait_for_roster
	end
	
	##
	#Add a callback for presence updates 
	#only know item in roster
	def setPresenceCallback
# 		p 'JabberClient.setPresenceCallback'
		@roster.add_presence_callback{|item,old,new|
			#p 'JabberClient.presence_callback'
			@queuePresences.push([item,new,old])
		}
	end

	#not realised!!!
	def setUpdateCallback
		@roster.add_update_callback{|old,new|
# 			p 'update callback'
# 			p 'old='+old.to_s
# 			p 'new'+new.to_s
		}
	end
	
	#not realised!!!
	def setRosterQueryCallback
		#empty
	end

	@jid
	@server
	@pass
	@port
	
	@test_cout	#variable for test

# 	@rosterSend

	@roster
	@client
	@queueMessages #format: [[msg,time],[msg2,time2],...]
	@queuePresences	#format: [[item,old,new] ,[item2,old2,new2],...]
end


