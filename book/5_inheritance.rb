# Create a superclass called Vehicle for your MyCar class to inherit from
# and move the behavior that isn't specific to the MyCar class to the superclass.

# Create a constant in your MyCar class that stores information about the vehicle that makes it different from other types of Vehicles.

# Then create a new class called MyTruck that inherits from your superclass
# that also has a constant defined that separates it from the MyCar class in some way.

module Off_road_able
  def offroad(terrain)
    puts "Yeah!! You totally drove over the #{terrain}!!"
  end
end

class Vehicle
  @@num_of_vehicles = 0

  def self.mileage(miles, gallons)
    (miles / gallons.to_f).round(2)
  end

  def self.how_many_vehicles
    puts "There are #{@@num_of_vehicles} vehicles on the road."
  end

  attr_accessor :color
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year.to_i
    @color = color
    @model = model
    @speed = 0
    @@num_of_vehicles += 1
  end

  def turn_off
    @speed = 0
    puts "You have parked."
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
    puts "You have a new #{color} paintjob. Looking good!"
  end

  def age
    puts "Your #{self.model} is #{yrs_old} years old."
  end

  private

  def yrs_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  VEHICLE_TYPE = "car"

  def to_s
    "This car is a very respectable #{color} #{year} #{model}."
  end
end

class MyTruck < Vehicle
  include Off_road_able

  VEHICLE_TYPE = "truck"

  def to_s
    "This truck is a very respectable #{color} #{year} #{model}."
  end
end

bug = MyCar.new(1999, "blue", "Volkswagen Beetle")
pickup = MyTruck.new(1983, "white", "pickup")

# Add a class variable to your superclass that can keep track of the number of objects
# created that inherit from the superclass.
# Create a method to print out the value of this class variable as well.

Vehicle.how_many_vehicles

# Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.

pickup.offroad('volcano')

# Print to the screen your method lookup for the classes that you have created.

p Vehicle.ancestors
p MyCar.ancestors
p MyTruck.ancestors

# Move all of the methods from the MyCar class that also pertain to the MyTruck
# class into the Vehicle class.
# Make sure that all of your previous method calls are working when you are finished.

test_vehicle = pickup
test_vehicle.speed_up(40)
test_vehicle.brake(20)
test_vehicle.turn_off
p test_vehicle.color
test_vehicle.spray_paint('red')

# Write a method called age that calls a private method to calculate the age of the vehicle.
# You'll need to use Ruby's built-in Time class to help.
# Make sure the private method is not available from outside of the class.

# puts pickup.yrs_old
pickup.age



# Create a class 'Student' with attributes name and grade.
# Do NOT make the grade getter public, so joe.grade will raise an error.
# Create a better_grade_than? method, that you can call like so...

class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected
  attr_reader :grade
end

juliet = Student.new("Juliet", 87)
spartacus = Student.new("Spartacus", 50)

puts "Well done!" if juliet.better_grade_than?(spartacus)
# puts juliet.grade



# Given the following code...

  # bob = Person.new
  # bob.hi

# And the corresponding error message...

  # NoMethodError: private method `hi' called for #<Person:0x007ff61dbb79f0>
  # from (irb):8
  # from /usr/local/rvm/rubies/ruby-2.0.0-rc2/bin/irb:16:in `<main>'

# What is the problem and how would you go about fixing it?

=begin
  Hi is a private method, so I would either make it public if that were
  appropriate, or I would make a public-facing hi method that references
  the private hi method.
=end