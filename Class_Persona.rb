class Persona
def initialize(nome="non so chi sei ma")
@nome=nome
puts "mi presento, sono #{nome}"
end
def saluta
puts "ciao #{@nome} io sono ruby!"
  end
def arrivederci
  puts "arrivederci #{@nome} a presto!"
end
end

