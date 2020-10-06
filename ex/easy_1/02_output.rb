class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

=begin
  The call to to_s converts the name into a string for future use in the class,
  but also has the result of assigning the instance variable @name to a
  different object than the object referred to by the local variable name, an
  Integer. We can independently increment the Integer name variable, but not the
  string @name variable -- and incrementing name has no effect on @name.
=end
