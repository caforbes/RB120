module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

puts Orange.new.class.ancestors
# ancestors is a class method


class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end


class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

puts Cat.cats_count
Cat.new('tabby')
Cat.new('calico')
puts Cat.cats_count # == 2


=begin
  code can be made less repetitive by abstracting broad-purpose methods to
  superclasses or methods, then inherited or mixed in to the proper objects

  Relationships between types of objects can be represented with sub/superclasses,
  and the logic of the elements of the program. -- think abstractly about the
  concept of the program

  objects contain many properties and states and can internally operate on any
  of them, reducing the need for variables to be passed as arguments over+over.

  Objects (nouns) are easier to conceptualize

  Growing complexity of a program can be more easily managed as much logic is
  always contained within an object and doesn't interact with the areas that grow
=end