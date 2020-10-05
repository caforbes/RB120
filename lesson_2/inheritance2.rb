class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end

pete = Pet.new
puts pete.run                # => "running!"
# puts pete.speak              # => NoMethodError

kitty = Cat.new
puts kitty.run               # => "running!"
puts kitty.speak             # => "meow!"
# puts kitty.fetch             # => NoMethodError

dave = Dog.new
puts dave.speak              # => "bark!"

bud = Bulldog.new
puts bud.run                 # => "running!"
puts bud.swim                # => "can't swim!"


# 3

# Pet - Dog - Bulldog
#     - Cat
