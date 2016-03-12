
#CREATE CLASS
class Shop
  def listAll(con,client)
    results= con.query("SELECT * FROM magazzino_scorza.prodotti")
    results.each do |results|
      client.puts results.to_json
      puts results.to_json
    end
  end

  def insert(con,client,description,quantity,price,color,brand,model,barcode)
   con.query("INSERT INTO magazzino_scorza.prodotti(descrizione,quantita,prezzo,colore,marca,modello,barcode)
      VALUES('#{description}','#{quantity}','#{price}','#{color}','#{brand}','#{model}','#{barcode}')")
    client.puts "added with no error."
  end

  def remove(con,client,barcode)
   con.query("UPDATE magazzino_scorza.prodotti SET quantita=quantita-1
   where barcode='#{barcode}'")
    client.puts "-1 removed"
  end

  def removeAll(con,client,barcode)
    con.query("UPDATE magazzino_scorza.prodotti SET quantita=0
   where barcode='#{barcode}'")
    client.puts "removed all"
  end

  def deleteProduct(con,client,barcode)
    con.query("delete from magazzino_scorza.prodotti
    where barcode='#{barcode}'")
    client.puts "product deleted"
  end

  def changePrice(con,client,barcode,price)
    con.query("UPDATE magazzino_scorza.prodotti set prezzo='#{price}' where barcode='#{barcode}'")
    client.puts "price changed"
  end
end





#results= con.query("SELECT * FROM magazzino_scorza.prodotti")
#loop for the connection


#UPDATE magazzino_scorza.prodotti SET quantita=quantita-5 where barcode=''
#UPDATE magazzino_scorza.prodotti set prezzo=1490 where modello='pro'
#update magazzino_scorza.prodotti set quantita=quantita-1 where barcode='332234432'