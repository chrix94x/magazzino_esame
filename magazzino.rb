#LIBRARY
require 'socket'
require 'rubygems'
require 'json'
require 'mysql2'

#myFiles
load 'Classes.rb'


#CONNECTION WITH MYSQL AND CLIENT
con = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "yesyesyes")
server = TCPServer.open('localhost',2000)


#INSTANCE CLASS
c= Shop .new

loop {

  #CONNECT TO THE CLIENT
  client = server.accept
client.puts(Time.now.ctime)


  #TAKE STRING FROM THE CLIENT AND PARSE
  readString= client.read
  string = JSON.parse(readString)


  #ALL VARIABLES
  command= string["command"]
  description=string["description"]
  quantity=string["quantity"]
  price= string["price"]
  color= string["color"]
  brand= string["brand"]
  model= string["model"]
  barcode=string["barcode"]


  #SWITCH CASE
  case command
    when "list"
      c.listAll(con,client)
    when "insert"
      c.insert(con,client,description,quantity,price,color,brand,model,barcode)
    when "remove" #decrementQuantity
      c.remove(con,client,barcode)
    when "removeAll" #clearQuantity
      c.removeAll(con,client,barcode)
    when "delete"
      c.deleteProduct(con,client,barcode)
    when "changePrice"
      c.changePrice(con,client,barcode,price)
  end




  #CLOSE connection
  client.puts "closing connection..."
  client.close

}