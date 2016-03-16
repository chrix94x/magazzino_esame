
require 'socket'
require 'rubygems'
require 'json'


#server = TCPServer.open('localhost',2000)                    # Socket to listen on port 2000

server = TCPServer.new 2000

loop {


# Servers run forever

  client = server.accept                                 #     Wait for a client to connect

  client.puts(Time.now.ctime+'rubyAllright')                                 # Send the time to the client

  # JSON.parse(string) Method


  readString= client.read

  puts readString


  client.puts("Closing the connection. Bye!")
  client.close

#  string=JSON.parse(readString)

#  puts string

 #puts the first, second and third piece of Json


 # puts string["op1"]

 # puts string["op2"]

#  puts string["op3"]


#we can also do this  string["op1"]+ string["op2"] and puts on screen


 # sum =string["op1"].to_i + string["op2"].to_i

 # puts "this is the sum:\n ",sum


                                         # Disconnect from the client

}


