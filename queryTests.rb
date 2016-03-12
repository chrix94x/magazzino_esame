#!/usr/bin/ruby

require 'mysql2'


# https://richonrails.com/articles/getting-started-with-mysql-and-ruby-on-rails


begin
  con = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "yesyesyes")

  results = con.query("SELECT * FROM magazzino_scorza.prodotti")



  con.query("INSERT INTO magazzino_scorza.prodotti(descrizione,quantita,prezzo) VALUES('testmysql','10','10')")



  results = con.query("SELECT * FROM magazzino_scorza.prodotti")




  results.each do |result|
    #puts result["DESCR"]

    puts result

  end



Class CreateQuery

  def initialize(descrizione="errato",quantita="-1",prezzo="0")
@descrizione=descrizione
@quantita=quantita
@prezzo=prezzo
  end

  def insertinto
    con.query("INSERT INTO magazzino_scorza.prodotti(descrizione,quantita,prezzo)
  VALUES('#{@descrizione}','#{quantita}','#{@prezzo}')")
  end

  def delete
    con.query("DELETE FROM magazzino_scorza.prodotti where descrizione=#{@descrizione}")
  end
end







#	puts con.get_server_info
#	rs = con.query 'SELECT VERSION()'
#	puts rs.fetch_row
#
#	rescue Mysql::Error => e
#	puts e.errno
#	puts e.error

#	ensure
#	con.close if con

