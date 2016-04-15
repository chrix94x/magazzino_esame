




# TODO: try all the errors in queries
#CREATE CLASS
class Shop
  def listAll(con,client)
    puts "start the select"
    results = con.query("SELECT * FROM magazzino_scorza.prodotti")

   # count = 0
   totRows = results.count


    count=0;
    client.puts "["
    results.each do |results|


      #puts results.to_json

      client.puts results.to_json

      if (count<totRows-1)
        client.puts ","
      end

        count = count + 1
      #ios block here WHY?? maybe doesn't accept other puts...

      #client.puts results.to_json

     # msg = " #{count}\n"

     # client.puts msg

    end

    client.puts "]"


  rescue Mysql2::Error => e
  sendError(client,e)

  end

  def insert(con,client,description,quantity,price,color,brand,model,barcode)
   con.query("INSERT INTO magazzino_scorza.prodotti(descrizione,quantita,prezzo,colore,marca,modello,barcode)
      VALUES('#{description}','#{quantity}','#{price}','#{color}','#{brand}','#{model}','#{barcode}')")
    #client.puts "added with no error."
  rescue Mysql2::Error => e
    sendError(client,e)

  end

  def remove(con,client,barcode)
   con.query("UPDATE magazzino_scorza.prodotti SET quantita=quantita-1
   where barcode='#{barcode}'")
    #client.puts "-1 removed"
  rescue Mysql2::Error => e
    sendError(client,e)

  end

  def removeAll(con,client,barcode)
    con.query("UPDATE magazzino_scorza.prodotti SET quantita=0
   where barcode='#{barcode}'")
   # client.puts "removed all"
  rescue Mysql2::Error => e
    sendError(client,e)

  end

  def deleteProduct(con,client,barcode)
    con.query("delete from magazzino_scorza.prodotti
    where barcode='#{barcode}'")
   # client.puts "product deleted"
  rescue Mysql2::Error => e
    sendError(client,e)

  end

  def changePrice(con,client,barcode,price)
    con.query("UPDATE magazzino_scorza.prodotti set prezzo='#{price}' where barcode='#{barcode}'")
  #  client.puts "price changed"
  rescue Mysql2::Error => e
    sendError(client,e)

  end
end




#send error in json to client

def sendError(client,e)
  #doesn't works.
 # h = ["errno" => e.errno, "error" => e.error]
  client.close
 end



#parse json and call the class for the queries

def analyse(string,c,con,client)
#puts "\nis in analyse method!"
 # puts string

  #ALL VARIABLES
  command = string["command"]
  description = string["description"]
  quantity = string["quantity"]
  price = string["price"]
  color = string["color"]
  brand = string["brand"]
  model = string["model"]
  barcode = string["barcode"]

#puts "\n this is the command \n"
#puts command

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
    else
      client.puts "commmand not implemented"
  end

end



def processStr(readString,con,client)

  puts "it is entered in processStr  function"

  begin
    # parse json
    data = JSON.parse(readString)
    puts data

    command = data["command"]
    puts "this is the command " + command
    # create the obj used in switch

    queryObject= Shop .new

    # call the method that analyse the json code.
    analyse(data,queryObject,con,client)

  rescue JSON::ParserError => e
    client.puts "{\"error\":\"parsejson\"}"
    sendError(client,e)
  end

end

#results= con.query("SELECT * FROM magazzino_scorza.prodotti")
#loop for the connection


#UPDATE magazzino_scorza.prodotti SET quantita=quantita-5 where barcode=''
#UPDATE magazzino_scorza.prodotti set prezzo=1490 where modello='pro'
#update magazzino_scorza.prodotti set quantita=quantita-1 where barcode='332234432'

#rescue Mysql2::Error => e
#puts e.errno
#puts e.error