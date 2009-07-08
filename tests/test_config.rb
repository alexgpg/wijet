#!/usr/bin/ruby1.8

require 'test/unit'
require '../works/config'

class TestConfig < Test::Unit::TestCase
	def test_1
		Config.instance.setConfig do
			allow_domains	:all
			deny_domains	:no
			max_users 100
		end
		assert_equal(Config.instance.allow_domains, :all)
		assert_equal(Config.instance.deny_domains, :no)
		assert_equal(Config.instance.max_users, 100)

		assert_raise RuntimeError do
			a=Config.instance.notexistvar
		end

	end

	def test_config_from_file
		Config.instance.setConfigFromFile('test_wijet.conf')
		assert_equal(Config.instance.variable_1, 10)
		assert_equal(Config.instance.variable_2, 20)
		assert_equal(Config.instance.variable_3, [1,2,3,4,"5"])
		
		assert_raise RuntimeError do
			a=Config.instance.notexistvar
		end
	end
end