#LIBRARY
require 'socket'
require 'rubygems'
require 'json'
require 'mysql2'

#myFiles
load 'Classes.rb'




#CONNECTION WITH MYSQL AND CLIENT
con = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "yesyesyes")


#variables for connection

#localDbServer= 'localhost'
#localport=2000

#server = TCPServer.open(localDbServer,localport)

server = TCPServer.new 2000
# JSON.parse(string) Method
#INSTANCE CLASS
c= Shop .new

loop {

  #CONNECT TO THE CLIENT

  client = server.accept

#client.puts(Time.now.ctime)
# client.puts(Time.now.ctime+'rubyAllright')                                 # Send the time to the client
# JSON.parse(string) Method


  #TAKE STRING FROM THE CLIENT AND PARSE
  readString= client.read
  puts readString

begin
    string = JSON.parse(readString)
    analyse(string,c,con,client)

  #rescue JSON::ParserError => e
  # client.puts "{\"error\":\"parsejson\"}"
  # sendError(client,e)

end





  #CLOSE connection
  client.puts "closing connection..."
  client.close

}
