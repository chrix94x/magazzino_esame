
require 'socket'
require 'rubygems'
require 'json'

require 'socket'



def processStr(readString)
puts "it is entered in processStr  function"
begin
	data = JSON.parse(readString)
	puts data
	
	 #ALL VARIABLES
 	command = data["command"]

	#changesssss

	puts "this is the command"
	puts command
	#	analyse(string,c,con,client)
	rescue JSON::ParserError => e
	client.puts "{\"error\":\"parsejson\"}"
	sendError(client,e)
end

end


port = 2000

server = TCPServer.new port
loop do
	Thread.start(server.accept) do |client|
		#client.puts "Hello !"
		my_thread_id = Thread.current.object_id

		sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr

		#puts "from  #{remote_ip} port: #{remote_port}"
		puts "Thread ID: #{my_thread_id} - Time is #{Time.now}\n"
    client.puts "message sent success!! -from Server- "
		#readString = client.read ## not ok, as it waits till the buffer is full.

    readString = client.read ## wait cr/lf

		#puts readString.length
		puts readString + "\n\n"
    processStr(readString)

		client.close
	end
end


