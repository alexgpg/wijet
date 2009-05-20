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

	def test_1
		parser=Parser.new
		str='[{"name":"jid","value":"test@jabber.port13.lan"},{"name":"pass","value":"123456"}]'
		parsed=parser.parse(str)
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:login)
		ExecuterRequest.instance.execute(parsed)
	end
end