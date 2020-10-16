class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    Hello.new.hi
  end

  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi


class Cat
  def initialize(type)
    @type = type
  end

  def to_s # display_type --> and puts result, more informative
    "I am a #{@type} cat."
  end
end

tabby = Cat.new('tabby')
puts tabby