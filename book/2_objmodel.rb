# How do we create an object in Ruby? Give an example of the creation of an object.

# An object is a specific instantiation of a particular Class.
# To create an object, we create a new member of a specific class.

p String.new()
p Array.new()

# We can also define our own classes and instantiate new instances of them.

class Cat
  # ...
end

p Cat.new()



# What is a module? What is its purpose? How do we use them with our classes?
# Create a module for the class you created in exercise 1 and include it properly.

# A module can be used to store methods that you may want several classes
# to use, so that each class can refer to the same method instead of needing
# to independently write and store it in each class.

# > modules extend functionality to a class

module PetInteractions
  def play(toy)
    puts "Your pet is playing with the #{toy}. It's so cute!"
  end
end

class Kitty
  include PetInteractions
end

maddy = Kitty.new
maddy.play("ball")

# > modules give namespacing: allow us to better understand the sense/purpose
# of a class by organizing it in a descriptive way.

module Pets
  class Dog
  end

  class Cat
  end
end

p Pets::Cat.new
