class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

hot_pizza = Pizza.new("cheese")
orange    = Fruit.new("apple")

p hot_pizza.instance_variables
p orange.instance_variables

puts hot_pizza, orange
# puts gives the Class and objectid
p hot_pizza, orange
# p gives the instance variables as well