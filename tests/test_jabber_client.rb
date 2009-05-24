#!/usr/bin/ruby1.8
!#

require '../works/jabber_client'

def printMessages
	p 'printMessages'
	$jc.eachIncomingMessages{|from,type,text,subject,time|
		subject='' if subject.nil?
		puts "["+time.to_s+":"+from+"]"+text+"[type:"+type.to_s+",sub="+subject+"]"
	}
end

def printRoster
	p "ROSTER"
	$jc.eachJIDinRoster{|group, jid,name|
		if group.nil?; group='';end
		if name.nil?; name=jid;end
		puts "gr="+group+","+jid+","+name
	}

end

def printPresences
	p 'printPresences'
	$jc.eachPresences{|jid,newShow,newStatus,oldShow,oldStatus|
		puts "pres.new.jid="+jid+",type="+newShow.to_s+",status="+newStatus
		puts "pres.old.jid="+jid+",type="+oldShow.to_s+",status"+oldStatus
	}
end

	$jc=JabberClient.new("test@jabber.port13.lan","123456","jabber.port13.lan",5222)
	$jc.connect
	$jc.fullInit
# 	$jc.sendChatMessage("test@jabber.port13.lan","1111111")
	#$jc.sendMessage("test@jabber.port13.lan","месага",:normal, "тема")
	$jc.setStatus(:online,"test_status",60)

	

	#$jc.addContact("test@jabber.port13.lan")
	#$jc.delContact("test@jabber.port13.lan")
	
	trap("INT"){
		printMessages
		#printRoster
		#printPresences
		exit
	}

 	Thread.stop

