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

#INSTANCE CLASS

queryObject= Shop .new

loop {


  #CONNECT TO THE CLIENT

  client = server.accept

  #client.puts(Time.now.ctime+'rubyAllright')


#TAKE STRING FROM THE CLIENT AND PARSE


  readString= client.read
  puts "\n client message:\n\n "+ readString
    begin
      string = JSON.parse(readString)
      analyse(string,queryObject,con,client)
      rescue JSON::ParserError => e
      client.puts "{\"error\":\"parsejson\"}"
     # sendError(client,e)

    end

  client.close

}
