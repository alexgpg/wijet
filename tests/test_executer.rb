#!/usr/bin/ruby1.8
#!

require 'test/unit'
require '../works/parser'
require '../works/executer_request'

class TestExecuter < Test::Unit::TestCase
	def test_type_1
		parser=Parser.new
		str='[{"name":"jid","value":"alexgpg@ya.ru"},{"name":"pass"}]'
		parsed=parser.parse(str)
		puts parsed.inspect
# 		p parsed.inspect
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:login)
	end
	def test_type_2
		parser=Parser.new
		str='{"session_id":532613526,"xz":true}'
		parsed=parser.parse(str)
# 		p parsed.inspect
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:work)
	end
=begin
	def test_1
		p 'test1'
		parser=Parser.new
# 		str='[{"name":"jid","value":"test@jabber.port13.lan"},{"name":"pass","value":"123456"}]'
		str='[{"name":"jid","value":"wijet@jabber.ru"},{"name":"pass","value":"pivopivo"}]'
		parsed=parser.parse(str)
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:login)
		answer=ExecuterRequest.instance.execute(parsed)
		p 'answer='+answer.inspect + '\n'
	end
=end
=begin
	def test_2
		p 'test1'
		parser=Parser.new
# 		str='[{"name":"jid","value":"test@jabber.port13.lan"},{"name":"pass","value":"123456"}]'
		str='[{"name":"jid","value":"wijet@jabber.ru"},{"name":"pass","value":"huinya"}]'
		parsed=parser.parse(str)
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:login)
		begin
			answer=ExecuterRequest.instance.execute(parsed)
			p 'answer='+answer.inspect + '\n'
		rescue
			p 'aaaaaaaaaaaaa'
		end
	end
=end
=begin
	def test_2
		p 'test2'
		parser=Parser.new
		loginStr='[{"name":"jid","value":"test@jabber.port13.lan"},{"name":"pass","value":"123456"}]'
		parsedReq=parser.parse(loginStr)
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:login)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
		sid=answer.sessionId
		workStr='{ "session_id":"'+ sid + '","additional_query": { "send_message": [ { "to": "killer@jabber.port13.lan", "type": "chat", "text": "test"} ],"new_contact": "", "delete_contact": "","change_status": { "show": "", "status": ""},"get_avatars": true} }'
		parsedReq=parser.parse(workStr)
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:work)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
# 		Thread.stop
	end
=end
=begin
	def test_2
		p 'test2'
		parser=Parser.new
		loginStr='[{"name":"jid","value":"wijet@jabber.ru"},{"name":"pass","value":"pivopivo"}]'
		parsedReq=parser.parse(loginStr)
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:login)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
		sid=answer.sessionId
		workStr='{ "session_id":"'+ sid + '","additional_query": {} }'
		parsedReq=parser.parse(workStr)
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:work)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
 		Thread.stop
	end
=end
	def test_3
		parser=Parser.new
		loginStr='[{"name":"jid","value":"wijet@jabber.ru"},{"name":"pass","value":"pivopivo"}]'
		parsedReq=parser.parse(loginStr)
		p 'parsedReq = ' + parsedReq.inspect
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:login)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
		sid=answer.sessionId
		workStr='{ "session_id":"'+ sid + '","additional_query": {"get_roster": "true", "send_message": [ { "to": "alexgpg@ya.ru", "type": "chat", "text": "test" }]}}'
		parsedReq=parser.parse(workStr)
		assert_equal(ExecuterRequest.instance.typeRequest(parsedReq),:work)
		answer=ExecuterRequest.instance.execute(parsedReq)
		p 'answer='+answer.inspect + '\n'
 		Thread.stop
	end
end