#!/usr/bin/ruby1.8
require 'singleton'

##
# The Configuration handler.
# Using for get configuration informations.
#
# Example 1:
#	# Create config in programm
#	Config.instance.setConfig do
#		allow_domains	:all
#		deny_domains	:no
#		max_users 100
#	end
# Example 2:
#	# Read config from file
#	Config.instance.setConfigFromFile('test_wijet.conf')
#
# Example 3:
#	# using parametrs from config
#	Config.instance.setConfig do
#		allow_domains	:all
#		deny_domains	:no
#		max_users 100
#	end
# 	puts Config.instance.allow_domains
#	puts Config.instance.max_users
#
# Format config file:
#	field value
#	other_fileld val
#	...
class Config
	include Singleton

	def setConfig &a_block
		instance_eval &a_block
	end
	
	def setConfigFromFile(a_fileName)
		instance_eval( IO.read(a_fileName) )
	end
	
	# Method for get and set fileld.
	#
	# Config.instance.aaa 10500 - set value for fileld "aaa".
	#
	# Config.instance.aaa - get fileld with name "aaa", it must be already initialized, else raise exeception
	def method_missing a_name, *a_args, &a_block
		if a_args.size==0
			raise "Variable \"#{a_name}\" not exist"
		end
		instance_variable_set("@#{a_name}".to_sym, a_args[0])
		self.class.send(:define_method, a_name, proc {instance_variable_get("@#{a_name}")})
	end
end

