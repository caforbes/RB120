class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name}!"
  end

  # def name  # => equivalent
  #   @name
  # end
end

kitty = Cat.new('Sophie')
kitty.greet
