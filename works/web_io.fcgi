#!/usr/bin/ruby1.8

require '../works/fast_cgi_point'

$stdout = File.open('/dev/pts/6', 'w')

fcgi=FastCGIPoint.new

=begin
FCGI.each do |request|
	stuff=request.in.read
			out = request.out
# 			out.print "Content-Type: text/html\r\n\r\nHello, World!\n"
			out << "Content-Type: text/html\r\n\r\n"
			out << "---------------------------------\n"
			out << stuff
			request.finish
end
=end