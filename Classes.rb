




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

           if checkBarcode(con,client,barcode) then
             sendResultOne(client)
           end


            rescue Mysql2::Error => e
            sendError(client,e)

          end

        def remove(con,client,barcode)
          #check if exists the barcode
          puts "entered in remove"
          if checkBarcode(con,client,barcode) then
             #if exist decrement quantity
             con.query("UPDATE magazzino_scorza.prodotti SET quantita=quantita-1
             where barcode='#{barcode}'")
             print "cecked barcode"
             #and send message to client
             sendResultOne(client)
          end
          rescue Mysql2::Error => e
          sendError(client,e)
          end


        def removeAll(con,client,barcode)
          #check if barcode exist
          if checkBarcode(con,client,barcode) then
            #if exist
          con.query("UPDATE magazzino_scorza.prodotti SET quantita=0
         where barcode='#{barcode}'")
          sendResultOne(client)
          end

        rescue Mysql2::Error => e
          sendError(client,e)
        end

        def deleteProduct(con,client,barcode)
          #check if barcode exist
          if checkBarcode(con,client,barcode) then
            #if exist
            con.query("delete from magazzino_scorza.prodotti
            where barcode='#{barcode}'")
            sendResultOne(client)
          end

        rescue Mysql2::Error => e
          sendError(client,e)
        end

        def changePrice(con,client,barcode,price)
          #check if barcode exist
          if checkBarcode(con,client,barcode) then
            #if exist
            con.query("UPDATE magazzino_scorza.prodotti set prezzo='#{price}' where barcode='#{barcode}'")
            sendResultOne(client)
          end

        rescue Mysql2::Error => e
          sendError(client,e)
        end

      end

      def checkBarcode(con,client,barcode)
        result =con.query("SELECT barcode FROM magazzino_scorza.prodotti
         where barcode='#{barcode}'")

        #If the barcode is not in the server.
        if(result.count == 0)
         sendResultzero(client)
          return false
        end

        return true
      end


      #message json FALSE
      def sendResultzero(client)
        puts "sent result"
        #client.puts "["
        client.puts "{\"result\":\"0\"}"
        #client.puts "]"
        client.close
      end
      #message json TRUE
      def sendResultOne(client)
        #client.puts "["
        client.puts "{\"result\":\"1\"}"
        #client.puts "]"
        puts "sent result one "
        client.close
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
          client.close
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