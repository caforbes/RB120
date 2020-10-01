class Cat
  def self.generic_greeting
    puts "Hi, I'm a cat."
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def personal_greeting
    puts "Hi there! I'm a cat and my name is #{name}."
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting
