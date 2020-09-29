# Add a class method to your MyCar class that calculates the gas mileage of any car.

class MyCar
  attr_accessor :color
  attr_reader :year, :model

  def self.mileage(miles, gallons)
    (miles / gallons.to_f).round(2)
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def to_s
    "A very respectable #{color} #{year} #{model.capitalize}."
  end

  def turn_off
    @speed = 0
    puts "You have parked the car."
  end

  def speed_up(acceleration)
    @speed += acceleration
    puts "You have sped up and are going #{@speed} mph."
  end

  def brake(deceleration)
    @speed -= deceleration
    @speed = 0 if @speed < 0
    puts "You have slowed down and are going #{@speed} mph."
  end

  def spray_paint(new_color)
    self.color = new_color
    puts "You have painted the car #{color}."
  end
end

puts MyCar.mileage(10_000, 435)

car = MyCar.new(2000, 'green', 'volkswagen beetle')
puts car


class Person
  attr_accessor :name

  def initialize(name)
    # @name = name
    self.name = name    # should we also use setter method in the constructor?
  end
end

bob = Person.new("Steve")
p bob.name
bob.name = "Bob"
p bob.name
