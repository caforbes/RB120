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
  attr_accessor :year, :color, :model, :speed, :on

  def initialize(year, color, model)
    self.year = year
    self.color = color
    self.model = model
    self.speed = 0
  end

  def info
    "a #{year}-model #{color} #{model}"
  end

  def start
    self.on = true
  end

  def speed_up(acceleration)
    self.speed = self.speed + acceleration
  end
end

car = MyCar.new(2000, 'green', 'volkswagon')
p car.info
car.speed_up(15)
p car.speed