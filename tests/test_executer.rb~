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
		p parsed.inspect
		assert_equal(ExecuterRequest.instance.typeRequest(parsed),:login)
	end
end