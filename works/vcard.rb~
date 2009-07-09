##
# Wrapper for xmpp4r class IqVcard.
# Using for hiding using concrete library.
# Now using only for read!
class VCard

	# ctor
	#  a_xmpp4rVCard: [Jabber::Vcard::IqVcard]
	def initialize(a_xmpp4rVCard)
		@xmpp4rVCard=a_xmpp4rVCard
	end

	# Get an elements/fields text
	#  return: [String] XPath
	def fields
		@xmpp4rVCard.fields
	end	

	# Get vCard field names
	#  Example:
	#  ["NICKNAME", "BDAY", "ORG/ORGUNIT", "PHOTO/TYPE", "PHOTO/BINVAL"]
	#  return: [Array] of [String] 
	def [](a_param)
		@xmpp4rVCard[a_param]
	end

	# Get user avatar in Base64 code
	#  return: [String or nil] - avatar in Base64 code or nil if not avatar
	def avatarBase64
		@xmpp4rVCard['PHOTO/BINVAL']
	end

	@xmpp4rVCard
end