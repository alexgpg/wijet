# Debug level. 0 - no debug. The more, the more messages will be printed.
$debug_level=0

# File for debug print
$out_terminal = File.open('/dev/pts/5', 'w')


# Function for debug print, a_level - more importantly, the lower value.
def dbgPrn(a_level, a_txt)
	if $debug_level >= a_level && $debug_level > 0
		$out_terminal.puts "dbg: " + a_txt.to_s
	end
end