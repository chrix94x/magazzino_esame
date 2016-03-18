
require "socket"

port = 2000
server = "77.93.255.134"
#server = "localhost"

s = TCPSocket.open(server, port)
while line = s.gets
	puts "received : #{line.chop}"
end
s.close