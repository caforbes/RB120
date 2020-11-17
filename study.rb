class MyClass
  def initialize
    @name = "Default"
  end

  def name
    @name
  end

  def name=(new_name)
    @name = new_name
  end
end

artemis = MyClass.new

puts artemis.name
artemis.name = "Artemis"
puts artemis.name
