=begin
Create a class called MyCar.
When you initialize a new instance or object of the class, allow the user to
define some instance variables that tell us the year, color, and model of
the car.
Create an instance variable that is set to 0 during instantiation of the object
to track the current speed of the car as well.
Create instance methods that allow the car to speed up, brake, and shut the car off.
=end

class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
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

car = MyCar.new(2000, 'green', 'volkswagen beetle')
p car
car.speed_up(15)
car.brake(20)
car.turn_off
car.spray_paint('blue')
