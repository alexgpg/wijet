
$debug_level=0

$out_terminal = File.open('/dev/pts/5', 'w')

def dbgPrn(a_level, a_txt)
	if $debug_level >= a_level && $debug_level > 0
		$out_terminal.puts "dbg: " + a_txt.to_s
	end
end