#!/usr/bin/ruby1.8
#!

require 'test/unit'
require '../works/executer'
require 'rubygems'
require 'mocha'

class TestExecuterRequest < Test::Unit::TestCase
	def test_singleton
		exmpl=ExecuterRequest.instance
		assert_equal(exmpl, ExecuterRequest.instance)
	end


	def test_with_bad_request
		req=mock()
		req.stubs(:data).returns({'session_i3rrr'=>'1231232', 'additional_query'=>{}})
		assert_raise RuntimeError do
			ExecuterRequest.instance.execute(req)
		end
	end

	# test work executer  case _with_ additional query
	def test_work_executer_1
		WorkExecuter.any_instance.stubs(:execute).with(any_parameters).returns('answer123')
		req=mock()
		req.stubs(:data).returns({'session_id'=>'1231232', 'additional_query'=>{'some'=>'some'}})
		assert_equal('answer123', ExecuterRequest.instance.execute(req))
	end

	# test work executer  case _without_ additional query
	def test_work_executer_2
		WorkExecuter.any_instance.stubs(:execute).with(any_parameters).returns('answer123')
		req=mock()
		req.stubs(:data).returns({'session_id'=>'1231232', 'additional_query'=>{}})
		assert_equal('answer123', ExecuterRequest.instance.execute(req))
	end

	# test login executer  case
	def test_login_executer
		LoginExecuter.any_instance.stubs(:execute).with(any_parameters).returns('answer559')
		req=mock()
		req.stubs(:data).returns([{'name'=>'jid','value'=>'test@jabber.port13.lan'},{'name'=>'pass', 'value'=>'somepass'}])
		assert_equal('answer559', ExecuterRequest.instance.execute(req))
	end
end