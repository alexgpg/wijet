#!/usr/bin/ruby1.8

require 'test/unit'
require '../works/jabber_client'

class JabberClientTester < Test::Unit::TestCase


	def test_1
		jc=nil
		assert_nothing_raised do
			jc=JabberClient.new("test@jabber.port13.lan","123456","jabber.port13.lan",5222)
			jc.connect
			jc.setStatus(:online,"test_status",60)
			vcard=jc.getVCard('killer@jabber.port13.lan')
			#puts 'VCARD = '+vcard.inspect
			#puts 'Nickname = '+vcard['NICKNAME']
			assert_equal(vcard['NICKNAME'], 'killer')
		end
	end

	def test_2
		jc=nil
		assert_nothing_raised do
			jc=JabberClient.new("test@jabber.port13.lan","123456","jabber.port13.lan",5222)
			jc.connect
			jc.setStatus(:online,"test_status",60)
			vcard=jc.getVCard('test@jabber.port13.lan')
			#puts 'VCARD = '+vcard.inspect
			#puts 'Nickname = '+vcard['NICKNAME']
			assert_equal(vcard['NICKNAME'], 'qwerty_nick')
		end
	end

	def test_2
		jc=nil
		assert_nothing_raised do
			jc=JabberClient.new("test@jabber.port13.lan","123456","jabber.port13.lan",5222)
			jc.connect
			jc.setStatus(:online,"test_status",60)
			vcard=jc.getVCard('fhghdgash@jabber.port13.lan')
			assert_equal(vcard, nil)
		end
	end
end