
def requireWithGems(a_lib)
	begin
		require a_lib
	rescue LoadError
		require 'rubygems'
		require a_lib
	end
end