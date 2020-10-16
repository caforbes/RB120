class SecretFile
  def initialize(secret_data, security_log)
    @data = secret_data
    @security_log = security_log
  end

  def read_data
    @security_log.create_log_entry
    @data
  end

  # private
  # attr_reader :data  # => these can be accessed with instance_variable_get
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
    puts "I made a log entry"
  end
end

secrets = SecretFile.new("my private!!", SecurityLogger.new)

secrets.read_data
# puts secrets.instance_variable_get(:@data)


module Moveable
  attr_accessor :speed, :heading

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class WaterVehicle
  include Moveable

  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    # ... code omitted ...
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    super + 10
  end
end

class Catamaran < WaterVehicle
end

class Motorboat < WaterVehicle
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

car = Auto.new
p car.range