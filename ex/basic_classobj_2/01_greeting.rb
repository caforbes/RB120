class Cat
  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end
end

Cat.generic_greeting

kitty = Cat.new
kitty.class.generic_greeting
# works just like Cat.generic_greeting because the return value of class is
# the Cat class as an object, not just a string with the same value as the
# class name. When the Cat class is returned as an object, class methods can
# then be called on it as usual.
