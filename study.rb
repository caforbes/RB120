class Fish
  attr_reader :length

  def initialize(length)
    @length = length
  end

  def ==(other)
    length == other.length
  end
end

a = Fish.new(20)
b = Fish.new(20)

puts a == b   # => true
puts a === b   # => true
